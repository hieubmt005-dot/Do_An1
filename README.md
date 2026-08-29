# REPO DO AN 1
# Design and Implementation of a Memory Address Shuffling Mechanism for Enhancing Side-Channel Attack Resistance in FPGA-based NTT

[![Status](https://img.shields.io/badge/Status-Completed-success.svg)]()
[![Language](https://img.shields.io/badge/Language-Verilog%20HDL-blue.svg)]()
[![Tool](https://img.shields.io/badge/Tool-Xilinx%20Vivado-orange.svg)]()
[![Target](https://img.shields.io/badge/Target-FPGA-red.svg)]()

## 📖 Giới thiệu đề tài (Introduction)

Đồ án này nghiên cứu và hiện thực hóa cơ chế **Memory Address Shuffling** nhằm tăng cường khả năng chống lại các cuộc tấn công kênh kề (**Side-Channel Attack - SCA**) cho bộ biến đổi số học **Number Theoretic Transform (NTT)** – thành phần cốt lõi trong thuật toán mã hóa hậu lượng tử **CRYSTALS-Kyber** (ML-KEM) trên nền tảng **FPGA**.

Trong các kiến trúc NTT truyền thống, việc truy cập bộ nhớ diễn ra theo chuỗi tuần tự hoặc quy luật cố định, tạo ra các mẫu công suất tiêu thụ tương quan trực tiếp với dữ liệu bí mật. Đồ án áp dụng kỹ thuật xáo trộn địa chỉ ngẫu nhiên thông qua cấu trúc đường ống (pipeline) gồm khối **Random Permutation Generator (RPG)** và **Address Controller**, giúp phá vỡ quy luật truy cập bộ nhớ mà không làm thay đổi kết quả toán học của thuật toán.

---

## 🛠️ Kiến trúc hệ thống (System Architecture)

Hệ thống được thiết kế theo luồng xử lý phần cứng khép kín từ trái sang phải:

```text
[ start / reset ] 
       │
       ▼
┌─────────────────────────────┐       ┌──────────────────────┐       ┌─────────────────────┐
│ Random Permutation Generator│──────►│  Address Controller  │──────►│      NTT Core       │
│            (RPG)            │ idx   │  (Mapping & Shuffle) │ raddr │ (Butterfly / RAM)   │
└─────────────────────────────┘ prime └──────────────────────┘       └─────────────────────┘
                                                                                │
                                                                                ├──► finish
                                                                                └──► power_trace (Hamming Distance)
```

1. **Random Permutation Generator (RPG):** Sử dụng khối **LFSR** kết hợp bộ đệm và bộ nhớ **REG/FIFO** để sinh ra chuỗi chỉ số hoán vị giả ngẫu nhiên (`idx_prime`) dựa trên thuật toán Fisher-Yates cải tiến.
2. **Address Controller:** Tiếp nhận `idx_prime` cùng các tín hiệu điều khiển, thực hiện dịch trễ (`1D`, `12D`), nâng cấp không gian bit và băm trộn để tạo ra các bus địa chỉ an toàn (`raddr_p_ram0`, `raddr_p_ram1`, `waddr`).
3. **NTT Core:** Lõi xử lý thực thi máy trạng thái tuần hoàn 4 bước (**IDLE → READ → BUTTERFLY → WRITE → NEXT**), kết hợp mô hình vết năng lượng (`power_trace`) dựa trên **Khoảng cách Hamming (Hamming Distance)** giữa các chu kỳ đọc RAM liên tiếp.

---

## 📊 Kết quả mô phỏng & Đánh giá (Results & Evaluation)

### 1. Kiểm chứng chức năng (Simulation)
* **Behavioral Simulation:** Xác nhận khối RPG sinh chỉ số hoán vị chính xác, Address Controller ánh xạ địa chỉ RAM đúng chu kỳ trễ, và FSM của NTT Core thực hiện đầy đủ chu trình bướm (Butterfly).
* **Post-Synthesis Functional & Timing Simulation:** Kiểm chứng độ ổn định sau khi tổng hợp logic trên Vivado, ghi nhận độ trễ lan truyền qua các LUTs và khẳng định các ràng buộc thời gian (Timing Constraints) đều được đáp ứng hoàn toàn.
* **Power Trace Simulation:** Mô phỏng thành công mức tiêu thụ năng lượng sơ bộ qua số bit thay đổi (`Hamming Distance`) trên bus địa chỉ đọc, phục vụ cho việc đánh giá khả năng giảm tương quan thông tin kênh kề.

### 2. Thống kê tài nguyên phần cứng (Resource Utilization)
Được tổng hợp trên Xilinx FPGA cho thấy mức chi phí phần cứng thấp, tối ưu cho việc tích hợp bộ chống SCA:
* **Slice LUTs:** 453
* **Slice Registers:** 877
* **F7 Muxes:** 91
* **F8 Muxes:** 43
* **Max Frequency ($F_{max}$):** ~148.1 MHz ($WNS = 3.248	ext{ ns}$)

---

## 🚀 Hướng phát triển tương lai (Future Works)
* **Tối ưu hóa tài nguyên:** Chia sẻ tài nguyên (`Resource Sharing`) cho các khối logic trong Address Controller nhằm giảm diện tích chip.
* **Mở rộng mô hình rò rỉ:** Tích hợp tính toán khoảng cách Hamming trên cả **Data Bus** và trạng thái bên trong của **ALU**.
* **Bảo vệ toàn diện:** Kết hợp kỹ thuật xáo trộn (`Shuffling`) với che giấu dữ liệu (`Masking`) để chống lại các cuộc tấn công kênh kề bậc cao (**Higher-Order SCA**).
* **Triển khai thực tế:** Nạp và kiểm chứng phần cứng trên bo mạch FPGA thực tế (Artix-7 / Zynq).

---

## 👥 Thông tin tác giả (Author)
* **Sinh viên thực hiện:** Nguyễn Thanh Hiếu
* **Giảng viên hướng dẫn:** ThS. Trường Văn Cương
* **Đơn vị:** Khoa Kỹ thuật Máy tính, Trường Đại học Công nghệ Thông tin, ĐHQG-HCM (UIT).
