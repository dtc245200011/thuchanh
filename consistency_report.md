# Consistency Report - HealthSync

Bản báo cáo này chỉ ra ba điểm vênh nghiêm trọng giữa Activity Diagram "Đặt lịch và Khám bệnh" và thiết kế cơ sở dữ liệu cũ.

1. **Trạng thái vòng đời bị đơn giản hóa**: Bản cũ dùng cột boolean `is_active`, không thể biểu diễn các trạng thái PENDING → CONFIRMED → CHECKED_IN → COMPLETED/CANCELLED. Hậu quả: không thể kiểm soát luồng nghiệp vụ và dễ gây lỗi khi tính toán phạt hay phát hành đơn thuốc.

2. **Thiếu thông tin tài chính**: Không có cột `deposit_amount` và `penalty_fee`. Khi bệnh nhân hủy sau CONFIRMED, hệ thống không lưu được phí phạt để đối soát doanh thu, gây sai lệch báo cáo kế toán.

3. **Không có bảng Prescriptions và ràng buộc nghiệp vụ**: Thiếu bảng lưu đơn thuốc và không có cơ chế ngăn chặn việc tạo đơn thuốc cho lịch hẹn chưa hoàn tất. Điều này dẫn đến dữ liệu phi logic và lỗi khi truy xuất đơn thuốc cho các lịch chưa khám.

**Đề xuất khắc phục ngắn gọn**: thay `is_active` bằng cột `status` kiểu `ENUM`, thêm `deposit_amount`, `penalty_fee`, `cancel_reason`, tạo bảng `Prescriptions` và bổ sung trigger để ngăn insert đơn thuốc khi appointment chưa `COMPLETED`.
