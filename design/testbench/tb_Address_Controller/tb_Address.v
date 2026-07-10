`timescale 1ns/1ps

module tb_Address;


reg        clk;
reg        rst;
reg  [5:0] addr_in;
reg        enb;
reg        pwm;
reg        sub;
reg  [1:0] line;

reg  [7:0] raddr_RAM0;
reg  [7:0] raddr_RAM1;
reg  [7:0] raddr_RAM2;
reg  [7:0] waddr_RAM0;
reg  [7:0] waddr_RAM2;
reg  [7:0] raddr_ROM_r1;


wire [7:0] raddr_p_RAM0;
wire [7:0] raddr_p_RAM1;
wire [7:0] raddr_p_RAM2;
wire [7:0] waddr_p_RAM0;
wire [7:0] waddr_p_RAM2;
wire [7:0] raddr_p_ROM_r1;

addres_controller UUT_ADDR_TOP (
    .clk(clk),
    .rst(rst),
    .addr_in(addr_in),
    .enb(enb),
    .pwm(pwm),
    .sub(sub),
    .line(line),
    
    .raddr_RAM0(raddr_RAM0),
    .raddr_RAM1(raddr_RAM1),
    .raddr_RAM2(raddr_RAM2),
    .waddr_RAM0(waddr_RAM0),
    .waddr_RAM2(waddr_RAM2),
    .raddr_ROM_r1(raddr_ROM_r1),

    .raddr_p_RAM0(raddr_p_RAM0),
    .raddr_p_RAM1(raddr_p_RAM1),
    .raddr_p_RAM2(raddr_p_RAM2),
    .waddr_p_RAM0(waddr_p_RAM0),
    .waddr_p_RAM2(waddr_p_RAM2),
    .raddr_p_ROM_r1(raddr_p_ROM_r1)
);

// 100MHz Clock Generator
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end


initial begin
   
    rst          = 1'b1;
    enb          = 1'b0;
    addr_in      = 6'd0;
    pwm          = 1'b0;
    sub          = 1'b0;
    line         = 2'b00;
    
    // Giả lập các địa chỉ RAM/ROM gốc (Ví dụ: RAM0 từ 0, RAM1 từ 0x10...)
    raddr_RAM0   = 8'h00;
    raddr_RAM1   = 8'h10;
    raddr_RAM2   = 8'h20;
    waddr_RAM0   = 8'h80;
    waddr_RAM2   = 8'hA0;
    raddr_ROM_r1 = 8'hFC;
    
    // 2. Thực hiện Reset
    #50;
    rst          = 1'b0; 
    #30;              
    
   
    @(posedge clk);
    enb          = 1'b1;
    pwm          = 1'b1;  
    sub          = 1'b0;
    line         = 2'b01; 
    
    
    addr_in = 6'd5;   #10;
    addr_in = 6'd24;  #10;
    addr_in = 6'd18;  #10;
    
    // Cố định dữ liệu nền tiếp theo
    addr_in = 6'd0;
    
   
    #400;
    
    $display("=== MÔ PHỎNG KHỐI TỔNG ADDRESS CONTROLLER ĐÃ THÀNH CÔNG ===");
    $finish;
end

endmodule