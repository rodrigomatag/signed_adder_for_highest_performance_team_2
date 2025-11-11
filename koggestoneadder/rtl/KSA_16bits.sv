`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2025 11:05:46
// Design Name: 
// Module Name: ksa_16bits
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ksa_16bits(
     input logic clk,
    input logic arst_n,
    input logic en,
    input logic [15:0] first,
    input logic [15:0] second,
    input logic carry_in,
    output logic [15:0] final_result,
    output logic carry_out_final
    );
    logic [15:0] pro;
    logic [15:0] gen;
    logic [15:1] pro_step0;  //1
    logic [15:1] gen_step0;
    logic [15:2] pro_step1;  //3
    logic [15:2] gen_step1;
    logic [15:4] pro_step2;  //6
    logic [15:4] gen_step2;
    logic [15:8] pro_step3;  //11
    logic [15:8] gen_step3;
    logic [16:0] carries;
    logic [15:0] result;
    /*
    logic [63:8] pro_step3; //11
    logic [63:8] gen_step3;
    logic [63:16] pro_step4;//20
    logic [63:16] gen_step4;
    logic [63:32] pro_step5;//37
    logic [63:32] gen_step5;
    
    */
    //Registro de entradas
    logic [15:0] first1;
    register_adder_16bits register_first(
        .clk(clk),
        .arst_n(arst_n),
        .en(1'b1),
        .in(first),
        .out(first1)
    );
    logic [15:0] second1;
    register_adder_16bits register_second(
        .clk(clk),
        .arst_n(arst_n),
        .en(1'b1),
        .in(second),
        .out(second1)
    );
    logic carry_in_reg;
    reg_carry carry_reg(
        .clk(clk),
        .arst_n(arst_n),
        .en(1'b1),
        .in(carry_in),
        .out(carry_in_reg)
    );
    //Primer calculo de propagación y generación de bit
    genvar i;
    generate
        for(i=0; i<16; i++)begin:initialstep 
            assign pro[i] = first1[i] ^ second1[i];
            assign gen[i] = first1[i] & second1[i];    
        end
    endgenerate
    //Etapa 0 g' p'
    genvar j;
    generate
        for(j=1; j<16; j++)begin:step0 
            assign pro_step0[j] = pro[j] & pro[j-1];
            assign gen_step0[j] = gen[j] | (pro[j] & gen[j-1]);    
        end
    endgenerate
    
     
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Etapa 1 g'' p''
    
    assign pro_step1[2] = pro_step0[2] & pro[0];
    assign gen_step1[2] = gen_step0[2] | (pro_step0[2] & gen[0]);
    
    genvar k;
    generate
        for(k=3; k<16; k++)begin:step1 
            assign pro_step1[k] = pro_step0[k] & pro_step0[k-2];//cambio de 1 a 2
            assign gen_step1[k] = gen_step0[k] | (pro_step0[k] & gen_step0[k-2]); 
        end
    endgenerate
    
     
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Etapa 2 g''' p'''
    
    assign pro_step2[4] = pro_step1[4] & pro[0];
    assign gen_step2[4] = gen_step1[4] | (pro_step1[4] & gen[0]);
    
    assign pro_step2[5] = pro_step1[5] & pro_step0[1];
    assign gen_step2[5] = gen_step1[5] | (pro_step1[5] & gen_step0[1]);
    
    genvar l;
    generate
        for(l=6; l<16; l++)begin:step2 
            assign pro_step2[l] = pro_step1[l] & pro_step1[l-4];
            assign gen_step2[l] = gen_step1[l] | (pro_step1[l] & gen_step1[l-4]);  
        end
    endgenerate
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Etapa 3 g'''' p''''
    
    assign pro_step3[8] = pro_step2[8] & pro[0];
    assign gen_step3[8] = gen_step2[8] | (pro_step2[8] & gen[0]);
    
    assign pro_step3[9] = pro_step2[9] & pro_step0[1];
    assign gen_step3[9] = gen_step2[9] | (pro_step2[9] & gen_step0[1]);
    
    assign pro_step3[10] = pro_step2[10] & pro_step1[2];
    assign gen_step3[10] = gen_step2[10] | (pro_step2[10] & gen_step1[2]);
    
    assign pro_step3[11] = pro_step2[11] & pro_step1[3];
    assign gen_step3[11] = gen_step2[11] | (pro_step2[11] & gen_step1[3]);
    
    genvar n;
    generate
        for(n=12; n<16; n++)begin:step3 
            assign pro_step3[n] = pro_step2[n] & pro_step2[n-8];
            assign gen_step3[n] = gen_step2[n] | (pro_step2[n] & gen_step2[n-8]);  
        end
    endgenerate
  
     
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Asignación de carries
    //c0=Cin                     -0
    //C1= p0    & c0 | g0        -1
    //C2= p'1   & c0 | g'1       -2
    //C3= p''2  & c1 | g''2      -2
    //C4= p''3  & c0 | g''3      -4 
    //C5= p'''4 & c1 | g'''4     -4
    //C6= p'''5 & c2 | g'''5     -4
    //C7= p'''6 & c3 | g'''6     -4
    //C8= p'''7 & c0 | g'''7     -8
    assign carries[0] = carry_in_reg;                                                                                       
    assign carries[1] = gen[0]       | (pro[0] & carry_in_reg);                             
    assign carries[2] = gen_step0[1] | (pro_step0[1] & carry_in_reg);                       
    assign carries[3] = gen_step1[2] | (pro_step1[2] & ((pro[0] & carry_in_reg) | gen[0])); 
    assign carries[4] = gen_step1[3] | (pro_step1[3] & carry_in_reg);                        
    assign carries[5] = gen_step2[4] | (pro_step2[4] & ((pro[0] & carry_in_reg) | gen[0])); 
    assign carries[6] = gen_step2[5] | (pro_step2[5] & ((pro_step0[1] & carry_in_reg) | gen_step0[1])); 
    assign carries[7] = gen_step2[6] | (pro_step2[6] & ((pro_step1[2] & ((pro[0] & carry_in_reg) | gen[0])) | gen_step1[2])); 
    assign carries[8] = gen_step2[7] | (pro_step2[7] & carry_in_reg); 
    assign carries[9] = gen_step3[8] | (pro_step3[8] & (gen[0]| (pro[0] & carry_in_reg)));   
    assign carries[10] = gen_step3[9] | (pro_step3[9] & (gen_step0[1] | (pro_step0[1] & carry_in_reg))); 
    assign carries[11] = gen_step3[10] | (pro_step3[10] & (gen_step1[2] | (pro_step1[2] & ((pro[0] & carry_in_reg) | gen[0])))); 
    assign carries[12] = gen_step3[11] | (pro_step3[11] & (gen_step1[3] | (pro_step1[3] & carry_in_reg))); 
    assign carries[13] = gen_step3[12] | (pro_step3[12] & (gen_step2[4] | (pro_step2[4] & ((pro[0] & carry_in_reg) | gen[0])))); 
    assign carries[14] = gen_step3[13] | (pro_step3[13] & (gen_step2[5] | (pro_step2[5] & ((pro_step0[1] & carry_in_reg) | gen_step0[1])))); 
    assign carries[15] = gen_step3[14] | (pro_step3[14] & (gen_step2[6] | (pro_step2[6] & ((pro_step1[2] & ((pro[0] & carry_in_reg) | gen[0])) | gen_step1[2])))); 
    assign carries[16] = gen_step3[15] | (pro_step3[15] & carry_in_reg);                              
    assign carry_out = carries[16];
    
    genvar m;
    generate
        for(m=0; m<16; m++)begin:results 
            assign result[m] = pro[m] ^ carries[m];
        end
    endgenerate
    logic [15:0] result1;
    register_adder_16bits register_result(
        .clk(clk),
        .arst_n(arst_n),
        .en(1'b1),
        .in(result),
        .out(result1)
    );
    logic carry_out_reg;
    reg_carry register_carry_out(
        .clk(clk),
        .arst_n(arst_n),
        .en(1'b1),
        .in(carry_out),
        .out(carry_out_reg)
    );
    
    assign carry_out_final = carry_out_reg;
    assign final_result = result1; 
endmodule
