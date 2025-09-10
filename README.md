# dat_san_247_mobile


# câu lệnh đổi tên tự án 
Cách đổi tên package (bundleId) trong Flutter mới nhất
1. Đổi bundleId cho Android & iOS

Chạy lệnh:

dart run rename setBundleId --value com.example.notes_app

2. Đổi tên hiển thị ứng dụng (App Name)

Chạy thêm:

dart run rename setAppName --value "Notes App"

3. Kiểm tra bundleId sau khi đổi

Chạy lệnh:

dart run rename getBundleId


Nó sẽ hiển thị kết quả như:

Android: com.example.notes_app
iOS: com.example.notes_app

4. Dọn dẹp và chạy lại app

Sau khi đổi tên, bạn nên làm sạch dự án:

flutter clean
flutter pub get
flutter run


# sau đó cần đổi thủ công các file
Cách đổi tên package Flutter đúng chuẩn

Mình sẽ hướng dẫn bạn đổi từ
com.example.dat_san_247_mobile ➝ com.example.notes_app

Bước 1 — Đổi namespace trong android/app/build.gradle

Mở file:

android/app/build.gradle


Sửa:

android {
    namespace = "com.example.notes_app"

Bước 2 — Đổi package trong AndroidManifest.xml

Có 2 file AndroidManifest.xml cần sửa:

android/app/src/main/AndroidManifest.xml

android/app/src/debug/AndroidManifest.xml

Tìm dòng:

package="com.example.dat_san_247_mobile"


Sửa thành:

package="com.example.notes_app"

Bước 3 — Đổi tên thư mục Kotlin/Java

Đường dẫn cũ:

android/app/src/main/kotlin/com/example/dat_san_247_mobile/


Đổi thành:

android/app/src/main/kotlin/com/example/notes_app/


Tip:
Trong Android Studio → Nhấp chuột phải vào thư mục dat_san_247_mobile → Refactor → Rename → Nhập notes_app → Chọn Do Refactor.

Bước 4 — Sửa MainActivity.kt

Mở file:

android/app/src/main/kotlin/com/example/notes_app/MainActivity.kt


Đảm bảo phần đầu file:

package com.example.notes_app

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}

Bước 5 — Xóa cache & chạy lại

Chạy lệnh sau trong terminal:

flutter clean
flutter pub get
flutter run