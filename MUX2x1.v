
// MUX2x1

module MUX2x1(A,sel,rst,CE,clk,out);
parameter N = 18;
parameter RSTTYPE = "ASYNC";
input wire[N-1:0] A;
input rst,CE,clk,sel;
reg[N-1:0] A_reg;
output wire[N-1:0] out;
generate
	if(RSTTYPE=="ASYNC") begin
		always @(posedge clk or posedge rst) begin
			if (rst) A_reg<=0;
			else if (CE) A_reg<=A;
			
		end
	end
	if(RSTTYPE=="SYNC") begin

    always @(posedge clk) begin
    	if (rst) A_reg<=0;
    	else if (CE) A_reg<=A;
    end

	end
	
endgenerate

assign out = sel?A_reg:A;

endmodule 