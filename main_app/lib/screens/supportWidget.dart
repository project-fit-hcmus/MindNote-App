import 'package:flutter/material.dart';

enum ThemeStyle {light, dark}
class HorizontalRadio extends StatelessWidget{
  final ThemeStyle value ;
  final ThemeStyle? groupValue;
  void Function(ThemeStyle?) onChanged;
  HorizontalRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
          value: value, 
          groupValue: groupValue, 
          onChanged: onChanged,
          activeColor: value == ThemeStyle.light ?Colors.green : Colors.blue,),
        Text(
          value == ThemeStyle.light ? 'Light' : 'Dark', 
        )
      ],
    );
  }
}