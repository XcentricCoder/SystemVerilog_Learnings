module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output fr3,
    output fr2,
    output fr1,
    output dfr
); 
    reg [3:1] state, next_state;
    parameter [2:0] above_s3= 3'b000,
    				s3_s2_from_above= 3'b001, 
    				s3_s2_from_below=3'b010,
    				s2_s1_from_above=3'b011,
    				s2_s1_from_below=3'b100,
    				below_s1= 3'b101;
    always@(*)begin
        case(state)
            above_s3: begin
                if(s== 3'b111)
                    next_state = above_s3;
                else if(s==3'b011)
                    next_state = s3_s2_from_above;
                else
                    next_state = above_s3;
            end
            s3_s2_from_above: begin
                if(s== 3'b111)
                    next_state = above_s3;
                else if(s== 3'b011)
                    next_state =s3_s2_from_above;
                else if(s== 3'b001)
                    next_state =s2_s1_from_above;
                else
                    next_state = s3_s2_from_above;
            end
            s3_s2_from_below: begin
                if(s== 3'b111)
                    next_state = above_s3;
                else if(s== 3'b011)
                    next_state =s3_s2_from_below;
                else if(s== 3'b001)
                    next_state =s2_s1_from_above;
                else
                    next_state = s3_s2_from_below;
            end
            s2_s1_from_above: begin
                if(s== 3'b011)
                    next_state =s3_s2_from_below;
                else if(s== 3'b001)
                    next_state =s2_s1_from_above;
                else if(s== 3'b000)
                    next_state =below_s1;
                else
                    next_state = s2_s1_from_above;
            end
            s2_s1_from_below: begin
                if(s== 3'b011)
                    next_state = s3_s2_from_below;
                else if(s== 3'b001)
                    next_state =s2_s1_from_below;
                else if(s== 3'b000)
                    next_state = below_s1;
                else
                    next_state = s2_s1_from_below;
            end
            below_s1: begin
                if(s== 3'b001)
                    next_state =s2_s1_from_below;
                else
                    next_state = below_s1;
            end
            default: next_state = above_s3;
            endcase
    end    
        always@(posedge clk)begin
            if(reset)
                state <= below_s1;
            else
                state <= next_state;
        end
    
    always@(*)begin
        case(state)
            above_s3:begin
                fr1=0; fr2= 0; fr3=0; dfr=0;
            end
            s3_s2_from_above:begin
                fr1=1; fr2= 0; fr3=0; dfr=1;
            end
            s3_s2_from_below:begin
                fr1=1; fr2= 0; fr3=0; dfr=0;
            end
            s2_s1_from_above:begin
                fr1=1; fr2= 1; fr3=0; dfr=1;
            end
            s2_s1_from_below:begin
                fr1=1; fr2= 1; fr3=0; dfr=0;
            end
            below_s1:begin
                fr1=1; fr2= 1; fr3=1; dfr=1;
            end  
            
        endcase
    end

endmodule
