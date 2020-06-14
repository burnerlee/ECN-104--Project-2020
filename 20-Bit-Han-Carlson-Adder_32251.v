//Han Carlson Adder for 20 bits

// we define the main function for Han_Carlson_Adder which takes in two inputs and returns an output
module Han_Carlson_Adder(input1, input2, sum);

input [19:0] input1, input2;             // inputs with 19 bits
output [19:0] sum;                         // outputs with 19 bits 
wire [19:0] prop,gen,carry;              // wires to store output of stage, prop is progogation, gen is generated
// prop,gen stores initial prop and gen values before stage1

// prop and gen values at stage m and bit n (ranging from 0 to n-1), we have used convention prop_m_n and gen_m_n.
// before stage 1 initialised values are stored in prop and gen array as prop[i] and gen[i] where i denotes bit no.

// initialise prop and gen values before stage 1 using the input values.
initialise ini0(input1[0],input2[0],prop[0],gen[0]);
initialise ini1(input1[1],input2[1],prop[1],gen[1]);
initialise ini2(input1[2],input2[2],prop[2],gen[2]);
initialise ini3(input1[3],input2[3],prop[3],gen[3]);
initialise ini4(input1[4],input2[4],prop[4],gen[4]);
initialise ini5(input1[5],input2[5],prop[5],gen[5]);
initialise ini6(input1[6],input2[6],prop[6],gen[6]);
initialise ini7(input1[7],input2[7],prop[7],gen[7]);
initialise ini8(input1[8],input2[8],prop[8],gen[8]);
initialise ini9(input1[9],input2[9],prop[9],gen[9]);
initialise ini10(input1[10],input2[10],prop[10],gen[10]);
initialise ini11(input1[11],input2[11],prop[11],gen[11]);
initialise ini12(input1[12],input2[12],prop[12],gen[12]);
initialise ini13(input1[13],input2[13],prop[13],gen[13]);
initialise ini14(input1[14],input2[14],prop[14],gen[14]);
initialise ini15(input1[15],input2[15],prop[15],gen[15]);
initialise ini16(input1[16],input2[16],prop[16],gen[16]);
initialise ini17(input1[17],input2[17],prop[17],gen[17]);
initialise ini18(input1[18],input2[18],prop[18],gen[18]);
initialise ini19(input1[19],input2[19],prop[19],gen[19]);
// run main logic of the code
main_logic carry_gen(prop,gen,carry);
//finally store the result values in sum
buf (sum[0],prop[0]);
xor (sum[1],prop[1],carry[0]);
xor (sum[2],prop[2],carry[1]);
xor (sum[3],prop[3],carry[2]);
xor (sum[4],prop[4],carry[3]);
xor (sum[5],prop[5],carry[4]);
xor (sum[6],prop[6],carry[5]);
xor (sum[7],prop[7],carry[6]);
xor (sum[8],prop[8],carry[7]);
xor (sum[9],prop[9],carry[8]);
xor (sum[10],prop[10],carry[9]);
xor (sum[11],prop[11],carry[10]);
xor (sum[12],prop[12],carry[11]);
xor (sum[13],prop[13],carry[12]);
xor (sum[14],prop[14],carry[13]);
xor (sum[15],prop[15],carry[14]);
xor (sum[16],prop[16],carry[15]);
xor (sum[17],prop[17],carry[16]);
xor (sum[18],prop[18],carry[17]);
xor (sum[19],prop[19],carry[18]);
endmodule
// initialise module takes one bit each from both the inputs and returns the propogate and generate values for each set.
module initialise(input1,input2,prop,gen);
input input1, input2;
output prop,gen;
xor (prop,input1, input2);          // prop is equal to 'xor' of input1 and input2
and (gen,input1, input2);           // gen is equal to 'and' of input1 and input2
endmodule
// grey_circle module simulates the operation of grey circle in the Han_Carlson_Adder structure.
// it takes prev stage values of prop and gen and returns new values according to below defined operation.
module grey_circle(p_1,g_1,g_2,g_final);
input p_1,g_1,g_2;
output g_final;
wire w;                             // w will store value of 'and' of p_1 and g_2
and (w,p_1,g_2);                    // then we perform 'or' operation with g_1 to get g_final
or (g_final,g_1,w);
endmodule
// black_circle module simulates the operation of black circle in the Han_Carlson_Adder structure.
// it takes prev stage values of prop and gen and returns new values according to below defined operation.
module black_circle(p_1,g_1,p_2,g_2,p_final,g_final);
input p_1,g_1,p_2,g_2;
output p_final,g_final;
wire w;
and (p_final,p_1,p_2);
and (w,p_1,g_2);
or (g_final,w,g_1);
endmodule
// Main_logic implements the logic of the Han_Carlson_Adder and uses other modules to perform operations.
// The sequence of use of modules in main_logic is responsible for adder's functioning and makes it unique
// from other adders.
module main_logic(prop,gen,carry);
input [19:0] prop,gen;
output [19:0] carry;
//first_layer stage1
buf(prop_1_0,prop[0]);
buf(gen_1_0,gen[0]);
buf(prop_1_1,prop[1]);
grey_circle gc_1_1(prop[1],gen[1],gen[0],gen_1_1);
buf(prop_1_2,prop[2]);
buf(gen_1_2,gen[2]);
black_circle bc_1_3(prop[3],gen[3],prop[2],gen[2],prop_1_3,gen_1_3);
buf(prop_1_4,prop[4]);
buf(gen_1_4,gen[4]);
black_circle bc_1_5(prop[5],gen[5],prop[4],gen[4],prop_1_5,gen_1_5);
buf(prop_1_6,prop[6]);
buf(gen_1_6,gen[6]);
black_circle bc_1_7(prop[7],gen[7],prop[6],gen[6],prop_1_7,gen_1_7);
buf(prop_1_8,prop[8]);
buf(gen_1_8,gen[8]);
black_circle bc_1_9(prop[9],gen[9],prop[8],gen[8],prop_1_9,gen_1_9);
buf(prop_1_10,prop[10]);
buf(gen_1_10,gen[10]);
black_circle bc_1_11(prop[11],gen[11],prop[10],gen[10],prop_1_11,gen_1_11);
buf(prop_1_12,prop[12]);
buf(gen_1_12,gen[12]);
black_circle bc_1_13(prop[13],gen[13],prop[12],gen[12],prop_1_13,gen_1_13);
buf(prop_1_14,prop[14]);
buf(gen_1_14,gen[14]);
black_circle bc_1_15(prop[15],gen[15],prop[14],gen[14],prop_1_15,gen_1_15);
buf(prop_1_16,prop[16]);
buf(gen_1_16,gen[16]);
black_circle bc_1_17(prop[17],gen[17],prop[16],gen[16],prop_1_17,gen_1_17);
buf(prop_1_18,prop[18]);
buf(gen_1_18,gen[18]);
black_circle bc_1_19(prop[19],gen[19],prop[18],gen[18],prop_1_19,gen_1_19);

// logic depth layer with layers = (logn + 1)
	//Layer 1 Stage 2
buf(prop_2_0,prop_1_0);
buf(gen_2_0,gen_1_0);
buf(prop_2_1,prop_1_1);
buf(gen_2_1,gen_1_1);
buf(prop_2_2,prop_1_2);
buf(gen_2_2,gen_1_2);
buf(prop_2_3,prop_1_3);
grey_circle gc_2_3(prop_1_3,gen_1_3,gen_1_1,gen_2_3);
buf(prop_2_4,prop_1_4);
buf(gen_2_4,gen_1_4);
black_circle bc_2_5(prop_1_5,gen_1_5,prop_1_3,gen_1_3,prop_2_5,gen_2_5);
buf(prop_2_6,prop_1_6);
buf(gen_2_6,gen_1_6);
black_circle bc_2_7(prop_1_7,gen_1_7,prop_1_5,gen_1_5,prop_2_7,gen_2_7);
buf(prop_2_8,prop_1_8);
buf(gen_2_8,gen_1_8);
black_circle bc_2_9(prop_1_9,gen_1_9,prop_1_7,gen_1_7,prop_2_9,gen_2_9);
buf(prop_2_10,prop_1_10);
buf(gen_2_10,gen_1_10);
black_circle bc_2_11(prop_1_11,gen_1_11,prop_1_9,gen_1_9,prop_2_11,gen_2_11);
buf(prop_2_12,prop_1_12);
buf(gen_2_12,gen_1_12);
black_circle bc_2_13(prop_1_13,gen_1_13,prop_1_11,gen_1_11,prop_2_13,gen_2_13);
buf(prop_2_14,prop_1_14);
buf(gen_2_14,gen_1_14);
black_circle bc_2_15(prop_1_15,gen_1_15,prop_1_13,gen_1_13,prop_2_15,gen_2_15);
buf(prop_2_16,prop_1_16);
buf(gen_2_16,gen_1_16);
black_circle bc_2_17(prop_1_17,gen_1_17,prop_1_15,gen_1_15,prop_2_17,gen_2_17);
buf(prop_2_18,prop_1_18);
buf(gen_2_18,gen_1_18);
black_circle bc_2_19(prop_1_19,gen_1_19,prop_1_17,gen_1_17,prop_2_19,gen_2_19);
	//Layer 2 Stage 3
buf(prop_3_0,prop_2_0);
buf(gen_3_0,gen_2_0);
buf(prop_3_1,prop_2_1);
buf(gen_3_1,gen_2_1);
buf(prop_3_2,prop_2_2);
buf(gen_3_2,gen_2_2);
buf(prop_3_3,prop_2_3);
buf(gen_3_3,gen_2_3);
buf(prop_3_4,prop_2_4);
buf(gen_3_4,gen_2_4);
buf(prop_3_5,prop_2_5);
grey_circle gc_3_5(prop_2_5,gen_2_5,gen_2_1,gen_3_5);
buf(prop_3_6,prop_2_6);
buf(gen_3_6,gen_2_6);
buf(prop_3_7,prop_2_7);
grey_circle gc_3_7(prop_2_7,gen_2_7,gen_2_3,gen_3_7);
buf(prop_3_8,prop_2_8);
buf(gen_3_8,gen_2_8);
black_circle bc_3_9(prop_2_9,gen_2_9,prop_2_5,gen_2_5,prop_3_9,gen_3_9);
buf(prop_3_10,prop_2_10);
buf(gen_3_10,gen_2_10);
black_circle bc_3_11(prop_2_11,gen_2_11,prop_2_7,gen_2_7,prop_3_11,gen_3_11);
buf(prop_3_12,prop_2_12);
buf(gen_3_12,gen_2_12);
black_circle bc_3_13(prop_2_13,gen_2_13,prop_2_9,gen_2_9,prop_3_13,gen_3_13);
buf(prop_3_14,prop_2_14);
buf(gen_3_14,gen_2_14);
black_circle bc_3_15(prop_2_15,gen_2_15,prop_2_11,gen_2_11,prop_3_15,gen_3_15);
buf(prop_3_16,prop_2_16);
buf(gen_3_16,gen_2_16);
black_circle bc_3_17(prop_2_17,gen_2_17,prop_2_13,gen_2_13,prop_3_17,gen_3_17);
buf(prop_3_18,prop_2_18);
buf(gen_3_18,gen_2_18);
black_circle bc_3_19(prop_2_19,gen_2_19,prop_2_15,gen_2_15,prop_3_19,gen_3_19);
	//Layer 3 Stage 4
buf(prop_4_0,prop_3_0);
buf(gen_4_0,gen_3_0);
buf(prop_4_1,prop_3_1);
buf(gen_4_1,gen_3_1);
buf(prop_4_2,prop_3_2);
buf(gen_4_2,gen_3_2);
buf(prop_4_3,prop_3_3);
buf(gen_4_3,gen_3_3);
buf(prop_4_4,prop_3_4);
buf(gen_4_4,gen_3_4);
buf(prop_4_5,prop_3_5);
buf(gen_4_5,gen_3_5);
buf(prop_4_6,prop_3_6);
buf(gen_4_6,gen_3_6);
buf(prop_4_7,prop_3_7);
buf(gen_4_7,gen_3_7);
buf(prop_4_8,prop_3_8);
buf(gen_4_8,gen_3_8);
buf(prop_4_9,prop_3_9);
grey_circle gc_4_9(prop_3_9,gen_3_9,gen_3_1,gen_4_9);
buf(prop_4_10,prop_3_10);
buf(gen_4_10,gen_3_10);
buf(prop_4_11,prop_3_11);
grey_circle gc_4_11(prop_3_11,gen_3_11,gen_3_3,gen_4_11);
buf(prop_4_12,prop_3_12);
buf(gen_4_12,gen_3_12);
buf(prop_4_13,prop_3_13);
grey_circle gc_4_13(prop_3_13,gen_3_13,gen_3_5,gen_4_13);
buf(prop_4_14,prop_3_14);
buf(gen_4_14,gen_3_14);
buf(prop_4_15,prop_3_15);
grey_circle gc_4_15(prop_3_15,gen_3_15,gen_3_7,gen_4_15);
buf(prop_4_16,prop_3_16);
buf(gen_4_16,gen_3_16);
black_circle bc_4_17(prop_3_17,gen_3_17,prop_3_9,gen_3_9,prop_4_17,gen_4_17);
buf(prop_4_18,prop_3_18);
buf(gen_4_18,gen_3_18);
black_circle bc_4_19(prop_3_19,gen_3_19,prop_3_11,gen_3_11,prop_4_19,gen_4_19);
	//Layer 4 Stage 5
buf(prop_5_0,prop_4_0);
buf(gen_5_0,gen_4_0);
buf(prop_5_1,prop_4_1);
buf(gen_5_1,gen_4_1);
buf(prop_5_2,prop_4_2);
buf(gen_5_2,gen_4_2);
buf(prop_5_3,prop_4_3);
buf(gen_5_3,gen_4_3);
buf(prop_5_4,prop_4_4);
buf(gen_5_4,gen_4_4);
buf(prop_5_5,prop_4_5);
buf(gen_5_5,gen_4_5);
buf(prop_5_6,prop_4_6);
buf(gen_5_6,gen_4_6);
buf(prop_5_7,prop_4_7);
buf(gen_5_7,gen_4_7);
buf(prop_5_8,prop_4_8);
buf(gen_5_8,gen_4_8);
buf(prop_5_9,prop_4_9);
buf(gen_5_9,gen_4_9);
buf(prop_5_10,prop_4_10);
buf(gen_5_10,gen_4_10);
buf(prop_5_11,prop_4_11);
buf(gen_5_11,gen_4_11);
buf(prop_5_12,prop_4_12);
buf(gen_5_12,gen_4_12);
buf(prop_5_13,prop_4_13);
buf(gen_5_13,gen_4_13);
buf(prop_5_14,prop_4_14);
buf(gen_5_14,gen_4_14);
buf(prop_5_15,prop_4_15);
buf(gen_5_15,gen_4_15);
buf(prop_5_16,prop_4_16);
buf(gen_5_16,gen_4_16);
buf(prop_5_17,prop_4_17);
grey_circle gc_5_17(prop_4_17,gen_4_17,gen_4_1,gen_5_17);
buf(prop_5_18,prop_4_18);
buf(gen_5_18,gen_4_18);
buf(prop_5_19,prop_4_19);
grey_circle gc_5_19(prop_4_19,gen_4_19,gen_4_3,gen_5_19);
	//Layer 5 Stage 6
buf(prop_6_0,prop_5_0);
buf(gen_6_0,gen_5_0);
buf(prop_6_1,prop_5_1);
buf(gen_6_1,gen_5_1);
buf(prop_6_2,prop_5_2);
buf(gen_6_2,gen_5_2);
buf(prop_6_3,prop_5_3);
buf(gen_6_3,gen_5_3);
buf(prop_6_4,prop_5_4);
buf(gen_6_4,gen_5_4);
buf(prop_6_5,prop_5_5);
buf(gen_6_5,gen_5_5);
buf(prop_6_6,prop_5_6);
buf(gen_6_6,gen_5_6);
buf(prop_6_7,prop_5_7);
buf(gen_6_7,gen_5_7);
buf(prop_6_8,prop_5_8);
buf(gen_6_8,gen_5_8);
buf(prop_6_9,prop_5_9);
buf(gen_6_9,gen_5_9);
buf(prop_6_10,prop_5_10);
buf(gen_6_10,gen_5_10);
buf(prop_6_11,prop_5_11);
buf(gen_6_11,gen_5_11);
buf(prop_6_12,prop_5_12);
buf(gen_6_12,gen_5_12);
buf(prop_6_13,prop_5_13);
buf(gen_6_13,gen_5_13);
buf(prop_6_14,prop_5_14);
buf(gen_6_14,gen_5_14);
buf(prop_6_15,prop_5_15);
buf(gen_6_15,gen_5_15);
buf(prop_6_16,prop_5_16);
buf(gen_6_16,gen_5_16);
buf(prop_6_17,prop_5_17);
buf(gen_6_17,gen_5_17);
buf(prop_6_18,prop_5_18);
buf(gen_6_18,gen_5_18);
buf(prop_6_19,prop_5_19);
buf(gen_6_19,gen_5_19);

//last_layer Stage 7
buf(prop_7_0,prop_6_0);
buf(gen_7_0,gen_6_0);
buf(prop_7_1,prop_6_1);
buf(gen_7_1,gen_6_1);
buf(prop_7_2,prop_6_2);
grey_circle gc_7_2(prop_6_2,gen_6_2,gen_6_1,gen_7_2);
buf(prop_7_3,prop_6_3);
buf(gen_7_3,gen_6_3);
buf(prop_7_4,prop_6_4);
grey_circle gc_7_4(prop_6_4,gen_6_4,gen_6_3,gen_7_4);
buf(prop_7_5,prop_6_5);
buf(gen_7_5,gen_6_5);
buf(prop_7_6,prop_6_6);
grey_circle gc_7_6(prop_6_6,gen_6_6,gen_6_5,gen_7_6);
buf(prop_7_7,prop_6_7);
buf(gen_7_7,gen_6_7);
buf(prop_7_8,prop_6_8);
grey_circle gc_7_8(prop_6_8,gen_6_8,gen_6_7,gen_7_8);
buf(prop_7_9,prop_6_9);
buf(gen_7_9,gen_6_9);
buf(prop_7_10,prop_6_10);
grey_circle gc_7_10(prop_6_10,gen_6_10,gen_6_9,gen_7_10);
buf(prop_7_11,prop_6_11);
buf(gen_7_11,gen_6_11);
buf(prop_7_12,prop_6_12);
grey_circle gc_7_12(prop_6_12,gen_6_12,gen_6_11,gen_7_12);
buf(prop_7_13,prop_6_13);
buf(gen_7_13,gen_6_13);
buf(prop_7_14,prop_6_14);
grey_circle gc_7_14(prop_6_14,gen_6_14,gen_6_13,gen_7_14);
buf(prop_7_15,prop_6_15);
buf(gen_7_15,gen_6_15);
buf(prop_7_16,prop_6_16);
grey_circle gc_7_16(prop_6_16,gen_6_16,gen_6_15,gen_7_16);
buf(prop_7_17,prop_6_17);
buf(gen_7_17,gen_6_17);
buf(prop_7_18,prop_6_18);
grey_circle gc_7_18(prop_6_18,gen_6_18,gen_6_17,gen_7_18);
buf(prop_7_19,prop_6_19);
buf(gen_7_19,gen_6_19);

//final carry values
buf(carry[0],gen_7_0);
buf(carry[1],gen_7_1);
buf(carry[2],gen_7_2);
buf(carry[3],gen_7_3);
buf(carry[4],gen_7_4);
buf(carry[5],gen_7_5);
buf(carry[6],gen_7_6);
buf(carry[7],gen_7_7);
buf(carry[8],gen_7_8);
buf(carry[9],gen_7_9);
buf(carry[10],gen_7_10);
buf(carry[11],gen_7_11);
buf(carry[12],gen_7_12);
buf(carry[13],gen_7_13);
buf(carry[14],gen_7_14);
buf(carry[15],gen_7_15);
buf(carry[16],gen_7_16);
buf(carry[17],gen_7_17);
buf(carry[18],gen_7_18);
buf(carry[19],gen_7_19);
endmodule
