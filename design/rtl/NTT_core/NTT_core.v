

module NTT_core  (

    input clk,
    input rst,
    input start,

    input [7:0] raddr_p_RAM0,
    input [7:0] raddr_p_RAM1,
    input [7:0] waddr_p_RAM0,



    output reg [7:0] raddr_RAM0,
    output reg [7:0] raddr_RAM1,
    output reg [7:0] waddr_RAM0,


    output reg pwm,
    output reg sub,



    output reg finish,

    output [3:0] power_trace_out

);



reg [15:0] RAM0 [0:255];



reg [15:0] ROM [0:255];


reg [15:0] A;
reg [15:0] B;

reg [15:0] W;

reg [15:0] add_result;
reg [15:0] sub_result;



reg [7:0] prev_raddr;

reg [3:0] power_trace;

assign power_trace_out = power_trace;



parameter IDLE      = 3'd0;
parameter READ      = 3'd1;
parameter BUTTERFLY = 3'd2;
parameter WRITE     = 3'd3;
parameter NEXT      = 3'd4;
parameter DONE      = 3'd5;

reg [2:0] state;



reg [7:0] counter;


reg [7:0] distance;


integer i;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        for(i=0;i<256;i=i+1)
        begin

            RAM0[i] <= i;

            ROM[i]  <= i + 1;

        end

    end

end



always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        prev_raddr <= 8'd0;

        power_trace <= 4'd0;

    end

    else if(state == READ)
    begin

        power_trace <=

            {3'd0,(raddr_p_RAM0[0] ^ prev_raddr[0])} +
            {3'd0,(raddr_p_RAM0[1] ^ prev_raddr[1])} +
            {3'd0,(raddr_p_RAM0[2] ^ prev_raddr[2])} +
            {3'd0,(raddr_p_RAM0[3] ^ prev_raddr[3])} +
            {3'd0,(raddr_p_RAM0[4] ^ prev_raddr[4])} +
            {3'd0,(raddr_p_RAM0[5] ^ prev_raddr[5])} +
            {3'd0,(raddr_p_RAM0[6] ^ prev_raddr[6])} +
            {3'd0,(raddr_p_RAM0[7] ^ prev_raddr[7])};

        prev_raddr <= raddr_p_RAM0;

    end

    else
    begin

        power_trace <= 4'd0;

    end

end



always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        state <= IDLE;

        counter <= 8'd0;

        distance <= 8'd1;

        finish <= 1'b0;

        pwm <= 1'b0;

        sub <= 1'b0;

        raddr_RAM0 <= 8'd0;
        raddr_RAM1 <= 8'd0;
        waddr_RAM0 <= 8'd0;

        A <= 16'd0;
        B <= 16'd0;
        W <= 16'd0;

        add_result <= 16'd0;
        sub_result <= 16'd0;

    end

    else
    begin

        case(state)

            IDLE:
            begin

                finish <= 1'b0;

                counter <= 8'd0;

                distance <= 8'd1;

                pwm <= 1'b0;

                sub <= 1'b0;

                if(start)
                    state <= READ;

            end



            READ:
            begin



                raddr_RAM0 <= counter;

                raddr_RAM1 <= counter + distance;



                A <= RAM0[raddr_p_RAM0];

                B <= RAM0[raddr_p_RAM1];



                W <= ROM[counter];



                pwm <= 1'b1;

                sub <= 1'b0;

                state <= BUTTERFLY;

            end



            BUTTERFLY:
            begin



                add_result <= A + B;

                sub_result <= A - B;

                pwm <= 1'b0;

                sub <= 1'b1;

                state <= WRITE;

            end

            WRITE:
            begin

                waddr_RAM0 <= counter;


                RAM0[waddr_p_RAM0] <= add_result;

                state <= NEXT;

            end



            NEXT:
            begin


                counter <= counter + 8'd2;


                if(counter >= 8'd254)
                begin

                    counter <= 8'd0;

                    distance <= distance << 1'b1;

                end


                if(distance >= 8'd128)
                    state <= DONE;

                else
                    state <= READ;

            end



            DONE:
            begin

                finish <= 1'b1;

                pwm <= 1'b0;

                sub <= 1'b0;

                state <= IDLE;

            end

        endcase

    end

end

endmodule