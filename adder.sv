module adder (
    input  logic [31:0]	input_a,  
    input  logic [31:0]	input_b,
    output logic [31:0] sum
);
    assign sum = input_a + input_b;
endmodule
