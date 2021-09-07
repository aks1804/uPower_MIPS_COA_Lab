/* Module designed to read the instruction and assign the various
   components of the instruction to suitable variables depending on the format
*/

module parse_instruction(
    output wire [5:0] po, 
    output reg [4:0] rs, rt, rd, bo, bi, 
    output reg aa, lk, rc, oe,
    output reg [9:0] xox,
    output reg [8:0] xoxo, 
    output reg [15:0] si, 
    output reg [13:0] bd,
	output reg [63:0] ds,
    output reg [1:0] xods, 
    output reg [23:0] li,
    input [31:0] instruction, p_count
);

    assign po = instruction[31:26];

    always @(instruction) 
    begin
        rs = 5'b00000;
        rt = 5'b00000;
        rd = 5'b00000;
        bo = 5'b00000;
        bi = 5'b00000;
        aa = 1'b0;
        lk = 1'b0;
        rc = 1'b0;
        oe = 1'b0;
        xox = 10'b0000000000;
        xoxo = 9'b000000000;
        si = 16'b0000000000000000;
        bd = 14'b00000000000000;
        ds = 64'b00000000000000;
        xods = 2'b00;
        li = 24'b000000000000000000000000;
        //XO
        if(po == 6'd31 & (instruction[9:1] == 9'd266 | instruction[9:1] == 9'd40))
        begin
            // $display("HI\n");
            rd = instruction[25:21];
            rs = instruction[20:16];
            rt = instruction[15:11];
            oe = instruction[10];
            xoxo = instruction[9:1];
            rc = instruction[0];
        end

        //X
        else if(po == 6'd31)
        begin
            rd = instruction[25:21];
            rs = instruction[20:16];
            rt = instruction[15:11];
            xox = instruction[10:1];
            rc = instruction[0];
        end

        //D
        else if(po == 6'd14 | po == 6'd15 | po == 6'd28 | po == 6'd24 | po == 6'd26 | po == 6'd32 | po == 6'd36 | po == 6'd37 |po == 6'd40 | po == 6'd42 |po == 6'd44 |po == 6'd34 |po == 6'd38)
        begin
            rd = instruction[25:21];
            rs = instruction[20:16];   
            ds = $signed(instruction[15:0]);
            //$display("dsggsdg %64b\n",ds);
        end

        //B
        else if(po == 6'd19)
        begin
            bo = instruction[25:21];
            bi = instruction[20:16];
            bd = instruction[15:2];
            aa = instruction[1];
            lk = instruction[0];
        end

        //I
        else if(po == 6'd18)
        begin
            li = instruction[25:2];
            aa = instruction[1];
            lk = instruction[0];
        end 

        //DS
        else
        begin
            rd = instruction[25:21];
            rs = instruction[20:16];
            ds = $signed(instruction[15:2]);
			//ds = {{50{instruction[15]}},instruction[15:2]};
			//$display("LALALAL %64b \n",ds);
            xods = instruction[1:0];
        end
    end
endmodule
