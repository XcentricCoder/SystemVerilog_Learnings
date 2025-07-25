module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    wire [3:0] hh_ones= hh[3:0];
    wire [3:0] hh_tens= hh[7:4];
    wire [3:0] mm_ones= mm[3:0];
    wire [3:0] mm_tens= mm[7:4];
    wire [3:0] ss_ones= ss[3:0];
    wire [3:0] ss_tens= ss[7:4];
    always@(posedge clk)begin
        if (reset)begin
            ss<=8'h0;
            mm<=8'h0;
            hh<=8'h12;
            pm<=1'b0;
        end
//////////////////////////////////////////////////////////////////
        else if(ena)
            begin//increment seconds
                if(ss==8'h59)begin
                    ss<=8'h00;
                    //increments minutes
                    if(mm==8'h59)begin
                        mm<=8'h00;
                        //increments hours
                        if(hh==8'h11)begin
                            hh<=8'h12;
                            pm<=~pm;
                        end
                        else if(hh==8'h12)begin
                            hh<=8'h01;
                        end
                        else begin
                            if(hh_ones==4'd9)begin
                                hh<= {hh_tens+4'd1,4'd0};
                            end
                            else begin
                                hh<= {hh_tens,hh_ones+4'd01};
                            end
                        end
                    end 
                    else begin
                        if(mm_ones==4'd9)begin
                            mm<= {mm_tens+4'd1,4'd0};
                        end
                        else begin
                            mm<= {mm_tens,mm_ones+4'd1};
                        end
                    end
                end
             else begin
                    if(ss_ones==4'd9)begin
                        ss<= {ss_tens+4'd1,4'd0};
                    end
                    else begin
                        ss<= {ss_tens,ss_ones+4'd1};
                    end
                end
            end
    end
endmodule
