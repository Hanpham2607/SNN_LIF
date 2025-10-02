module TTNT_1 (
    input  logic clk,
    input  logic rst,
	 input  logic start,
    input  logic input_pixel [15:0],
    input  logic [15:0] input_weight [15:0],
    output logic result
);

logic valid_out, done_in, done_we, done_add, ready_lif;
logic en_out, en_in, en_we, en_add, en_lif, ack_spike;
logic in_pix [15:0];
logic [15:0] in_we [15:0];
logic [31:0] add_out; 
logic spike;

assign in_pix = input_pixel;
assign in_we = input_weight;

Cas_adder adder(
	 .clk (clk),
	 .rst (rst),
	 .in_add (in_pix),
	 .we_add (in_we),
	 .adder_enable (en_add),
	 .add_done (done_add),
	 .total_sum (add_out)
);	 
 
LIF neuron(
	 .clk (clk),
	 .rst (rst),
	 .input_current (add_out),
	 .spike_ack (ack_spike),
	 .lif_ready (ready_lif),
	 .lif_enable (en_lif),
	 .spike (spike)
);

Out_mem output_memory(
	 .clk (clk),
	 .rst (rst),
	 .out_valid (ack_spike),
	 .outmem_enable (en_out),
	 .out_out (result)
);

In_mem input_memory(
	 .clk (clk),
	 .rst (rst),
	 .in_done (done_in),
	 .inmem_enable (en_in),
	 .data_in (in_pix)
);

We_mem weight(
	 .clk (clk),
	 .rst (rst),
	 .we_done (done_we),
	 .wemem_enable (en_we), 
	 .weight_in (in_we)
);

Control ctrl(
	 .clk (clk),
	 .rst (rst),
	 .start (start),
	 .spike_1 (spike),
	 .in_done (done_in),
	 .we_done (done_we),
	 .add_done (done_add),
	 .lif_ready (ready_lif),
	 .out_en (en_out), 
	 .in_en (en_in),
	 .we_en (en_we),
	 .add_en (en_add),
	 .lif_en (en_lif)
);

endmodule
