'''
This is the Assembler for the uPower ISA.

Group Members
1. Pranav Vigneshwar Kumar - 181CO239
2. Ankush Chandrashekar - 181CO206
3. Mohammed Rushad - 181CO232
4. Akshat Nambiar - 181CO204
'''



import re
import sys


def make_binary(encodee, siz):
    binary_num = ""
    if encodee < 0:
        present_ind = siz - 2
        ans = -(1 << (siz - 1))
        binary_num += "1"
        while present_ind >= 0:
            if encodee - ans >= (1 << present_ind):
                ans += 1 << present_ind
                binary_num += "1"
            else:
                binary_num += "0"
            present_ind -= 1
    else:
        if siz == 24:
            binary_num += "{:024b}".format(encodee)
        else:
            binary_num += "{:032b}".format(encodee)


    return binary_num

##############################FIRST###PASS#####################################


def first_pass(ip_lines):
    text_section = 0
    data_section = 0
    f = ip_lines
    instruction_store = {}
    curr_ptr = 0x4000000
    text = {}   
    for i in range(len(f)):
    	#checks and sets the index for the start of the text section
        if f[i] == ".text":
            text_section = i  
        #check and sets the index for the start of the data section 
        if f[i] == ".data":
            data_section = i 


    split_var = re.compile(r".+:")	#finds the variable name for a label in the assembly code
    #Processes the text section
    for i in range(text_section + 1, len(f)):
        if bool(split_var.match(f[i])):  
            x = re.split(":", f[i]) 
            #address corresponding to the label is stored
            text[x[0]] = hex(curr_ptr) 
            curr_ptr -= 4
        else:
            temp_var = f[i].split("#")[0]
            temp_var = " ".join(temp_var.split())
            if temp_var.strip():
                instruction_store[curr_ptr] = temp_var
            else:
                curr_ptr = (
                    curr_ptr - 4
                )  
        curr_ptr += 4


    curr_ptr = 0 
    data = {}
    segment_data = {}
    

    #Processes the data section
    for i in range(data_section + 1, text_section):
        if bool(split_var.match(f[i])): 
            store = f[i].split()
            lable = re.split(":", store[0])[0]  
            
            data[lable] = hex(curr_ptr)
            datatype = store[1][1:]  
            start_ptr = curr_ptr

            if datatype == "word":
                binary_num = ""
                cntr = 0
                for k in range(2, len(store) - 1):
                    l = store[k].index(",")
                    binary_num += make_binary(int(store[k][0:l]), 32)
                    cntr += 1
                binary_num += make_binary(int(store[-1]), 32)
                curr_ptr += 4 * (cntr + 1)
            elif datatype == "halfword":
                binary_num = "{:016b}".format(int(store[2]))
                curr_ptr += 2
            elif datatype == "byte":
                binary_num = "{:08b}".format(int(store[2])).strip()
                curr_ptr += 1
            elif datatype == "asciiz":             
                binary_num = ""
                cntr = 0
                flag = 0   
                for ch in f[i]:
                    if ch == '"' and flag == 0:  
                        flag = 1
                        continue
                    if flag == 1 and ch != '"':
                        binary_num += "{:032b}".format(ord(ch))
                        cntr = cntr + 1
                    if flag == 1 and ch == '"':
                        flag = 0
                        binary_num += "{:032b}".format(0)
                        cntr = cntr + 1
                        break
                curr_ptr += cntr * 4
            elif datatype == "space":
                binary_num = []
                for byte in int(store[2]):
                    binary_num += "{:08b}".format(0)
                curr_ptr += int(store[2])
            else:
                print("DATA ERROR!!")
            segment_data[start_ptr] = binary_num


    return (instruction_store, segment_data, text, data)

    
##############################SECOND###PASS#####################################


regtonum = {"R" + str(i): i for i in range(32)}
final_ans = {}  


X = {
    "and": [31, None, 0, 28, None, None], "nand": [31, None, 0, 476, None, None],"or": [31, None, 0, 444, None, None],
    "xor": [31, None, 0, 316, None, None],"sld": [31, None, 0, 794, None, None], "cmp": [31, None, 0, 0, None, None],
    "exstw": [31, None, 0, 986, None, None],
}
D = {
    "addi": [14, None, None, None, None, 0],"addis": [15, None, None, None, None, 0],"ori": [24, None, None, None, None, 0],
    "xori": [26, None, None, None, None, 0], "andi": [28, None, None, None, None, 0],"lwz": [32, None, None, None, None, 1],
    "lbz": [34, None, None, None, None, 1],"stw": [36, None, None, None, None, 1],"stwu": [37, None, None, None, None, 1],
    "stb": [38, None, None, None, None, 1],"sth": [44, None, None, None, None, 1],
}
XO = {
    "add": [31, 0, 0, 266, None, None],"subf": [31, 0, 0, 40, None, None],
}


others = {"bc": [19, 0, 0], "sc": [17, 0, 0], "b": [18]}


def X_type(instrtn, req, a):
    binary_num = ""
    binary_num += "{:06b}".format(X[instrtn][0])
    binary_num = binary_num + "{:05b}".format(regtonum[req[1]])
    try:
        binary_num = binary_num + "{:05b}".format(regtonum[req[0]])
    except:
        binary_num = binary_num + "{:05b}".format(int(req[0]))
    binary_num = binary_num + "{:05b}".format(regtonum[req[2]])
    binary_num = binary_num + "{:010b}".format(X[instrtn][3]) + "0"
    binary_num = binary_num.replace("0b", "")
    final_ans[a] = binary_num


def D_type(instrtn, req, a):
    binary_num = ""
    if D[instrtn][-1] == 1:
        RT = req[0].strip()
        i1 = req[1].index("(")
        i2 = req[1].index(")")

        SI = int(req[1][:i1].strip())
        RA = req[1][i1 + 1 : i2].strip()

        binary_num += "{:06b}".format(D[instrtn][0])
        binary_num += "{:05b}".format(regtonum[RT])
        binary_num += "{:05b}".format(regtonum[RA])
        binary_num += "{:016b}".format(SI)
        binary_num = binary_num.replace("0b", "")
        final_ans[a] = binary_num

    elif D[instrtn][-1] == 0:
        binary_num += "{:06b}".format(D[instrtn][0])
        binary_num += "{:05b}".format(regtonum[req[0]])
        binary_num += "{:05b}".format(regtonum[req[1]])
        binary_num += "{:016b}".format(int(req[2]))
        binary_num = binary_num.replace("0b", "")
        final_ans[a] = binary_num

    else:
        print("\n\nERROR WITH INTRUCTION TYPE!!\n\n")

    final_ans[a] = binary_num


def XO_type(instrtn, req, a):
    binary_num = ""
    binary_num += "{:06b}".format(XO[instrtn][0])
    binary_num += "{:05b}".format(regtonum[req[0]])
    binary_num += "{:05b}".format(regtonum[req[1]])
    binary_num += "{:05b}".format(regtonum[req[2]])
    binary_num += "{:01b}".format(XO[instrtn][1])
    binary_num += "{:09b}".format(XO[instrtn][3]) + "0"
    binary_num = binary_num.replace("0b", "")
    final_ans[a] = binary_num


def b_type(instrtn, req, a, label):
    binary_num = "{:06b}".format(others["b"][0])
    req_instruction = int(label[req[0]], 16)
    curr_instruction = a
    encodee = req_instruction - curr_instruction
    binary_num += make_binary(encodee, 24)
    binary_num += "00"
    final_ans[a] = binary_num


def sc(instrtn, req, a, label):
    binary_num = "{:06b}".format(others["sc"][0])
    binary_num += "{:026b}".format(0)

    final_ans[a] = binary_num


def bc(instrtn, req, a, label):
    binary_num = ""
    binary_num += "{:06b}".format(others["bc"][0])
    binary_num += "{:05b}".format(int(req[0]))
    binary_num += "{:05b}".format(int(req[1]))
    binary_num += "{:014b}".format(int(label[req[2]], 16) - a)
    binary_num += "{:02b}".format(0)
    final_ans[a] = binary_num


def la(instrtn, req, a, data):
    binary_num = ""
    try:
        RT = req[0].strip()
        i1 = req[1].index("(")
        i2 = req[1].index(")")
        SI = int(req[1][:i1].strip())
        RA = req[1][i1 + 1 : i2].strip()
        binary_num += "{:06b}".format(D["addi"][0])
        binary_num += "{:05b}".format(RT)
        binary_num += "{:05b}".format(RA)
        binary_num += "{:016b}".format(SI)
    except:
        RT = req[0].strip()
        SI = data[req[1].strip()]
        binary_num += "{:06b}".format(D["addi"][0])
        binary_num += "{:05b}".format(regtonum[RT])
        binary_num += "{:05b}".format(0)
        binary_num += "{:016b}".format(int(SI, 16))
    final_ans[a] = binary_num


#Make all the instructions in binary
def make_instruction(ip_lines, label, data, segment_data):  
    for l in ip_lines:
        b = ip_lines[l]
        a = l        
        instrtn = b[: b.index(" ")]
        argmnt = b[b.index(" ") :]
        req = argmnt.split(",")
        req = [i.replace(" ", "") for i in req]

        if instrtn in X.keys():
            X_type(instrtn, req, a)
        elif instrtn in XO.keys():
            XO_type(instrtn, req, a)
        elif instrtn in D.keys():
            D_type(instrtn, req, a)
        elif instrtn == "la":
            la(instrtn, req, a, data)
        elif instrtn == "bc":
            bc(instrtn, req, a, label)
        elif instrtn == "sc":
            sc(instrtn, req, a, label)
        elif instrtn == "b":
            b_type(instrtn, req, a, label)
        else:
            break

    return final_ans

#Main function which brings together all the different functions  
def main():
    ip_file = input("Name of file to assemble(.txt):     ")
    if len(ip_file) >= 1:
        with open(ip_file, encoding="utf-8", mode="r") as open_file:
            lines = open_file.read().splitlines()

            (instruction_store, segment_data, label, data) = first_pass(lines)

            binary_num = make_instruction(instruction_store, label, data, segment_data)

            with open("simulator_input.txt", mode="w") as open_file:
                binary_num_final = sorted([(i, binary_num[i]) for i in binary_num])
                binary_num_final = [a[1] for a in binary_num_final]
                binary_num_final = "".join(binary_num_final)
                segment_final = sorted([(i, segment_data[i]) for i in segment_data])
                segment_final = [a[1] for a in segment_final]
                segment_final = "".join(segment_final)
                text_size = int(len(binary_num_final) / 32)
                text_size_b = "{:032b}".format(text_size)
                data_size = int(len(segment_final) / 32)
                data_size_b = "{:032b}".format(data_size)

                open_file.write(text_size_b)
                open_file.write(data_size_b)
                open_file.write(binary_num_final)
                open_file.write(segment_final)

    else:
        print("FILENAME ERROR!!")

    print("\nYour instructions:\n")
    for instrtn in instruction_store.keys():
        print(instruction_store[instrtn])

    print("\n")

    print("Data Section (storage location):\n")
    for dat in data.keys():
        print(dat, data[dat], sep="=")

    print("")
    print("\nData stored at specified locations")
    for binary_seg in segment_data.keys():
        print(binary_seg, segment_data[binary_seg], sep=" ---> ")
    print("\n")


    print("Found labels:\n")
    for label_name in label.keys():
        print(label_name, label[label_name], sep="\t---\t")

    print("\n")

    print("Text section (instructions stored in binary format):\n")
    for binary_text in binary_num.keys():
        print(binary_num[binary_text])



    print("\n\n.\n.\n.\nYour file " + ip_file +  " has been assembled as \"simulator_input.txt\"\n")
if __name__ == "__main__":
    main()

