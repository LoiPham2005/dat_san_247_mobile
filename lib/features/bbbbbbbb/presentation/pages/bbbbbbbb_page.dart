import 'package:dat_san_247_mobile/core/state_management/bloc/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection.dart';
import '../bloc/bbbbbbbb_bloc.dart';
import '../bloc/bbbbbbbb_event.dart';

class BbbbbbbbPage extends StatelessWidget {
  const BbbbbbbbPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BbbbbbbbBloc>()..add(const LoadBbbbbbbbs()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bbbbbbbb'),
        ),
        body: BlocBuilder<BbbbbbbbBloc, BaseState>(
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
