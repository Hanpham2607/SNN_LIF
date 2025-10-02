module Cas_adder (
    input  logic         clk,
    input  logic         rst,
    input  logic         adder_enable,
    input  logic         in_add [15:0],
    input  logic [15:0]  we_add [15:0],

    output logic         add_done,
    output logic [31:0]  total_sum
);

    logic [31:0] stage_data [0:15];
    integer num_sum;
	 logic [6:0] i_odd = 0, i_even = 0, neuron;

    typedef enum logic [3:0] {
        IDLE,
        LOAD,
        ADD_STAGE,
		  EVEN_CALC,
		  ODD_CALC,
        DONE,
		  /*DONE_2,*/
		  WAIT
    } state_t;

    state_t state, next_state;
	 
	  typedef enum logic [1:0] { 
		  ODD,
		  EVEN,
		  OUT_ADD
	} state_1;
	
	state_1 A;
	 
always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end
	 
    always_comb begin
        next_state = state;
        case (state)
            IDLE:      begin if (adder_enable) next_state = LOAD; else next_state = IDLE; end
            LOAD:      next_state = ADD_STAGE;
            ADD_STAGE: begin 
					if (A == EVEN) next_state = EVEN_CALC;
					if (A == ODD) next_state = ODD_CALC;
					if (A == OUT_ADD) next_state = DONE; 
					end
            EVEN_CALC: next_state = ADD_STAGE;
				ODD_CALC:  next_state = ADD_STAGE;
				DONE:      next_state = WAIT;
				WAIT:		  begin if (!adder_enable) next_state = IDLE; else next_state = WAIT; end
				default:	  next_state = IDLE;
        endcase
    end
	 
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            add_done    = 0;
            total_sum   = 0;
            neuron      = 0;
				i_odd = 0;
				i_even = 0;
				num_sum = 0;
            for (int i = 0; i < 16; i++) stage_data[i] = 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    add_done  = 0;
                    total_sum = 0;
						  for (int i = 0; i < 16; i++) stage_data[i] = 32'd0;
                end

                LOAD: begin
                    for (int i = 0; i < 16; i++) begin
                        stage_data[i] = in_add[i] ? {16'd0, we_add[i]} : 32'd0;
                    end
                    neuron = 16;
						  end
						  
                ADD_STAGE: begin 
					 if (neuron != 1 && neuron != 2) begin
                    if ((neuron % 2) == 0) begin
                      if (i_even == 0) begin
								num_sum <= neuron >> 1;
                        i_even  <= neuron >> 1;
								neuron  <= neuron >> 1;
						  end else begin if (i_even > 0) i_even <= i_even - 1; 
						  A <= ODD; end
						  end else begin 
							 neuron <= (neuron + 1) >> 1;
							 if (i_odd == 0) begin
								num_sum <= (neuron + 1) >> 1;
                        i_odd   <= (neuron + 1) >> 1;
								neuron  <= (neuron + 1) >> 1;
							 end else begin if (i_even > 0) i_even <= i_even - 1; 
							 A <= EVEN; end
						  end 
					 end else begin
					 if (neuron == 2) stage_data[0] <= stage_data[0] + stage_data[1];
					 neuron <= 1;
					 A <= OUT_ADD; end 
					 end
						  
					 ODD_CALC: begin							//neuron odd
						if (i_odd != 0 && i_odd <= num_sum) begin
                    stage_data[i_odd] <= stage_data[2*i_odd] + stage_data[2*i_odd - 1];end 
                    if (i_even == 0 && neuron != 0 && neuron != 1) stage_data[0] <= stage_data[0] + stage_data[neuron];
					 end
							 
					 EVEN_CALC: begin  									//neuron even
								if (i_even != 0 && i_even <= num_sum) begin
                            stage_data[i_even] <= stage_data[2*i_even] + stage_data[2*i_even - 1];
									 i_even <= i_even - 1; end 
								neuron <= num_sum;
					 end
				
					 /*DONE_1: begin 
					 total_sum <= stage_data[0] + stage_data[1];
					 add_done <= 1;
					 end*/
					 
					 DONE: begin 
					 total_sum <= stage_data[0];
					 add_done <= 1;
					 end
				
					 WAIT: ;

			endcase
		end
end

endmodule
