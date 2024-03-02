
//DSP testbench

module DSP48A1_tb();

parameter A0REG = 0; parameter A1REG = 1; parameter B0REG = 0; parameter B1REG = 1;
parameter CREG = 1; parameter DREG = 1; parameter MREG = 1; parameter PREG = 1; parameter CARRYINREG = 1; 
parameter CARRYOUTREG = 1; parameter OPMODEREG = 1; parameter CARRYINSEL = "OPMODE5"; parameter B_INPUT = "DIRECT"; parameter RSTTYPE = "ASYNC";

reg[17:0] A,B,BCIN,D;
reg[47:0] C,PCIN;
reg[7:0] OPMODE;
reg CLK,CARRYIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
	CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE;

wire[17:0] BCOUT;
wire[47:0] P,PCOUT;
wire[35:0] M;
wire CARRYOUT,CARRYOUTF;

DSP48A1 DUT(A,B,C,D,CLK,CARRYIN,OPMODE,BCIN,RSTA,RSTB,RSTM,RSTP,RSTC,RSTD,RSTCARRYIN,RSTOPMODE,
	CEA,CEB,CEM,CEP,CEC,CED,CECARRYIN,CEOPMODE,PCIN,BCOUT,PCOUT,P,M,CARRYOUT,CARRYOUTF);

integer i = 0;

initial begin
	CLK=0;
	forever
	#1 CLK=~CLK;
end

initial begin
	RSTA=1;RSTB=1;RSTM=1;RSTP=1;RSTC=1;RSTD=1;RSTCARRYIN=1;RSTOPMODE=1;
        CEA=0;CEB=0;CEM=0;CEP=0;CEC=0;CED=0;CECARRYIN=0;CEOPMODE=0;
        A=0;B=0;BCIN=0;D=0;C=0;PCIN=0;OPMODE=0;CARRYIN=0;
	#5
	RSTA=0;RSTB=0;RSTM=0;RSTP=0;RSTC=0;RSTD=0;RSTCARRYIN=0;RSTOPMODE=0;
	for(i=0;i<5;i=i+1) begin
            #8
		A=$urandom_range(0,20);B=$urandom_range(0,20);BCIN=$urandom_range(0,20);D=$urandom_range(0,20);C=$urandom_range(0,40);PCIN=$urandom_range(0,40);
                OPMODE=$urandom_range(0,255);
            CEC=1;CED=1;CECARRYIN=1;CEOPMODE=1;
            #2
            CEA=1;CEB=1;
            #2
            CEM=1;
            #2
            CEP=1;
            #2
            CEA=0;CEB=0;CEM=0;CEP=0;
       end
   
end

endmodule 