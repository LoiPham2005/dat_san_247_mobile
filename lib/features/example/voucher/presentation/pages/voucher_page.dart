import 'package:dat_san_247_mobile/features/example/voucher/presentation/providers/voucher_provider_goc.dart';
import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/base/state/riverpod/riverpod_listeners.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/models/voucher_model.dart';

class VoucherPurePage extends HookConsumerWidget {
  const VoucherPurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(voucherProvider);
    final notifier = ref.read(voucherProvider.notifier);
    final isRefreshing = notifier.isRefreshing;
    final controller = useTextEditingController();

    useAsyncValueListener(provider: voucherProvider, ref: ref,);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher (Pure Notifier)'),
        actions: [
          if (isRefreshing)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(onPressed: notifier.refresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Mã voucher'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    notifier.applyVoucher(controller.text);
                    controller.clear();
                  },
                  child: const Text('Dùng'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Render danh sách
            Expanded(
              child: switch (state) {
                // 1. Trường hợp đang Loading nhưng đã có dữ liệu cũ (Refresh)
                AsyncValue(:final value?, isLoading: true) => Stack(
                  children: [
                    _buildList(value),
                    const LinearProgressIndicator(),
                  ],
                ),

                // 2. Trường hợp thành công nhưng danh sách rỗng
                AsyncData(value: final list) when list.isEmpty => const Center(
                  child: Text('Danh sách voucher trống'),
                ),

                // 3. Trường hợp thành công và có dữ liệu
                AsyncData(:final value) => _buildList(value),

                // 4. Trường hợp lỗi
                AsyncError(:final error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 12),
                      Text('Lỗi: $error'),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: notifier.refresh,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),

                // 5. Mặc định (Loading lần đầu - data là null)
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<VoucherModel> vouchers) {
    if (vouchers.isEmpty) return const Center(child: Text('Trống'));
    return ListView.builder(
      itemCount: vouchers.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          title: Text(vouchers[index].title),
          trailing: Text('${vouchers[index].discountAmount}k'),
        ),
      ),
    );
  }
}
