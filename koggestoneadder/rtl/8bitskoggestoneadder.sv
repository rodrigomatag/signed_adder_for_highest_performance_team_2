module ksa_corregido(
    input logic [7:0] first,
    input logic [7:0] second,
    input logic carry_in,
    output logic [7:0] result,
    output logic carry_out
    );
    logic [7:0] pro;
    logic [7:0] gen;
    logic [7:1] pro_step0;
    logic [7:1] gen_step0;
    logic [7:2] pro_step1;
    logic [7:2] gen_step1;
    logic [7:4] pro_step2;
    logic [7:4] gen_step2;
    logic [8:0] carries;
    
    //Primer calculo de propagación y generación de bit
    
    genvar i;
    generate
        for(i=0; i<8; i++)begin:initialstep 
            assign pro[i] = first[i] ^ second[i];
            assign gen[i] = first[i] & second[i];    
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
    //Etapa 1 g'' p''
    /*
    genvar k;
    generate
        for(k=2; k<8; k++)begin:step1 
            assign pro_step1[k] = pro_step0[k] & pro_step0[k-1];
            assign gen_step1[k] = gen_step0[k] | (pro_step0[k] & gen[k-2]);  
        end
    endgenerate
    */
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
    assign carries[0] = carry_in;                                                                                       
    assign carries[1] = gen[0]       | (pro[0] & carry_in);                             
    assign carries[2] = gen_step0[1] | (pro_step0[1] & carry_in);                       
    assign carries[3] = gen_step1[2] | (pro_step1[2] & ((pro[0] & carry_in) | gen[0])); 
    assign carries[4] = gen_step1[3] | (pro_step1[3] & carry_in);                        
    assign carries[5] = gen_step2[4] | (pro_step2[4] & ((pro[0] & carry_in) | gen[0])); 
    assign carries[6] = gen_step2[5] | (pro_step2[5] & ((pro_step0[1] & carry_in) | gen_step0[1])); 
    assign carries[7] = gen_step2[6] | (pro_step2[6] & ((pro_step1[2] & ((pro[0] & carry_in) | gen[0])) | gen_step1[2])); 
    assign carries[8] = gen_step2[7] | (pro_step2[7] & carry_in);                                
   
    
    genvar m;
    generate
        for(m=0; m<8; m++)begin:results 
            assign result[m] = pro[m] ^ carries[m];
        end
    endgenerate
    
    assign carry_out = carries[8];
endmodule
