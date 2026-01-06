import 'package:flutter/material.dart';
import 'package:dat_san_247_mobile/core/extensions/context_extensions.dart';

/// Base Page với các tính năng chung
abstract class BasePage extends StatefulWidget {
  const BasePage({super.key});
}

/// Base Page State
abstract class BasePageState<T extends BasePage> extends State<T>
    with AutomaticKeepAliveClientMixin {
  /// Override để giữ state khi navigate
  @override
  bool get wantKeepAlive => false;

  /// Page title cho AppBar
  String get pageTitle => '';

  /// Show AppBar
  bool get showAppBar => true;

  /// Show back button
  bool get showBackButton => true;

  /// AppBar actions
  List<Widget>? get appBarActions => null;

  /// Floating action button
  Widget? get floatingActionButton => null;

  /// Bottom navigation bar
  Widget? get bottomNavigationBar => null;

  /// Body padding
  EdgeInsets get bodyPadding => const EdgeInsets.all(16);

  /// Safe area
  bool get useSafeArea => true;

  /// Build body content
  Widget buildBody(BuildContext context);

  /// Build AppBar (có thể override)
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    if (!showAppBar) return null;

    return AppBar(
      title: Text(pageTitle),
      leading: showBackButton && Navigator.of(context).canPop()
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.navPop(),
            )
          : null,
      actions: appBarActions,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget body = buildBody(context);

    if (bodyPadding != EdgeInsets.zero) {
      body = Padding(padding: bodyPadding, child: body);
    }

    if (useSafeArea) {
      body = SafeArea(child: body);
    }

    return Scaffold(
      appBar: buildAppBar(context),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
