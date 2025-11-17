import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/localization_x.dart';
import 'package:flutter_base_template/core/extensions/number_extensions.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Column(
        children: [
          Center(child: Text(context.l10n.appTitle)),
          10.height,
        //  Assets.icons.placeholder2.svg(),
          ElevatedButton(
            onPressed: () {
              context.push('/page2');
            },
            child: const Text('chuyển màn '),
          ),
        ],
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
