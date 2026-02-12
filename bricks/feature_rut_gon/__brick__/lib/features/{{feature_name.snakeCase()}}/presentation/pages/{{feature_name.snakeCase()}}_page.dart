import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import '../bloc/{{feature_name.snakeCase()}}_bloc.dart';
import '../bloc/{{feature_name.snakeCase()}}_event.dart';

class {{feature_name.pascalCase()}}Page extends StatelessWidget {
  const {{feature_name.pascalCase()}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<{{feature_name.pascalCase()}}Bloc>()..add(const Load{{feature_name.pascalCase()}}s()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('{{feature_name.pascalCase()}}'),
        ),
        body: BlocBuilder<{{feature_name.pascalCase()}}Bloc, BaseState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (data) {
                final items = data as List;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item.name.toString()),
                    );
                  },
                );
              },
              error: (message) => Center(child: Text(message)),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
