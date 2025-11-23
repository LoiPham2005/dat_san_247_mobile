// import 'package:flutter/material.dart';
//
// class ListSearchHistory extends StatelessWidget {
//   final Function(String keyword)? onSelect;
//   const ListSearchHistory({super.key, this.onSelect});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       separatorBuilder: (context, index) => Divider(),
//       itemCount: 5,
//       itemBuilder: (context, index) {
//         final keyword = 'Search History Item ${index + 1}';
//         return ListTile(
//           leading: Icon(Icons.history),
//           title: Text(keyword),
//           trailing: Icon(Icons.arrow_forward),
//           onTap: () {
//             if (onSelect != null) onSelect!(keyword);
//           },
//         );
//       },
//     );
//   }
// }
