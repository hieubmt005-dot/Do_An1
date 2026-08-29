

module RPG_B (

    input clk,
    input rst,

    input ena,
    input enb,

    input sel_0,

    input [5:0] rand_idx,
    input [5:0] perm_out,

    output reg [5:0] fifo_out

);


wire [5:0] mux1_out;

assign mux1_out = (sel_0) ? perm_out :
                            rand_idx;


reg [5:0] FIFO [0:63];

reg [5:0] wr_ptr;
reg [5:0] rd_ptr;

integer i;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin

        wr_ptr <= 0;
        rd_ptr <= 0;

        fifo_out <= 0;

        for(i=0;i<64;i=i+1)
            FIFO[i] <= 0;

    end



    else if(ena)
    begin

        FIFO[wr_ptr] <= mux1_out;

        wr_ptr <= wr_ptr + 1'b1;

    end



    else if(enb)
    begin

        fifo_out <= FIFO[rd_ptr];

        FIFO[wr_ptr] <= FIFO[rd_ptr];

        rd_ptr <= rd_ptr + 1'b1;
        wr_ptr <= wr_ptr + 1'b1;

    end

end

endmodule