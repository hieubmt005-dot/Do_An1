////////////////////////////////////////////////////////////
// TESTBENCH - ĐÃ SỬA CHUẨN ĐỂ CHẠY POST-SYNTHESIS
////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tb_final;

////////////////////////////////////////////////////////////
// INPUTS
////////////////////////////////////////////////////////////
reg clk;
reg rst;
reg start;

////////////////////////////////////////////////////////////
// OUTPUTS (Khai báo đầy đủ để testbench nhận tín hiệu)
////////////////////////////////////////////////////////////
wire [5:0] idx_prime;
wire [7:0] raddr_RAM0;
wire [7:0] raddr_RAM1;
wire [7:0] raddr_p_RAM0;
wire [7:0] raddr_p_RAM1;
wire       pwm;
wire       sub;
wire [3:0] power_trace;
wire       finish_rpg;
wire       finish_ntt;

////////////////////////////////////////////////////////////
// DUT INSTANTIATION (Map chuẩn 100% cổng, không sợ lỗi Z/X)
////////////////////////////////////////////////////////////
final DUT (
    .clk(clk),
    .rst(rst),
    .start(start),

    .idx_prime(idx_prime),
    .raddr_RAM0(raddr_RAM0),
    .raddr_RAM1(raddr_RAM1),
    .raddr_p_RAM0(raddr_p_RAM0),
    .raddr_p_RAM1(raddr_p_RAM1),

    .pwm(pwm),
    .sub(sub),
    .power_trace(power_trace),
    .finish_rpg(finish_rpg),
    .finish_ntt(finish_ntt)
);

////////////////////////////////////////////////////////////
// CLOCK GENERATION
////////////////////////////////////////////////////////////
initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

////////////////////////////////////////////////////////////
// RESET + START CONTROL
////////////////////////////////////////////////////////////
initial
begin
    rst   = 1'b1;
    start = 1'b0;

    #50;          // Giữ reset
    rst = 1'b0;   // Nhả reset

    #30;          // Chờ mạch ổn định
    start = 1'b1; // Phát xung START
    #30;
    start = 1'b0;

    #5000;        // Chạy giả lập 5000ns
    $display("=== MÔ PHỎNG HOÀN THÀNH ===");
    $finish;
end

////////////////////////////////////////////////////////////
// MONITOR (Khối hiển thị chuẩn, không gọi phân cấp nội bộ)
////////////////////////////////////////////////////////////
always @(posedge clk)
begin
    $display("================================================");
    $display("TIME = %0t | RST = %b | START = %b", $time, rst, start);
    $display("FINISH_RPG = %b | FINISH_NTT = %b", finish_rpg, finish_ntt);
    $display("IDX_PRIME  = %h", idx_prime);
    $display("ORIGINAL ADDR : R0=%h, R1=%h", raddr_RAM0, raddr_RAM1);
    $display("SHUFFLED ADDR : R0=%h, R1=%h", raddr_p_RAM0, raddr_p_RAM1);
    $display("CONTROL       : PWM=%b, SUB=%b", pwm, sub);
    $display("POWER_TRACE   = %d", power_trace);
end

////////////////////////////////////////////////////////////
// VCD WAVEFORM
////////////////////////////////////////////////////////////
initial
begin
    $dumpfile("final.vcd");
    $dumpvars(0, tb_final);
end

endmodule
