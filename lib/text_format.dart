import 'package:flutter/services.dart';

class LowerCaseTxt extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
  TextEditingValue txtOld, TextEditingValue txtNew){
    return txtNew.copyWith(text: txtNew.text.toLowerCase());
  }
}