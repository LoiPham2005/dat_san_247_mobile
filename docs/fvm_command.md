Một số lệnh FVM hữu ích
Lệnh	Chức năng
fvm list	Liệt kê các Flutter version đã cài
fvm releases	Liệt kê tất cả version Flutter có thể cài
fvm remove 3.13.9	Xóa version Flutter không dùng
fvm flutter doctor	Chạy flutter doctor bằng FVM
fvm global 3.22.1	Đặt Flutter mặc định cho toàn máy




# Xem Flutter version hiện tại
fvm flutter --version

# Chạy app với FVM
fvm flutter run

# Chạy build_runner với FVM
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Update packages
fvm flutter pub get

# Clean project
fvm flutter clean

# List các version đã cài
fvm list

# Install version khác
fvm install 3.27.0

# Switch version
fvm use 3.27.0

# Remove version không dùng
fvm remove 3.24.5

# Xem version đang dùng global
fvm global