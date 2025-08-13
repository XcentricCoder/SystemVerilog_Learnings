/*We want to add parity checking to the serial receiver. Parity checking adds one extra bit after each data byte. We will use odd parity, where the number of 1s in the 9 bits received must be odd. For example, 101001011 satisfies odd parity (there are 5 1s), but 001001011 does not.

Change your FSM and datapath to perform odd parity checking. Assert the done signal only if a byte is correctly received and its parity check passes. Like the serial receiver FSM, this FSM needs to identify the start bit, wait for all 9 (data and parity) bits, then verify that the stop bit was correct. If the stop bit does not appear when expected, the FSM must wait until it finds a stop bit before attempting to receive the next byte.

You are provided with the following module that can be used to calculate the parity of the input stream (It's a TFF with reset). The intended use is that it should be given the input bit stream, and reset at appropriate times so it counts the number of 1 bits in each byte.

module parity (
    input clk,
    input reset,
    input in,
    output reg odd);

    always @(posedge clk)
        if (reset) odd <= 0;
        else if (in) odd <= ~odd;

endmodule

Note that the serial protocol sends the least significant bit first, and the parity bit after the 8 data bits.
*/module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Modify FSM and datapath from Fsm_serialdata
 localparam [2:0] IDLE 	 = 3'b000,
					 START 	 = 3'b001,
					 RECEIVE = 3'b010,
					 WAIT	 = 3'b011,
					 STOP    = 3'b100,
    				 CHECK   = 3'b101;

	reg [2:0] state, next;
	reg [3:0] i;
    reg [7:0] out;
    reg odd;
    reg odd_reg;
    reg odd_reset;

	always @(*) begin
		case(state)
			IDLE  : next = (in) ? IDLE : START;
			START : next = RECEIVE;
            RECEIVE : next = (i==8) ? CHECK: RECEIVE;
            CHECK : next = (in) ? STOP: WAIT;
			WAIT : next = (in) ? IDLE : WAIT;
			STOP : next = (in) ? IDLE : START;
		endcase
	end

	always @(posedge clk) begin
		if(reset) state <= IDLE;
		else state <= next;
	end

	always @(posedge clk) begin
		if (reset) begin
			i <= 0;
		end
		else begin
			case(next) 
				RECEIVE : begin
					
					i = i + 4'h1;
				end
				STOP : begin
					
					i <= 0;
				end
				default : begin
					
					i <= 0;
				end
			endcase
		end
	end

    // New: Datapath to latch input bits.
    always @(posedge clk) begin
    	if (reset) out <= 0;
    	else if (next == RECEIVE)
    		out[i] <= in;
    end

    

    // New: Add parity checking.
    parity u_parity(
        .clk(clk),
        .in(in),
        .reset(reset | odd_reset),
        .odd(odd)   
    
    );
    
    always@(posedge clk) begin
        if(reset)
            odd_reg <= 0;
        else
            odd_reg <= odd;
    end
    
    always@(posedge clk) begin
        case(next)
			IDLE : odd_reset <= 1;	
			STOP : odd_reset <= 1;
			default : odd_reset <= 0;
		endcase
    end
    
    assign done = ((state == STOP) && odd_reg);
    assign out_byte = (done) ? out: 8'b0;
    
endmodule
