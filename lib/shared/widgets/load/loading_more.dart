// import 'package:flutter/material.dart';
// import 'load_page.dart';

// class LoadingMore extends StatelessWidget {
//   final CubitState state;
//   final bool isMore;
//   final Widget child;
//   final Function()? reLoad;
//   final String? message;
//   final  double? height;
//   final Widget? loadChild;

//   const LoadingMore({super.key,
//     required this.state,
//     this.isMore = false,
//     required this.child,
//     this.height = 200,
//     this.reLoad,
//     this.message,
//     this.loadChild,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (isMore) {
//       return child;
//     }
//     return LoadPage(
//       state: state,
//       child: child,
//       height: height,
//       message: message,
//       reLoad: reLoad,
//       loadChild: loadChild,
//     );
//   }
// }
