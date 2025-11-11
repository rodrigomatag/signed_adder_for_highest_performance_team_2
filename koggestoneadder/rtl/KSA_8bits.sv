`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2025 09:07:40
// Design Name: 
// Module Name: ksa_corregido
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


module ksa_corregido(
    input logic clk,
    input logic arst_n,
    input logic en,
    input logic [7:0] first,
    input logic [7:0] second,
    input logic carry_in,
    output logic [7:0] final_result,
    output logic carry_out_final
    );
    logic [7:0] pro;
    logic [7:0] gen;
    logic [7:1] pro_step0;  //1
    logic [7:1] gen_step0;
    logic [7:2] pro_step1;  //3
    logic [7:2] gen_step1;
    logic [7:4] pro_step2;  //6
    logic [7:4] gen_step2;
    logic [8:0] carries;
    logic [7:0] result;
    /*
    logic [63:8] pro_step3; //11
    logic [63:8] gen_step3;
    logic [63:16] pro_step4;//20
    logic [63:16] gen_step4;
    logic [63:32] pro_step5;//37
    logic [63:32] gen_step5;
    
    */
    //Registro de entradas
    logic [7:0] first1;
    register_adder register_first(
        .clk(clk),
        .arst_n(arst_n),
        .en(1'b1),
        .in(first),
        .out(first1)
    );
    logic [7:0] second1;
    register_adder register_second(
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
        for(i=0; i<8; i++)begin:initialstep 
            assign pro[i] = first1[i] ^ second1[i];
            assign gen[i] = first1[i] & second1[i];    
        end
    endgenerate
    //Etapa 0 g' p'
    genvar j;
    generate
        for(j=1; j<8; j++)begin:step0 
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
        for(k=3; k<8; k++)begin:step1 
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
        for(l=6; l<8; l++)begin:step2 
            assign pro_step2[l] = pro_step1[l] & pro_step1[l-4];
            assign gen_step2[l] = gen_step1[l] | (pro_step1[l] & gen_step1[l-4]);  
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
    assign carry_out = carries[8];
    
    genvar m;
    generate
        for(m=0; m<8; m++)begin:results 
            assign result[m] = pro[m] ^ carries[m];
        end
    endgenerate
    logic [7:0] result1;
    register_adder register_result(
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
