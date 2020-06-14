import math
import os 
import random
cwd = os.getcwd()
dir_list = os.listdir(cwd)
n = input("Enter value for n:\n")
n = int(n) 
print("Enter values to be added in test bench.")
while True:
    input1 = int(input(f"Input 1 (Max value = {2**int(n)-1} ({n} bits))\t"))
    if input1 >= 0 and input1 < 2**n:
        break
    else:
        print("Please enter valid value.")
while True:
    input2 = int(input(f"Input 2 (Max value = {2**int(n)-1} ({n} bits))\t"))
    if input2 >= 0 and input2 < 2**n:
        break
    else:
        print("Please enter valid value.")
if n <=0:
    print("Please enter a positive integer value for n.")
    exit()

verilog_file = ""
verilog_file += f'''//Han Carlson Adder for {n} bits

// we define the main function for Han_Carlson_Adder which takes in two inputs and returns an output
module Han_Carlson_Adder(input1, input2, sum);

input [{n-1}:0] input1, input2;             // inputs with {n-1} bits
output [{n}:0] sum;                         // outputs with {n} bits 
wire [{n-1}:0] prop,gen,carry;              // wires to store output of stage, prop is progogation, gen is generated
// prop,gen stores initial prop and gen values before stage1

// prop and gen values at stage m and bit n (ranging from 0 to n-1), we have used convention prop_m_n and gen_m_n.
// before stage 1 initialised values are stored in prop and gen array as prop[i] and gen[i] where i denotes bit no.

// initialise prop and gen values before stage 1 using the input values.\n'''

for i in range(n):
    verilog_file += f"initialise ini{i}(input1[{i}],input2[{i}],prop[{i}],gen[{i}]);\n"

verilog_file += f"// run main logic of the code\n"
verilog_file += f"main_logic carry_gen(prop,gen,carry);\n"

verilog_file += f"//finally store the result values in sum\n"
verilog_file += f"buf (sum[0],prop[0]);\n"
for i in range(1,n):
    verilog_file += f"xor (sum[{i}],prop[{i}],carry[{i-1}]);\n"
verilog_file += f"buf (sum[{n}],carry[{n-1}]);\n"
verilog_file += f"endmodule\n"

verilog_file += '''// initialise module takes one bit each from both the inputs and returns the propogate and generate values for each set.
module initialise(input1,input2,prop,gen);
input input1, input2;
output prop,gen;
xor (prop,input1, input2);          // prop is equal to 'xor' of input1 and input2
and (gen,input1, input2);           // gen is equal to 'and' of input1 and input2
endmodule\n'''

verilog_file += '''// grey_circle module simulates the operation of grey circle in the Han_Carlson_Adder structure.
// it takes prev stage values of prop and gen and returns new values according to below defined operation.
module grey_circle(p_1,g_1,g_2,g_final);
input p_1,g_1,g_2;
output g_final;
wire w;                             // w will store value of 'and' of p_1 and g_2
and (w,p_1,g_2);                    // then we perform 'or' operation with g_1 to get g_final
or (g_final,g_1,w);
endmodule\n'''  

verilog_file += '''// black_circle module simulates the operation of black circle in the Han_Carlson_Adder structure.
// it takes prev stage values of prop and gen and returns new values according to below defined operation.
module black_circle(p_1,g_1,p_2,g_2,p_final,g_final);
input p_1,g_1,p_2,g_2;
output p_final,g_final;
wire w;
and (p_final,p_1,p_2);
and (w,p_1,g_2);
or (g_final,w,g_1);
endmodule\n'''

verilog_file += f'''// Main_logic implements the logic of the Han_Carlson_Adder and uses other modules to perform operations.
// The sequence of use of modules in main_logic is responsible for adder's functioning and makes it unique
// from other adders.
module main_logic(prop,gen,carry);
input [{n-1}:0] prop,gen;
output [{n-1}:0] carry;\n'''

# Here we start with the logic part of the code.
# We need to define code for main_logic to implement structure of Han Carlson Adder for n bits.
logic_depth = int(math.log2(n)+1)
total_layers = logic_depth + 2              #logic depth + first layer + last layer
stage = 1
layer = 1
#defining first_layer
verilog_file += f"//first_layer stage1\n"
grey_positions = [1]
black_positions = []
for i in range(3,n,2):
    black_positions.append(i)
for bit in range(n):
    if bit in black_positions:
        verilog_file += f"black_circle bc_1_{bit}(prop[{bit}],gen[{bit}],prop[{bit-1}],gen[{bit-1}],prop_1_{bit},gen_1_{bit});\n"
    elif bit in grey_positions:
        verilog_file += f"buf(prop_1_{bit},prop[{bit}]);\n"
        verilog_file += f"grey_circle gc_1_{bit}(prop[{bit}],gen[{bit}],gen[{bit-1}],gen_1_{bit});\n"
    else:
        verilog_file += f"buf(prop_1_{bit},prop[{bit}]);\n"
        verilog_file += f"buf(gen_1_{bit},gen[{bit}]);\n"
stage += 1
verilog_file += "\n"

#defining logic_depth layers
verilog_file += f"// logic depth layer with layers = (logn + 1)\n"
for layer in range(1,logic_depth+1):
    verilog_file += f"\t//Layer {layer} Stage {stage}\n"
    grey_positions = []
    black_positions = []
    exponent = 2**layer
    for grey_position in range(exponent+1,exponent*2,2):
        grey_positions.append(grey_position)
    for black_position in range(exponent*2+1,n,2):
        black_positions.append(black_position)
    for bit in range(n):
        if bit in black_positions:
            verilog_file += f"black_circle bc_{stage}_{bit}(prop_{stage-1}_{bit},gen_{stage-1}_{bit},prop_{stage-1}_{bit-exponent},gen_{stage-1}_{bit-exponent},prop_{stage}_{bit},gen_{stage}_{bit});\n"
        elif bit in grey_positions:
            verilog_file += f"buf(prop_{stage}_{bit},prop_{stage-1}_{bit});\n"
            verilog_file += f"grey_circle gc_{stage}_{bit}(prop_{stage-1}_{bit},gen_{stage-1}_{bit},gen_{stage-1}_{bit-exponent},gen_{stage}_{bit});\n"
        else:
            verilog_file += f"buf(prop_{stage}_{bit},prop_{stage-1}_{bit});\n"
            verilog_file += f"buf(gen_{stage}_{bit},gen_{stage-1}_{bit});\n"
    stage += 1
verilog_file += "\n"

#defining last_layers
verilog_file += f"//last_layer Stage {stage}\n"
grey_positions = []
for i in range(2,n,2):
    grey_positions.append(i)
for bit in range(n):
    verilog_file += f"buf(prop_{total_layers}_{bit},prop_{total_layers-1}_{bit});\n"
    if bit in grey_positions:
        verilog_file += f"grey_circle gc_{total_layers}_{bit}(prop_{total_layers-1}_{bit},gen_{total_layers-1}_{bit},gen_{total_layers-1}_{bit-1},gen_{total_layers}_{bit});\n"
    else:
        verilog_file += f"buf(gen_{total_layers}_{bit},gen_{total_layers-1}_{bit});\n"
verilog_file += "\n"
verilog_file += "//final carry values\n"
for bit in range(n):
    verilog_file += f"buf(carry[{bit}],gen_{total_layers}_{bit});\n"
verilog_file += "endmodule\n"
# print(verilog_file)
while True:
    file_id = random.randint(0,100000)
    new_adder_filename = f"{n}-Bit-Han-Carlson-Adder_{file_id}.v"
    if not new_adder_filename in dir_list:
        break
file = open(new_adder_filename, "w") 
file.write(verilog_file) 
file.close()
print(f"Adder code generated in file: {new_adder_filename}")

#writing test bench
testbench_file = ""

testbench_file += f'''`timescale 1ps / 1ps
module simu();
    reg [{n-1}:0] input1,input2;
    wire [{n}:0] sum;
    Han_Carlson_Adder n1(.input1(input1),.input2(input2),.sum(sum));
    initial begin
    $monitor("%d + %d = %d",input1,input2,sum);
    #2 input1={input1};
     input2={input2};
    #2 $finish;
    end
endmodule'''
# print(testbench_file)
new_testbench_filename = f"{n}-Bit-Han-Carlson-Adder-TB_{file_id}.v"
file = open(new_testbench_filename, "w")
if new_testbench_filename in dir_list:
    print("File with same id already exists. Please delete it to get code there.")
    print("For this request, your testbench code is printed below. Save it in a file manually.\n\n")
    print(testbench_file)
else: 
    file.write(testbench_file) 
    file.close()
    print(f"Testbench code generated in file: {new_testbench_filename}")