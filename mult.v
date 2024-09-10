module wallace_tree_multiplier(
    output [31:0]mult,
    output carry,
    input [15:0]a,b);

    genvar k;
    integer i,j;
    reg [15:0]m[15:0];
    wire [15:0]s0[4:0];
    wire [15:0]c0[4:0];
    wire [15:0]s10,c10,s12,c12,s31,c31;
    wire [17:0]s11,c11,s20,c20;
    wire [18:0]s21,c21;
    wire [19:0]s30,c30;
    wire [24:0]s4,c4,s5,c5;
    wire co;

    // Product Term Generation
    always@(*) begin
        for(i=0;i<16;i=i+1) begin
            for(j=0;j<16;j=j+1) begin
                m[i][j]=b[i]&a[j];
            end
        end
    end

    // stage-1
    generate for(k=0;k<5;k=k+1)
    begin : stage_1
        reducer red(s0[k],c0[k],m[3*k][15:1],m[(3*k)+2][14:0],m[(3*k)+1]);
    end
    endgenerate

    // stage-2-1
    half_add HA20(s10[0],c10[0],s0[0][1],c0[0][0]);
    full_add FA21(s10[1],c10[1],s0[0][2],c0[0][1],m[3][0]);
    full_add_array FAA0(s10[14:2],c10[14:2],s0[0][15:3],c0[0][14:2],s0[1][12:0]);
    full_add FA22(s10[15],c10[15],m[2][15],c0[0][15],s0[1][13]);

    // stage-2-2
    half_add HA23(s11[0],c11[0],c0[1][1],m[6][0]);
    half_add HA24(s11[1],c11[1],c0[1][2],s0[2][0]);
    full_add_array FAA1(s11[14:2],c11[14:2],c0[1][15:3],s0[2][13:1],c0[2][12:0]);
    half_add HA25(s11[15],c11[15],c0[2][13],s0[2][14]);
    half_add HA26(s11[16],c11[16],c0[2][14],s0[2][15]);
    half_add HA27(s11[17],c11[17],c0[2][15],m[8][15]);

    // stage-2-3
    half_add HA28(s12[0],c12[0],s0[3][1],c0[3][0]);
    full_add FA29(s12[1],c12[1],s0[3][2],c0[3][1],m[12][0]);
    full_add_array FAA2(s12[14:2],c12[14:2],s0[3][15:3],c0[3][14:2],s0[4][12:0]);
    full_add FA23(s12[15],c12[15],m[11][15],c0[3][15],s0[4][13]);

    // stage-3-1
    half_add HA30(s20[0],c20[0],s10[1],c10[0]);
    half_add HA31(s20[1],c20[1],s10[2],c10[1]);
    full_add FA32(s20[2],c20[2],s10[3],c10[2],c0[1][0]);
    generate for(k=3;k<=14;k=k+1)
    begin : stage_3_1
        full_add FA(s20[k],c20[k],s10[k+1],c10[k],s11[k-3]);
    end
    endgenerate
    full_add FA33(s20[15],c20[15],s0[1][14],c10[15],s11[12]);
    half_add HA34(s20[16],c20[16],s0[1][15],s11[13]);
    half_add HA35(s20[17],c20[17],m[5][15],s11[14]);

    // stage-3-2
    half_add HA36(s21[0],c21[0],c11[2],m[9][0]);
    half_add HA37(s21[1],c21[1],c11[3],s0[3][0]);
    half_add HA38(s21[2],c21[2],c11[4],s12[0]);
    full_add_array FAA3(s21[15:3],c21[15:3],c11[17:5],s12[13:1],c12[12:0]);
    half_add HA39(s21[16],c21[16],s12[14],c12[13]);
    half_add HA310(s21[17],c21[17],s12[15],c12[14]);
    half_add HA11(s21[18],c21[18],s0[4][14],c12[15]);

    // stage-4-1
    half_add HA40(s30[0],c30[0],s20[1],c20[0]);
    half_add HA41(s30[1],c30[1],s20[2],c20[1]);
    half_add HA42(s30[2],c30[2],s20[3],c20[2]);
    full_add FA43(s30[3],c30[3],s20[4],c20[3],c11[0]);
    full_add FA44(s30[4],c30[4],s20[5],c20[4],c11[1]);
    generate for(k=5;k<=16;k=k+1)
    begin : stage_4_1
        full_add FA(s30[k],c30[k],s20[k+1],c20[k],s21[k-5]);
    end
    endgenerate
    full_add FA45(s30[17],c30[17],s11[15],c20[17],s21[12]);
    half_add HA46(s30[18],c30[18],s11[16],s21[13]);
    half_add HA47(s30[19],c30[19],s11[17],s21[14]);

    // stage-4-2
    half_add HA48(s31[0],c31[0],c21[4],c0[4][0]);
    full_add_array FAA4(s31[13:1],c31[13:1],c21[17:5],c0[4][13:1],m[15][12:0]);
    full_add FA49(s31[14],c31[14],c21[18],c0[4][14],m[15][13]);
    half_add HA410(s31[15],c31[15],c0[4][15],m[15][14]);

    // stage-5
    generate for(k=0;k<=4;k=k+1)
    begin : stage_HA_5
        half_add HA(s4[k],c4[k],s30[k+1],c30[k]);
    end
    endgenerate

    generate for(k=5;k<=8;k=k+1)
    begin : stage_FA_5
        full_add FA(s4[k],c4[k],s30[k+1],c30[k],c21[k-5]);
    end
    endgenerate

    generate for(k=9;k<=18;k=k+1)
    begin : stage_FA_50
        full_add FA(s4[k],c4[k],s30[k+1],c30[k],s31[k-9]);
    end
    endgenerate

    full_add FA50(s4[19],c4[19],s21[15],c30[19],s31[10]);
    half_add HA51(s4[20],c4[20],s21[16],s31[11]);
    half_add HA52(s4[21],c4[21],s21[17],s31[12]);
    half_add HA53(s4[22],c4[22],s21[18],s31[13]);
    half_add HA54(s4[23],c4[23],s0[4][15],s31[14]);
    half_add HA55(s4[24],c4[24],m[14][15],s31[15]);

    // stage-6
    generate for(k=0;k<=8;k=k+1)
    begin : stage_HA_6
        half_add HA(s5[k],c5[k],s4[k+1],c4[k]);
    end
    endgenerate

    full_add_array FAA5(s5[21:9],c5[21:9],s4[22:10],c4[21:9],c31[12:0]);
    full_add FA60(s5[22],c5[22],s4[23],c4[22],c31[13]);
    full_add FA61(s5[23],c5[23],s4[24],c4[23],c31[14]);
    full_add FA62(s5[24],c5[24],m[15][15],c4[24],c31[15]);

    // Last stage
    assign mult[6:0]={s5[0],s4[0],s30[0],s20[0],s10[0],s0[0][0],m[0][0]};
    carry_look_ahead CLA(mult[30:7],co,s5[24:1],c5[23:0]);
    half_add FA63(mult[31],carry,co,c5[24]);
endmodule

module carry_look_ahead(
    output reg [23:0]sum,
    output co,
    input [23:0]a,b);

    reg [23:0]p,g;
    reg [22:0]y;
    reg [23:0]c_o;
    integer i,j,k;
    always@(*) begin
        // carry generate and propogation generate.
        for(k=0;k<24;k=k+1) begin
            p[k]=a[k]^b[k];
            g[k]=a[k]&b[k];
        end

        // Logic for carry generator.
        for(k=0;k<=23;k=k+1) begin
            c_o[k]=g[k];
            for(i=0;i<k;i=i+1) begin
                y[i]=g[i];
                for(j=i+1;j<=k;j=j+1) begin
                    y[i]=y[i]&p[j];
                end
                c_o[k]=c_o[k]|y[i];
            end
        end

        // iteration for sum signal.
        sum[0]=p[0];
        for(k=1;k<24;k=k+1) sum[k]=p[k]^c_o[k-1];
    end
    assign co=c_o[23];
endmodule

module reducer(
    output [15:0]sr1,cor1,
    input [14:0]mr0,mr2,
    input [15:0]mr1);

    genvar i;
    half_add HA10(sr1[0],cor1[0],mr0[0],mr1[0]);
    generate for(i=1;i<=14;i=i+1)
    begin : reduce_1
        full_add FA(sr1[i],cor1[i],mr0[i],mr1[i],mr2[i-1]);
    end
    endgenerate
    half_add HA11(sr1[15],cor1[15],mr1[15],mr2[14]);
endmodule

module full_add_array(
    output [12:0]sa,ca,
    input [12:0]in0,in1,in2);

    genvar j;
    generate for(j=0;j<=12;j=j+1)
    begin : array
        full_add FA(sa[j],ca[j],in0[j],in1[j],in2[j]);
    end
    endgenerate
endmodule

module full_add(
    output sf,cf,
    input af,bf,cif);
    assign sf=af^bf^cif;
    assign cf=(af&bf)|(bf&cif)|(af&cif);
endmodule

module half_add(
    output sh,ch,
    input ah,bh);
    assign sh=ah^bh;
    assign ch=ah&bh;
endmodule
