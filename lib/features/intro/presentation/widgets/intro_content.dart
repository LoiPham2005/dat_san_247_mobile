// intro_content.dart
import 'package:dat_san_247_mobile/features/intro/data/models/intro_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IntroContent extends StatelessWidget {
  final IntroModel data;

  const IntroContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SizedBox(height: 40),
          
          // Icon với animation
          TweenAnimationBuilder(
            duration: Duration(milliseconds: 1000),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: 0.5 + (value * 0.5),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: data.gradient),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: data.gradient[0].withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    data.icon,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          
          SizedBox(height: 50),
          
          // Subtitle
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: data.gradient[0].withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: data.gradient[0].withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              data.subtitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: data.gradient[0],
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          // Title
          Text(
            data.title,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xff2d5533),
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 24),
          
          // Description
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              data.description,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(height: 40),
          
          // Decorative elements
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeaturePoint("Miễn phí", Icons.money_off),
              _buildFeaturePoint("Nhanh chóng", Icons.flash_on),
              _buildFeaturePoint("Tin cậy", Icons.verified),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePoint(String text, IconData icon) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: data.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: data.gradient[0].withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: data.gradient[0],
            size: 24,
          ),
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}