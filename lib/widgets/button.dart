import 'package:flutter/material.dart';

class AppButtonStyles {
  // 로그인 버튼 스타일 (ElevatedButton)
  static ButtonStyle loginButton({
    Size buttonSize = const Size(230, 53),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(30)),
    Color backgroundColor = const Color(0xFFB8A39F),
  }) {
    return ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: backgroundColor,
      minimumSize: buttonSize,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
    );
  }

  // 회원가입 버튼 스타일 (OutlinedButton)
  static ButtonStyle signupButton({
    Size buttonSize = const Size(230, 53),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(30)),
    Color borderColor = const Color(0xFFB8A39F),
    double borderWidth = 1.5,
  }) {
    return OutlinedButton.styleFrom(
      side: BorderSide(color: borderColor, width: borderWidth),
      minimumSize: buttonSize,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
    );
  }
}