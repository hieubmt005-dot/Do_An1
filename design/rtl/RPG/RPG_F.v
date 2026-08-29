

module RPG_E (

    input clk,
    input rst,
    input start,

    output reg ena,
    output reg enb,

    output reg sel_0,
    output reg [1:0] sel_1,

    output reg finish

);

parameter IDLE  = 2'd0;
parameter LOAD  = 2'd1;
parameter SHUFF = 2'd2;
parameter DONE  = 2'd3;

reg [1:0] state;

reg [6:0] counter;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        state <= IDLE;

        counter <= 0;

        ena <= 0;
        enb <= 0;

        sel_0 <= 0;
        sel_1 <= 0;

        finish <= 0;

    end

    else
    begin

        case(state)



            IDLE:
            begin

                finish <= 0;

                if(start)
                    state <= LOAD;

            end


            LOAD:
            begin

                ena <= 1'b1;
                enb <= 1'b0;

                sel_0 <= 1'b0;
                sel_1 <= 2'd0;

                counter <= counter + 1'b1;

                if(counter == 7'd63)
                begin

                    counter <= 0;

                    state <= SHUFF;

                end

            end


            SHUFF:
            begin

                ena <= 1'b0;
                enb <= 1'b1;

                sel_0 <= 1'b1;
                sel_1 <= 2'd1;

                counter <= counter + 1'b1;

                if(counter == 7'd63)
                    state <= DONE;

            end


            DONE:
            begin

                finish <= 1'b1;

                ena <= 0;
                enb <= 0;

            end

        endcase

    end

end

endmodule