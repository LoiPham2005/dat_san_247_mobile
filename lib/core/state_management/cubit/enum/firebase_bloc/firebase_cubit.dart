// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_base_template/core/enum/bloc_status.dart';
// import 'package:flutter_base_template/core/enum/cubit_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class FirebaseCubit extends Cubit<CubitState> {
//   FirebaseCubit() : super(CubitState());

//   String verificationId = "";
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   sendCode({
//     required String phone,
//     required BuildContext context,
//   }) async {
//     print(phone);
//     await _auth.verifyPhoneNumber(
//       phoneNumber: //kDebugMode
//          // ? "+84339604406"
//           "+84${phone.substring(1, phone.length)}",
//       timeout: const Duration(seconds: 60),
//       verificationCompleted: (credential) async {
//         // await _auth.signInWithCredential(credential);
//       },
//       verificationFailed: (authException) {
//         if (authException.code == 'invalid-phone-number') {
//           emit(
//             state.copyWith(
//               status: BlocStatus.failure,
//               msg:
//               "Số điện thoại $phone đã cung cấp không hợp lệ.",
//             ),
//           );
//         }
//         Api.checkError(authException, 'firebase auth');
//         emit(
//           state.copyWith(
//             status: BlocStatus.failure,
//             msg:
//                 "Chúng tôi đã chặn tất cả các yêu cầu từ số điện thoại $phone này do hoạt động bất thường. Thử lại sau.",
//           ),
//         );
//       },

//       codeSent: (String verifi, int? resendToken) async {
//         verificationId = verifi;
//       },
//       codeAutoRetrievalTimeout: (String verifiId) {
//         verificationId = verifiId;
//       },
//     );
//   }

//   checkCode({
//     required String code,
//     required BuildContext context,
//   }) async {
//     try {
//       emit(state.copyWith(
//         status: BlocStatus.loading,
//       ));
//       await FirebaseAuth.instance
//           .signInWithCredential(
//         PhoneAuthProvider.credential(
//           verificationId: verificationId,
//           smsCode: code,
//         ),
//       )
//           .then(
//         (val) {
//           if (val.user != null) {
//             emit(
//               state.copyWith(
//                 status: BlocStatus.authorized,
//                 msg: "Xác thực thành công",
//               ),
//             );
//           } else {
//             emit(
//               state.copyWith(
//                 status: BlocStatus.failure,
//                 msg: "Xác thực thất bại",
//               ),
//             );
//           }
//         },
//       );
//     } catch (e) {

//       emit(
//         state.copyWith(
//           status: BlocStatus.failure,
//           msg: "Xác thực thất bại",
//         ),
//       );
//     }
//   }

//   intiNotifi() async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//     FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//   }
// }
