import 'package:flutter/material.dart';

/// Mixin để quản lý form
mixin FormMixin<T extends StatefulWidget> on State<T> {
  final formKey = GlobalKey<FormState>();

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void resetForm() {
    formKey.currentState?.reset();
  }

  void saveForm() {
    formKey.currentState?.save();
  }
}
