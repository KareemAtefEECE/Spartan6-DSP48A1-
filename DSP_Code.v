// DSP48A1 - Spartan6


module DSP48A1(A,B,C,D,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
	CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);

parameter A0REG = 0; parameter A1REG = 1; parameter B0REG = 0; parameter B1REG = 1;
parameter CREG = 1; parameter DREG = 1; parameter MREG = 1; parameter PREG = 1; parameter CARRYINREG = 1; 
parameter CARRYOUTREG = 1; parameter OPMODEREG = 1; parameter CARRYINSEL = "OPMODE5"; parameter B_INPUT = "DIRECT"; parameter RSTTYPE = "SYNC";


input wire[17:0] A,B,BCIN,D;
input wire[47:0] C,PCIN;
input wire[7:0] OPMODE;
input CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
	CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;

output wire[17:0] BCOUT;
output wire[47:0] P,PCOUT;
output wire[35:0] M;
output wire CARRYOUT,CARRYOUTF;


wire carryin_out1,carryin_out2,carryout;
wire[7:0] OPMODE_out;
wire[17:0] D_out,B_out1,B_out2,A_out,pre_addsub_out,m6_out,m7_out,m8_out;
wire[47:0] C_out,post_addsub_out,mX_out,mZ_out,M_signExt,mP_out;
wire[35:0] multiplier_out,mM_out;



assign B_out1 = (B_INPUT=="DIRECT")?B:(B_INPUT=="CASCADE")?BCIN:0;

MUX2x1 #(18,RSTTYPE) m1(D,DREG,RSTD,CED,CLK,D_out);
MUX2x1 #(18,RSTTYPE) m2(B_out1,B0REG,RSTB,CEB,CLK,B_out2);
MUX2x1 #(18,RSTTYPE) m3(A,A0REG,RSTA,CEA,CLK,A_out);
MUX2x1 #(48,RSTTYPE) m4(C,CREG,RSTC,CEC,CLK,C_out);
MUX2x1 #(8,RSTTYPE) m5(OPMODE,OPMODEREG,RSTOPMODE,CEOPMODE,CLK,OPMODE_out);

assign pre_addsub_out = OPMODE_out[6]?(D_out-B_out2):(D_out+B_out2);
assign m6_out = OPMODE_out[4]?pre_addsub_out:B_out2;

MUX2x1 #(18,RSTTYPE) m7(m6_out,B1REG,RSTB,CEB,CLK,m7_out);
MUX2x1 #(18,RSTTYPE) m8(A_out,A1REG,RSTA,CEA,CLK,m8_out);

assign BCOUT = m7_out;

assign multiplier_out=m7_out*m8_out;

MUX2x1 #(36,RSTTYPE) m9(multiplier_out,MREG,RSTM,CEM,CLK,mM_out);

assign M = mM_out;

assign M_signExt = {{12{mM_out[35]}},mM_out[35:0]};

MUX4x1 mX(48'd0,M_signExt,mP_out,{D_out[11:0],m8_out,m7_out},OPMODE_out[1:0],mX_out);
MUX4x1 mZ(48'd0,PCIN,mP_out,C_out,OPMODE_out[3:2],mZ_out);

assign carryin_out1 = (CARRYINSEL=="OPMODE5")?OPMODE_out[5]:(CARRYINSEL=="CARRYIN")?CARRYIN:0;

MUX2x1 #(1,RSTTYPE) m10(carryin_out1,CARRYINREG,RSTCARRYIN,CECARRYIN,CLK,carryin_out2);

assign {carryout,post_addsub_out} = OPMODE_out[7]?(mZ_out-(mX_out+carryin_out2)):(mZ_out+mX_out+carryin_out2);

MUX2x1 #(48,RSTTYPE) m11(post_addsub_out,PREG,RSTP,CEP,CLK,mP_out);
MUX2x1 #(1,RSTTYPE) m12(carryout,CARRYINREG,RSTCARRYIN,CECARRYIN,CLK,CARRYOUT);
assign P = mP_out;
assign PCOUT = P;
assign CARRYOUTF=CARRYOUT;

endmodule




