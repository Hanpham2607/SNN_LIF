module We_mem (
    input   logic        clk,
    input   logic        rst,
    input   logic        wemem_enable,
	 input   logic [15:0] weight_in [15:0],
	 output	logic			 we_done,
	 output  logic [15:0] weight_out [15:0]
);
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            weight_out <= '{default:0};
				we_done <= 0;
		  end
        else begin
				if (wemem_enable) begin
				integer i;
				for (i = 0; i < 16; i++)
            weight_out [i] <= weight_in [i];
				we_done <= 1;
				end
				else begin 
				weight_out <= '{default:0};
				we_done <= 0;			
				end
		  end
    end
endmodule