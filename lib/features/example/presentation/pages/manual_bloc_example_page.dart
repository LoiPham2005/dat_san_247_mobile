import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/features/example/category_rut_gon/presentation/cubit/category_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/di/injection.dart';
import '../../../../core/base/state/bloc/base_state.dart';

class ManualBlocExamplePage extends StatelessWidget {
  const ManualBlocExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ❌ PHẢI quấn BlocProvider thủ công ở đây hoặc ở Router
    return BlocProvider<CategoryRutGonCubit>(
      // ❌ PHẢI tự gọi getIt để khởi tạo
      create: (context) => getIt<CategoryRutGonCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Manual Bloc Example')),
        body: BlocBuilder<CategoryRutGonCubit, BaseState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (state.isLoading) const CircularProgressIndicator(),

                  Expanded(
                    child: Center(
                      child: Text('Dữ liệu: ${state.data ?? "Trống"}'),
                    ),
                  ),

                  // ❌ PHẢI dùng context.read hoặc BlocProvider.of rất dài
                  ElevatedButton(
                    onPressed: () {
                      context.read<CategoryRutGonCubit>().loadCategories();
                    },
                    child: const Text('Load Data (Manual)'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
