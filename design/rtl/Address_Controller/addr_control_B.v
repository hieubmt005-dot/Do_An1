

module addr_control_B (

    input clk,
    input rst,



    input enb,



    input [5:0] addr_in,


    output [5:0] addr,

    output [6:0] addr_r1,
    output [6:0] addr_r12,

    output [7:0] count,
    output [7:0] count_r1,
    output [7:0] count_r12

);


reg [5:0] addr_buf;

always @(posedge clk or posedge rst)
begin

    if(rst)
        addr_buf <= 6'd0;

    else if(enb)
        addr_buf <= addr_in;

end

assign addr = addr_buf;


reg [5:0] addr_delay1;

always @(posedge clk or posedge rst)
begin

    if(rst)
        addr_delay1 <= 6'd0;

    else if(enb)
        addr_delay1 <= addr;

end

assign addr_r1 = {1'b0, addr_delay1};


reg [5:0] addr_delay12 [0:11];

integer i;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        for(i=0;i<12;i=i+1)
            addr_delay12[i] <= 6'd0;

    end

    else if(enb)
    begin

        addr_delay12[0] <= addr;

        for(i=1;i<12;i=i+1)
            addr_delay12[i] <= addr_delay12[i-1];

    end

end

assign addr_r12 = {1'b0, addr_delay12[11]};


reg [7:0] counter;

always @(posedge clk or posedge rst)
begin

    if(rst)
        counter <= 8'd0;

    else if(enb)
        counter <= counter + 1'b1;

end

assign count = counter;


reg [7:0] counter_delay1;

always @(posedge clk or posedge rst)
begin

    if(rst)
        counter_delay1 <= 8'd0;

    else if(enb)
        counter_delay1 <= count;

end

assign count_r1 = counter_delay1;



reg [7:0] counter_delay12 [0:11];

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        for(i=0;i<12;i=i+1)
            counter_delay12[i] <= 8'd0;

    end

    else if(enb)
    begin

        counter_delay12[0] <= count;

        for(i=1;i<12;i=i+1)
            counter_delay12[i] <= counter_delay12[i-1];

    end

end

assign count_r12 = counter_delay12[11];

endmodule