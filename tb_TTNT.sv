module tb_TTNT_1;

    logic clk;
    logic rst;
    logic start;
    logic input_pixel [15:0];
    logic [15:0] input_weight [15:0];
    logic result;

    // Instantiate DUT
    TTNT_1 dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .input_pixel(input_pixel),
        .input_weight(input_weight),
        .result(result)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz

    // Stimulus
    initial begin
        // Init
        rst = 1;
        start = 1;
        input_pixel = '{default: 0};
        input_weight = '{default: 0};

        #20;
        rst = 0;

        // Setup input data
		  for (int i = 0; i < 16; i++) begin
            input_pixel[i] = i + 1;      // input_pixel = {1, 2, ..., 16}
            input_weight[i] = (i + 1)*2; // input_weight = {2, 4, ..., 32}
        end
			
			#50 start = 0;
        // Start operation

        #1000 $finish;
end

always @(posedge clk) begin
  $monitor ("time=%0t | input_pixel=%0p | result=%b | input_weight=%p ", 
           $time, dut.input_pixel, dut.result, dut.input_weight);
end

endmodule

