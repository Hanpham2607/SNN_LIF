module Control (
    input  logic clk,
    input  logic rst,
	 input  logic start,
	 input  logic sum_data,
	 input  logic spike_1,
	 input  logic out_valid, in_done, we_done, add_done, lif_ready,
	 output logic out_en, in_en, we_en, add_en, lif_en
);
	 
typedef enum logic [2:0] {
    IDLE    = 3'd0,
    PHASE_MEM  = 3'd1,
    PHASE_ADD  = 3'd2,
    PHASE_LIF  = 3'd3,
	 PHASE_OUT  = 3'd4
} state_t;

state_t state, next_state;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
    end else 
        state <= next_state;
end
	 always_comb begin
		  {out_en, in_en, we_en, add_en, lif_en} <= 0;
        case (state)
				IDLE: begin
				{out_en, in_en, we_en, add_en, lif_en} <= 0;
				next_state = (start) ? PHASE_MEM : IDLE;
				end
				
            PHASE_MEM: begin
                {out_en, add_en, lif_en} <= 0;
					 in_en <= 1;
					 we_en <= 1;
					 if (in_done == 1 && we_done == 1) 
					 next_state = PHASE_ADD;
					 else next_state = PHASE_MEM;
            end
				
            PHASE_ADD: begin
                {out_en, in_en, we_en, lif_en} <= 0;
					 add_en <= 1;
					 next_state = (add_done) ? PHASE_LIF : PHASE_ADD;
            end
				
            PHASE_LIF: begin
					 {out_en, in_en, we_en, add_en} <= 0;
					 lif_en <= 1;
					 next_state = (lif_ready) ? PHASE_OUT : PHASE_LIF;
            end
				
				PHASE_OUT: begin
					 {in_en, we_en, add_en, lif_en} <= 0;
					 out_en <= 1;
					 next_state = (out_valid) ? IDLE : PHASE_OUT;
            end
				
				default: next_state = IDLE;
        endcase
    end

endmodule
