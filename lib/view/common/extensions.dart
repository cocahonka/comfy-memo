import 'package:flutter/widgets.dart';

extension TextEditingControllerExtension on TextEditingController {
  String get trimmedText => text.trim();
}
