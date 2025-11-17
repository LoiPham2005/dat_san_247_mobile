import 'package:flutter/material.dart';

class BottomMenuPage extends StatelessWidget {
  const BottomMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Bottom Menu Page',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
