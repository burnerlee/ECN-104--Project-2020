//Han Carlson Adder for 4 bits

// we define the main function for Han_Carlson_Adder which takes in two inputs and returns an output
module Han_Carlson_Adder(input1, input2, sum);

input [3:0] input1, input2;             // inputs with 3 bits
output [3:0] sum;                         // outputs with 3 bits 
wire [3:0] prop,gen,carry;              // wires to store output of stage, prop is progogation, gen is generated
// prop,gen stores initial prop and gen values before stage1

// prop and gen values at stage m and bit n (ranging from 0 to n-1), we have used convention prop_m_n and gen_m_n.
// before stage 1 initialised values are stored in prop and gen array as prop[i] and gen[i] where i denotes bit no.

// initialise prop and gen values before stage 1 using the input values.
initialise ini0(input1[0],input2[0],prop[0],gen[0]);
initialise ini1(input1[1],input2[1],prop[1],gen[1]);
initialise ini2(input1[2],input2[2],prop[2],gen[2]);
initialise ini3(input1[3],input2[3],prop[3],gen[3]);
// run main logic of the code
main_logic carry_gen(prop,gen,carry);
//finally store the result values in sum
buf (sum[0],prop[0]);
xor (sum[1],prop[1],carry[0]);
xor (sum[2],prop[2],carry[1]);
xor (sum[3],prop[3],carry[2]);
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
input [3:0] prop,gen;
output [3:0] carry;
//first_layer stage1
buf(prop_1_0,prop[0]);
buf(gen_1_0,gen[0]);
buf(prop_1_1,prop[1]);
grey_circle gc_1_1(prop[1],gen[1],gen[0],gen_1_1);
buf(prop_1_2,prop[2]);
buf(gen_1_2,gen[2]);
black_circle bc_1_3(prop[3],gen[3],prop[2],gen[2],prop_1_3,gen_1_3);

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
	//Layer 2 Stage 3
buf(prop_3_0,prop_2_0);
buf(gen_3_0,gen_2_0);
buf(prop_3_1,prop_2_1);
buf(gen_3_1,gen_2_1);
buf(prop_3_2,prop_2_2);
buf(gen_3_2,gen_2_2);
buf(prop_3_3,prop_2_3);
buf(gen_3_3,gen_2_3);
	//Layer 3 Stage 4
buf(prop_4_0,prop_3_0);
buf(gen_4_0,gen_3_0);
buf(prop_4_1,prop_3_1);
buf(gen_4_1,gen_3_1);
buf(prop_4_2,prop_3_2);
buf(gen_4_2,gen_3_2);
buf(prop_4_3,prop_3_3);
buf(gen_4_3,gen_3_3);

//last_layer Stage 5
buf(prop_5_0,prop_4_0);
buf(gen_5_0,gen_4_0);
buf(prop_5_1,prop_4_1);
buf(gen_5_1,gen_4_1);
buf(prop_5_2,prop_4_2);
grey_circle gc_5_2(prop_4_2,gen_4_2,gen_4_1,gen_5_2);
buf(prop_5_3,prop_4_3);
buf(gen_5_3,gen_4_3);

//final carry values
buf(carry[0],gen_5_0);
buf(carry[1],gen_5_1);
buf(carry[2],gen_5_2);
buf(carry[3],gen_5_3);
endmodule
