# AI Prompt Log - HealthSync

## Prompt 1
"Trong thiết kế cơ sở dữ liệu, tại sao dùng một cột is_active (BOOLEAN) để theo dõi vòng đời của một lịch hẹn là anti-pattern? Thay thế bằng gì?"
### Tóm tắt phản hồi AI
Boolean không biểu diễn nhiều trạng thái; nên dùng ENUM hoặc bảng trạng thái riêng để lưu lịch sử trạng thái.

## Prompt 2
"Khi lưu deposit_amount và penalty_fee, nên dùng FLOAT, DOUBLE hay DECIMAL? Tại sao?"
### Tóm tắt phản hồi AI
Dùng DECIMAL để tránh lỗi làm tròn và đảm bảo chính xác cho tính toán tài chính.

## Prompt 3
"Làm sao thêm cột status ENUM vào bảng có sẵn mà không mất dữ liệu? (ALTER TABLE syntax)"
### Tóm tắt phản hồi AI
Cung cấp cú pháp `ALTER TABLE Appointments ADD COLUMN status ENUM(...) DEFAULT 'PENDING';` và lưu ý backup trước khi thay đổi.

## Prompt 4
"Làm thế nào để ngăn chặn insert Prescriptions cho appointment chưa COMPLETED ở tầng DB?"
### Tóm tắt phản hồi AI
Sử dụng trigger BEFORE INSERT trên Prescriptions để kiểm tra trạng thái appointment và SIGNAL lỗi nếu không phải COMPLETED.
