import 'package:flutter/widgets.dart';
import 'package:flutter_base_template/gen/l10n/app_localizations.dart';

extension LocalizationX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
