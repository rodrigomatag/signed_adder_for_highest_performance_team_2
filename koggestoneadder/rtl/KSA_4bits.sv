`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2025 18:27:25
// Design Name: 
// Module Name: ksa_4bits
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


module ksa_4bits(
    input logic clk,
    input logic arst_n,
    input logic en,
    input logic [3:0] first,
    input logic [3:0] second,
    input logic carry_in,
    output logic [3:0] final_result,
    output logic carry_out_final
    );
    logic [3:0] pro;
    logic [3:0] gen;
    logic [3:1] pro_step0;  //1
    logic [3:1] gen_step0;
    logic [3:2] pro_step1;  //3
    logic [3:2] gen_step1;
    logic [4:0] carries;
    logic [3:0] result;
    /*
    logic [63:8] pro_step3; //11
    logic [63:8] gen_step3;
    logic [63:16] pro_step4;//20
    logic [63:16] gen_step4;
    logic [63:32] pro_step5;//37
    logic [63:32] gen_step5;
    
    */
    //Registro de entradas
    logic [3:0] first1;
    register_adder_4bits register_first(
        .clk(clk),
        .arst_n(arst_n),
        .en(1'b1),
        .in(first),
        .out(first1)
    );
    logic [3:0] second1;
    register_adder_4bits register_second(
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
        for(i=0; i<4; i++)begin:initialstep 
            assign pro[i] = first1[i] ^ second1[i];
            assign gen[i] = first1[i] & second1[i];    
        end
    endgenerate
    //Etapa 0 g' p'
    genvar j;
    generate
        for(j=1; j<4; j++)begin:step0 
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
        for(k=3; k<4; k++)begin:step1 
            assign pro_step1[k] = pro_step0[k] & pro_step0[k-2];//cambio de 1 a 2
            assign gen_step1[k] = gen_step0[k] | (pro_step0[k] & gen_step0[k-2]); 
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
                             
    assign carry_out = carries[4];
    
    genvar m;
    generate
        for(m=0; m<4; m++)begin:results 
            assign result[m] = pro[m] ^ carries[m];
        end
    endgenerate
    logic [3:0] result1;
    register_adder_4bits register_result(
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
