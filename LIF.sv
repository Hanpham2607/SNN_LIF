module LIF #(parameter int THRESHOLD = 58)
(
    input  logic        clk,
    input  logic        rst,
	 input  logic			spike_ack,
    input  logic [31:0] input_current,
	 input  logic			lif_enable,
	 output logic			lif_ready,
    output logic        spike
); 
logic [31:0] membrane_potential, input_stored = 0;

typedef enum logic [3:0] { 
		  IDLE,
		  ACC,
		  SPIKE,
		  WAIT
	} state_t;
	
	state_t state, next_state;

	always_comb begin
        next_state = state;
        case (state)
            IDLE:		 if (lif_enable) next_state = ACC; else next_state = IDLE;
				ACC:      if (membrane_potential >= THRESHOLD) next_state = SPIKE; else next_state = ACC;
				SPIKE:	 if (spike_ack) next_state = WAIT; else next_state = SPIKE;
				WAIT: 	 next_state = IDLE;
				default:	 next_state = IDLE;
        endcase
    end
	
	always_ff @(posedge clk or posedge rst) begin
		if (rst) 
			state <= IDLE;
		else 
			state <= next_state;
	end

	
    always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        membrane_potential <= 0;
        spike <= 0;
        lif_ready <= 0;
		  input_stored <= 0;
    end else begin
		if (lif_enable) begin
        case(state)
		  
		  IDLE: begin
				spike <= 0;
				lif_ready <= 0;
				membrane_potential <= 0;
				if (input_current != 0) input_stored <= input_current;
				else input_stored <= input_stored;
		  end
		  
		  ACC: membrane_potential <= (membrane_potential >> 1) + input_stored;
		  
		  SPIKE: begin
            spike <= 1;
            membrane_potential <= 0;
            lif_ready <= 1;
		  end
		  
		  WAIT: begin
            spike <= 0;
            lif_ready <= 0;
		  end
		  
		  endcase
		end
	end
end

endmodule