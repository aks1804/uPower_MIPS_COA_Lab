/* 
The following code contains an ALU Module for the MIPS ISA which takes in the opcode, contents of the registers, shiftAmount, ALUResult and AluSrc signals
with the signed Immediate as arguments
*/
/*
Done by:
Name					RollNumber
Pranav V. Kumar			181CO239
Ankush Chandrashekar	181CO209
Mohammed Rushad			181CO232
Akshat Nambiar			181CO204

Date: 15-03-2020  
*/
module ALU64bit(
    output reg [63:0] ALU_result,
    output reg Branch,
    input [5:0] opcode,
    input [4:0] rs, rt, bo, bi,
    input [15:0] si,
    input [13:0] ds, 
    input [9:0] xox,
    input [8:0] xoxo,
    input aa, 
    input [1:0] xods);

    reg signed [63:0] temp, signed_rt, signed_rs;
    reg [63:0] zeroExtendSI, signExtendSI, zeroExtendDS;

	
    always @(rs, rt, si, xoxo, xox, xods, bo, bi, aa, ds)
    begin

      signed_rs = rs;
      signed_rt = rt;

      if(opcode == 6'd31 & xoxo != 9'd0)    //XO Format
      begin
          
          case(xoxo)

            9'd266: //ADD
                ALU_result = signed_rs + signed_rt;
            9'd40 : //SUBF
                ALU_result = signed_rt - signed_rs;
          endcase
      end  

      else if(opcode == 6'd31 & xox != 10'd0)   //X Format
      begin

        case(xox)

            10'd28: //AND
                ALU_result = rt & rs;
            10'd476: //NAND
                ALU_result = ~(rs & rt);
            10'd444: //OR
                ALU_result = rs | rt;
            10'd316: //XOR
                ALU_result = rs ^ rt;
            10'd986: //EXTSW
                ALU_result = {{32{rt[31]}}, rt[31:0]};
        endcase
      end

      else if(opcode == 6'd19)      //B Format 
      begin
        if(aa == 1) //BEQ
        begin
          ALU_result = signed_rs - signed_rt;
          if(ALU_result == 0)
              Branch = 1'b1;
          else
              Branch = 1'b0;
        end
        else if(aa == 0) //BNE
        begin
            ALU_result = signed_rs - signed_rt;
            if(ALU_result != 0)
            begin
              Branch = 1'b1;
              ALU_result = 1'b0;
              end
            else
              Branch = 1'b0; 
        end
      end

      else if(opcode == 6'd18) //I Format
            Branch = 1'b1;
    
      else if(opcode == 6'd14)      //D Format
      begin
		  zeroExtendSI = {{48{1'b0}}, si[15:0]};
		  signExtendSI = {{48{si[15]}}, si[15:0]};
          case(opcode)

            6'd14: //ADDI
                ALU_result = rt + zeroExtendSI;
            6'd15: //ADDIS
                ALU_result = rt + signExtendSI;
            6'd28: //ANDI
                ALU_result = rt & zeroExtendSI;
            6'd24: //ORI
                ALU_result = rt | zeroExtendSI;
            6'd26: //XORI
                ALU_result = rt ^ zeroExtendSI;
            6'd32: //LW0
                ALU_result = rt + zeroExtendSI;
            6'd36: //SW
                ALU_result = rt + signExtendSI;
            6'd37: //SWU
            begin
                ALU_result = rt + signExtendSI;
               //rt = ALU_result;
            end
            6'd40: //LHW
                ALU_result = rt + signExtendSI;
            6'd42: //LHWA
                ALU_result = rt + signExtendSI;
            6'd44: //SHW
                ALU_result = rt + signExtendSI;
            6'd34: //LB0    
                ALU_result = rt + zeroExtendSI;
            6'd38: //SB
                ALU_result = rt + signExtendSI;
          endcase
      end  

      else if(ds != 14'b0)      //DS Format
      begin
		zeroExtendDS = {{50{1'b0}}, ds[13:0]};
        if(opcode == 6'd58)
            ALU_result = rt + zeroExtendDS;
        else if(opcode == 6'd62)
            ALU_result = rt + zeroExtendDS;  
      end
    end

	
endmodule

module alu_tb;

    wire [63:0] ALU_result;
    wire Branch;
    reg [5:0] opcode;
    reg [4:0] rs;
	reg [4:0] rt;
	reg [4:0] bo;
	reg [4:0] bi;
    reg [15:0] si;
    reg [13:0] ds; 
    reg [9:0] xox;
    reg [8:0] xoxo;
    reg aa;
    reg [1:0] xods;

initial begin
	$dumpfile("uPOWERALU.vcd");
	$dumpvars(0,alu_tb);	
    $monitor("Opcode : %d, RS : %d, RT : %d, Result : %64b\n",
        opcode, rs, rt, ALU_result);

	opcode = 6'b0;
	rs = 5'd8;
	rt = 5'd7;
	xoxo = 9'd0;
	xox = 10'd0;
	si = 16'b0;
	bo = 5'b0;
	bi = 5'b0;
	ds = 14'b0;
	aa = 1'b0;
	xods = 2'b0;
	 
	 
	#10 //ADD
	opcode = 6'd31;
	rs = 5'd8;
	rt = 5'd7;
	xoxo = 9'd266;
	xox = 10'd0;
	si = 16'b0;
	#10 //SUBF
	opcode = 6'd31;
	rs = 5'd8;
	rt = 5'd7;
	xoxo = 9'd40;
	xox = 10'd0;
	si = 16'b0;
	#10 //AND
	opcode = 6'd31;
	rs = 5'd8;
	rt = 5'd7;
	xoxo = 9'd0;
	xox = 10'd28;
	si = 16'b0;
	#10 //ADDI
	opcode = 6'd14;
	rs = 5'd8;
	rt = 5'd7;
	xoxo = 9'd0;
	xox = 10'd0;
	si = 16'b10;

	
	#10 $finish;
end

ALU64bit t(
	.ALU_result(ALU_result),
	.Branch(Branch),
	.opcode(opcode),
	.rs(rs),
	.rt(rt),
	.bo(bo),
	.bi(bi),
	.si(si),
	.ds(ds),
	.xox(xox),
	.xoxo(xoxo),
	.aa(aa),
	.xods(xods)
);
endmodule



