import 'package:flutter/material.dart';

mixin AppDecorations {
  static InputDecoration textFieldDecoration(BuildContext context,
      {double radius = 5}) {
    return InputDecoration(
      // fillColor: Theme.of(context).brightness == Brightness.dark
      //     ? Colors.grey.shade200
      //     : Colors.grey.shade200,
      // filled: true,
        counterText: '',
        isCollapsed: true,
        hintStyle: const TextStyle(
          color: Color(0xFFA5A5A5),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: Color(0xFFA5A5A5),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(
              color: Color(0xffCCCCCC),
              width: 1.2,
            )),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(
              color: Color(0xffCCCCCC),
              width: 1.2,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(
              color: Color(0xffCCCCCC),
              width: 1.2,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(
              color: Color(0xffCCCCCC),
              width: 1.2,
            )));
  }
}
