module In_mem (
    input  logic  clk,
    input  logic  rst,
    input  logic  inmem_enable,
    input  logic	data_in [15:0],
	 output logic  in_done,
    output logic	data_out [15:0]
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= '{default:0};
				in_done <= 0;
		  end
        else begin
				if (inmem_enable) begin
				integer i;
				for (i = 0; i < 16; i++) data_out [i] <= data_in [i];
				in_done <= 1;
				end
				else begin 
				data_out <= '{default:0};
				in_done <= 0;				
				end
		  end
	 end
	 
endmodule
