# Consistency Report - HealthSync Database

## Kiểm tra cấu trúc
- **Patient**: có khóa chính PatientID, đầy đủ thông tin bệnh nhân.
- **Doctor**: có khóa chính DoctorID, lưu thông tin bác sĩ.
- **Appointment**: liên kết đúng với Patient và Doctor qua khóa ngoại.
- **MedicalRecord**: liên kết đúng với Patient và Doctor, có ngày ghi nhận.

## Ràng buộc
- Các bảng đều có PRIMARY KEY.
- Appointment và MedicalRecord có FOREIGN KEY đảm bảo tính toàn vẹn dữ liệu.
- Các cột NOT NULL được áp dụng cho trường bắt buộc.

## Kết luận
CSDL HealthSync đảm bảo tính nhất quán, có đầy đủ bảng và ràng buộc theo yêu cầu.
