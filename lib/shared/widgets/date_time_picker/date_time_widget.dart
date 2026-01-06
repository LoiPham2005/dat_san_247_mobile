// import 'package:dat_san_247_mobile/core/styles/color_app.dart';
// import 'package:flutter/material.dart';

// class DateTimePicker extends StatelessWidget {
//   DateTimePicker({
//     super.key,
//     this.radius,
//     this.title,
//     this.onChoose,
//     this.initStartTime,
//     this.initEndTime,
//   });

//   final double? radius;
//   final String? title;
//   final DateTime? initStartTime;
//   final DateTime? initEndTime;
//   final Function(DateTime? startTime, DateTime? endTime)? onChoose;

//   final DateTimeBloc _bloc = DateTimeBloc();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         if (title != null) ...[
//           Text(
//             title!,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//         ],
//         BlocBuilder<DateTimeBloc, DateTime?>(
//           bloc: _bloc,
//           builder: (context, state) {
//             return Row(
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       _bloc.chooseDate(context, true);
//                     },
//                     child: Container(
//                       padding:
//                           const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(radius ?? 30),
//                         border: Border.all(
//                           color: ColorApp.gray90.withOpacity(0.3),
//                         ),
//                       ),
//                       child: Text(
//                         _bloc.startTime == null
//                             ? 'Chọn ngày bắt đầu'
//                             : '${_bloc.startTime!.day}/${_bloc.startTime!.month}/${_bloc.startTime!.year}',
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10), // Add this line (1/2)
//                 Expanded(
//                   child: InkWell(
//                     onTap: () async {
//                       await _bloc.chooseDate(context, false);

//                       if (onChoose != null) {
//                         onChoose!(_bloc.startTime, _bloc.endTime);
//                       }
//                     },
//                     child: Container(
//                       padding:
//                           const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(radius ?? 30),
//                         border: Border.all(
//                           color: Colors.gray.withOpacity(0.3),
//                         ),
//                       ),
//                       child: Text(
//                         _bloc.endTime == null
//                             ? 'Chọn ngày kết thúc'
//                             : '${_bloc.endTime!.day}/${_bloc.endTime!.month}/${_bloc.endTime!.year}',
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// class DateTimeBloc extends Cubit<DateTime?> {
//   DateTimeBloc() : super(null);
//   DateTime? startTime;
//   DateTime? endTime;

//    setStartTime(DateTime? time) {
//      if(time != null) {
//        startTime = DateTime(time.year, time.month, time.day, 0, 0, 0);
//      } else {
//        startTime = null;
//      }
//     emit(startTime);
//   }

//   setEndTime(DateTime? time) {
//     if (time != null) {
//       endTime = DateTime(time.year, time.month, time.day, 23, 59, 59);
//     } else {
//       endTime = null;
//     }
//     emit(endTime);
//   }

//   chooseDate(BuildContext context, bool isStart) async {
//     await showDatePicker(
//       context: context,
//       initialDate: isStart ? startTime ?? DateTime.now() : endTime,
//       firstDate:isStart ? DateTime(2000) : startTime ?? DateTime(2000),
//       lastDate: DateTime(2100),
//     ).then((value)async {
//       if (value != null)  {
//         if (isStart) {
//           if (endTime != null && value.isAfter(endTime!)) {
//             await setStartTime(value);
//             setEndTime(null);
//           } else {
//             setStartTime(value);
//           }
//         } else {
//           if (startTime != null && DateTime(value.year, value.month, value.day, 23, 59, 59).isBefore(startTime!)) {
//             setEndTime(null);
//           } else {
//             setEndTime(value);
//           }
//         }
//       } else {
//         if (isStart) {
//           setStartTime(null);
//         } else {
//           setEndTime(null);
//         }
//       }
//     });
//   }
// }
