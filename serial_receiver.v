/*In many (older) serial communications protocols, each data byte is sent along with a start bit and a stop bit,
to help the receiver delimit bytes from the stream of bits. One common scheme is to use one start bit (0), 8 data bits, and 1 stop bit (1). 
The line is also at logic 1 when nothing is being transmitted (idle).

Design a finite state machine that will identify when bytes have been correctly received when given a stream of bits. 
It needs to identify the start bit, wait for all 8 data bits, and then verify that the stop bit was correct.
If the stop bit does not appear when expected, the FSM must wait until it finds a stop bit before attempting to receive the next byte.
*/
module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
parameter idle=3'b000,start=3'b001, receive =3'b010, wait_state =3'b011 , stop=3'b100;
    reg [2:0] state, next_state;
    reg [3:0] i;
    always@(*) begin
        case(state)
            idle: next_state= (in)? idle:start;
            start: next_state=receive;
			receive: begin
                if (i==8)
                    begin
                        if(in)next_state = stop;
                        else next_state = wait_state;
                    end
                else begin
                    next_state = receive;
                end
            end
            wait_state: next_state= (in)? idle: wait_state;
            stop: next_state= (in)? idle: start;
        endcase
        
    end
    
    always@(posedge clk) begin
        if(reset) state <= idle;
        else state <= next_state;
    end
    
    always@(posedge clk )begin
        if (reset)begin
            done <=0;
            i<=0;
        end
    	else begin
            case(next_state)
                receive: begin
            		done <= 1'b0;
                    i<= i+1;
                end
                stop:begin
                	done <= 1'b1;
                    i<=0;
                end
                default:begin
                	done <= 1'b0;
                    i<= 0;
                end
            endcase
            
        end       
    end

endmodule
