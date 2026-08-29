
`timescale 1ns/1ps

module tb_RPG ;


reg clk;
reg rst;
reg start;


wire       ena;
wire       enb;
wire       sel_0;
wire [1:0] sel_1;
wire [5:0] idx_prime;
wire       finish;


top UUT_RPG (
    .clk(clk),
    .rst(rst),
    .start(start),
    
    .ena(ena),
    .enb(enb),
    .sel_0(sel_0),
    .sel_1(sel_1),
    .idx_prime(idx_prime),
    .finish(finish)
);

initial 
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial 
begin

    rst   = 1'b1;
    start = 1'b0;
    
    // 2. Giữ Reset trong 5 chu kỳ clock (50ns)
    #50;
    rst   = 1'b0; // Nhả reset
    
    // 3. Chờ thêm 3 chu kỳ clock để mạch nội bộ sẵn sàng
    #30;
    
    // 4. Phát xung START dài 2 chu kỳ clock để đảm bảo FSM nhận được
    @(posedge clk);
    start = 1'b1;
    #20;
    start = 1'b0;
    

    #3000 ;
    
    $display("=== KẾT THÚC MÔ PHỎNG KHỐI RPG ===");
    $finish;
end


always @(posedge clk) 
begin
    if (!rst) begin
        $display("TIME = %0t | START = %b | IDX_PRIME = %h | FINISH = %b | ENA/ENB = %b%b", 
                 $time, start, idx_prime, finish, ena, enb);
    end
end

endmodule
