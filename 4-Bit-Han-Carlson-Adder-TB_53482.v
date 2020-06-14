`timescale 1ps / 1ps
module simu();
    reg [3:0] input1,input2;
    wire [3:0] sum;
    Han_Carlson_Adder n1(.input1(input1),.input2(input2),.sum(sum));
    initial begin
    $monitor("%d + %d = %d",input1,input2,sum);
    #2 input1=4;
     input2=7;
    #2 $finish;
    end
endmodule