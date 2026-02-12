import 'package:flutter/material.dart';

class VenueFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ColorScheme colorScheme;

  const VenueFloatingButton({
    super.key,
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xff62b766), const Color(0xff4fa553)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        icon: const Icon(Icons.calendar_month, color: Colors.white, size: 28),
        label: const Text(
          "ĐẶT SÂN NGAY",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
