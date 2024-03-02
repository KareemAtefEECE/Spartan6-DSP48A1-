
// MUX4x1

module MUX4x1(A,B,C,D,sel,out);
input wire[47:0] A,B,C,D;
input wire[1:0] sel;
output reg[47:0] out;
always @(*) begin
	case(sel)
	0:out=A;
	1:out=B;
	2:out=C;
	default:out=D;
	endcase
end
endmodule