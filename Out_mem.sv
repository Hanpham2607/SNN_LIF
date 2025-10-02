module Out_mem(
    input  logic clk,
    input  logic rst,
    input  logic outmem_enable,
	 output logic out_valid,
    output logic out_out
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
		out_valid <= 0;
		out_out <= 0;
	 end else 
		if (outmem_enable) begin
			out_out <= 1;
			out_valid <= (out_out) ? 1 : 0;
		end else begin
			out_valid = 0;
			out_out = 0;
		end
end
endmodule
