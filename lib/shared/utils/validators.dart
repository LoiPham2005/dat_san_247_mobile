// /// Validators cho form fields
// class Validators {
//   Validators._();

//   /// Email validator
//   static String? email(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Email không được để trống';
//     }
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) {
//       return 'Email không hợp lệ';
//     }
//     return null;
//   }

//   /// Password validator
//   static String? password(String? value, {int minLength = 6}) {
//     if (value == null || value.isEmpty) {
//       return 'Mật khẩu không được để trống';
//     }
//     if (value.length < minLength) {
//       return 'Mật khẩu phải có ít nhất $minLength ký tự';
//     }
//     return null;
//   }

//   /// Confirm password validator
//   static String? Function(String?) confirmPassword(String password) {
//     return (String? value) {
//       if (value == null || value.isEmpty) {
//         return 'Vui lòng xác nhận mật khẩu';
//       }
//       if (value != password) {
//         return 'Mật khẩu không khớp';
//       }
//       return null;
//     };
//   }

//   /// Required validator
//   static String? required(String? value, {String? fieldName}) {
//     if (value == null || value.trim().isEmpty) {
//       return '${fieldName ?? 'Trường này'} không được để trống';
//     }
//     return null;
//   }

//   /// Phone validator (Vietnam)
//   static String? phone(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Số điện thoại không được để trống';
//     }
//     final phoneRegex = RegExp(r'^(0|\+84)[3-9][0-9]{8}$');
//     if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
//       return 'Số điện thoại không hợp lệ';
//     }
//     return null;
//   }

//   /// Min length validator
//   static String? Function(String?) minLength(int length, {String? fieldName}) {
//     return (String? value) {
//       if (value == null || value.length < length) {
//         return '${fieldName ?? 'Trường này'} phải có ít nhất $length ký tự';
//       }
//       return null;
//     };
//   }

//   /// Max length validator
//   static String? Function(String?) maxLength(int length, {String? fieldName}) {
//     return (String? value) {
//       if (value != null && value.length > length) {
//         return '${fieldName ?? 'Trường này'} không được quá $length ký tự';
//       }
//       return null;
//     };
//   }

//   /// Number validator
//   static String? number(String? value, {String? fieldName}) {
//     if (value == null || value.isEmpty) {
//       return '${fieldName ?? 'Trường này'} không được để trống';
//     }
//     if (double.tryParse(value) == null) {
//       return '${fieldName ?? 'Trường này'} phải là số';
//     }
//     return null;
//   }

//   /// Combine multiple validators
//   static String? Function(String?) combine(
//     List<String? Function(String?)> validators,
//   ) {
//     return (String? value) {
//       for (final validator in validators) {
//         final result = validator(value);
//         if (result != null) return result;
//       }
//       return null;
//     };
//   }
// }
