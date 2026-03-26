import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/auto_bloc/auto_bloc.dart';
import 'package:dat_san_247_mobile/core/base/state/bloc/base_state.dart';
import 'package:dat_san_247_mobile/features/example/category_rut_gon/presentation/cubit/category_cubit.dart';

class AutoBlocExamplePage extends StatelessWidget {
  const AutoBlocExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AutoBloc with .when()')),
      body: AutoBlocBuilder<CategoryRutGonCubit, BaseState>(
        builder: (context, cubit, state) {
          // 🚀 WOW: Cú pháp .when() giống hệt Riverpod/Freezed
          return state.when(
            initial: () =>
                const Center(child: Text('Hãy nhấn load để bắt đầu')),
            loading: (previousData) =>
                const Center(child: CircularProgressIndicator()),
            failure: (error, data) => Center(
              child: Text(
                'Lỗi: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            empty: (message) => Center(
              child: Text(
                message ?? 'Không có dữ liệu',
                style: const TextStyle(color: Colors.green),
              ),
            ),
            success: (data, message) => Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: (data as List).length,
                    itemBuilder: (context, index) =>
                        ListTile(title: Text(data[index].name)),
                  ),
                ),
                ElevatedButton(
                  // onPressed: () => context.categoryRutGonCubit.loadCategories(),
                  onPressed: () => cubit.loadCategories(),
                  child: const Text('Reload'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
