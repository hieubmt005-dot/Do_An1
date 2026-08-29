////////////////////////////////////////////////////////////////
// TESTBENCH KIỂM TRA CHỨC NĂNG KHỐI LÕI NTT_CORE
////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tb_NTT_core;

    // 1. INPUTS (Khai báo reg để cấp tín hiệu kích thích)
    reg        clk;
    reg        rst;
    reg        start;
    reg  [7:0] raddr_p_RAM0;
    reg  [7:0] raddr_p_RAM1;
    reg  [7:0] waddr_p_RAM0;

    // 2. OUTPUTS (Khai báo wire để hứng tín hiệu từ UUT)
    wire [7:0] raddr_RAM0;
    wire [7:0] raddr_RAM1;
    wire [7:0] waddr_RAM0;
    wire       pwm;
    wire       sub;
    wire       finish;
    wire [3:0] power_trace_out;

    ////////////////////////////////////////////////////////////
    // CONNECT TO DUT (Kết nối trực tiếp vào module NTT_core)
    ////////////////////////////////////////////////////////////
    NTT_core UUT_NTT (
        .clk(clk),
        .rst(rst),
        .start(start),
        
        .raddr_p_RAM0(raddr_p_RAM0),
        .raddr_p_RAM1(raddr_p_RAM1),
        .waddr_p_RAM0(waddr_p_RAM0),
        
        .raddr_RAM0(raddr_RAM0),
        .raddr_RAM1(raddr_RAM1),
        .waddr_RAM0(waddr_RAM0),
        
        .pwm(pwm),
        .sub(sub),
        .finish(finish),
        .power_trace_out(power_trace_out)
    );

    // 3. CLOCK GENERATION (Chu kỳ 10ns -> Freq = 100MHz)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // 4. FEEDBACK LOOP (Giả lập Address Controller đơn giản)
    // Để mạch không bị kẹt rác X khi đọc RAM, ta gán trực tiếp 
    // địa chỉ hoán vị bằng chính địa chỉ gốc mà NTT xuất ra.
    always @(*) begin
        raddr_p_RAM0 = raddr_RAM0;
        raddr_p_RAM1 = raddr_RAM1;
        waddr_p_RAM0 = waddr_RAM0;
    end

    // 5. STIMULUS PROCESS (Kịch bản mô phỏng)
    initial begin
        // --- Bước 1: Khởi tạo hệ thống ---
        rst   = 1'b1;
        start = 1'b0;
        #40;
        
        // Nhả reset (Lúc này mảng RAM0 và ROM nội bộ sẽ được nạp giá trị ban đầu)
        rst   = 1'b0;
        #20;
        
        // --- Bước 2: Nhấp xung START kích hoạt FSM ---
        @(posedge clk);
        start = 1'b1;
        #10;
        start = 1'b0; // Hạ start để mạch tự chạy tự động qua các trạng thái
        
        // --- Bước 3: Chạy mô phỏng trong khoảng thời gian đủ dài ---
        // Mỗi chu trình (Read -> Butterfly -> Write -> Next) mất 4 chu kỳ = 40ns.
        // Mạch chạy qua nhiều vòng lặp tăng tiến độ khoảng cách (distance).
        #2000;
        
        // Hoặc bạn có thể chờ cho đến khi tín hiệu finish kéo lên 1
        @(posedge finish);
        #50;
        
        $display("=== MÔ PHỎNG NTT_CORE HOÀN THÀNH BIÊN DỊCH ===");
        $finish;
    end

    // 6. MONITOR (Theo dõi FSM và vết năng lượng Power Trace trên Console)
    always @(posedge clk) begin
        if (!rst && (state_internal !== 3'd0)) begin
            $display("TIME = %0t | STATE = %d | Addr0 = %d | Addr1 = %d | Power Trace = %d | FINISH = %b", 
                     $time, state_internal, raddr_RAM0, raddr_RAM1, power_trace_out, finish);
        end
    end

    // Mẹo lấy trạng thái nội bộ "state" từ trong UUT ra để in debug
    wire [2:0] state_internal = UUT_NTT.state;

endmodule