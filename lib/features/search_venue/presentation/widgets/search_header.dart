import 'package:flutter/material.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff62b766), Color(0xff4fa553)],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.search, color: Colors.white, size: 20),
        ),
        SizedBox(width: 12),
        Text(
          "Tìm kiếm sân",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff2d5533),
          ),
        ),
      ],
    );
  }
}