import 'package:dat_san_247_mobile/core/utils/extensions/int_ext.dart';
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/styles/color_app.dart';
import 'package:dat_san_247_mobile/core/styles/image_path.dart';
import 'package:dat_san_247_mobile/core/widgets/custom_image.dart';

class ContentIntro extends StatelessWidget {
  final String image;
  final String title;
  final String content;
  const ContentIntro({
    super.key,
    required this.image,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Wrap với SingleChildScrollView
      child: Column(
        mainAxisSize: MainAxisSize.min, // Thêm thuộc tính này
        children: [
          Image.asset(
            image,
            width: 280,
            height: 200, // Thêm chiều cao cố định
            fit: BoxFit.contain, // Đảm bảo ảnh vừa với container
          ),
          SizedBox(height: 16), // Thêm khoảng cách
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          30.height,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              content,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
