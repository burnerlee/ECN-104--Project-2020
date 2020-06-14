`timescale 1ps / 1ps
module simu();
    reg [19:0] input1,input2;
    wire [19:0] sum;
    Han_Carlson_Adder n1(.input1(input1),.input2(input2),.sum(sum));
    initial begin
    $monitor("%d + %d = %d",input1,input2,sum);
    #2 input1=100000;
     input2=234545;
    #2 $finish;
    end
endmodule