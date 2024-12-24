import 'package:flutter/material.dart';

class AppButtonStyles {
  // 로그인 버튼 스타일 (ElevatedButton)
  static ButtonStyle loginButton({
    Size buttonSize = const Size(230, 53),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(30)),
    Color backgroundColor = const Color(0xFFB8A39F),
    Color pressedOverlayColor = const Color(0xFFC4B8B6), // 클릭 시 색상
  }) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(backgroundColor), // 기본 배경색
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return pressedOverlayColor; // 클릭 시 색상
          }
          return null; // 기본 상태에서는 아무 색상도 없음
        },
      ),
      minimumSize: MaterialStateProperty.all(buttonSize),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  // 회원가입 버튼 스타일 (OutlinedButton)
  static ButtonStyle signupButton({
    Size buttonSize = const Size(230, 53),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(30)),
    Color borderColor = const Color(0xFFB8A39F), // 보더 컬러
    Color pressedOverlayColor = const Color(0xFFEAE2E0), // 클릭 시 색상
  }) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.white), // 배경색 흰색
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return pressedOverlayColor; // 클릭 시 색상
          }
          return null; // 기본 상태에서는 아무 색상도 없음
        },
      ),
      side: MaterialStateProperty.all(
        BorderSide(
          color: borderColor, // 보더 색상
          width: 1.5, // 보더 두께
        ),
      ),
      minimumSize: MaterialStateProperty.all(buttonSize),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
    );
  }
  static ButtonStyle otherButton({
    Size buttonSize = const Size(180 , 55),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(30)),
    Color backgroundColor = const Color(0xFFB8A39F),
    Color pressedOverlayColor = const Color(0xFFC4B8B6), // 클릭 시 색상
  }) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(backgroundColor), // 기본 배경색
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return pressedOverlayColor; // 클릭 시 색상
          }
          return null; // 기본 상태에서는 아무 색상도 없음
        },
      ),
      minimumSize: MaterialStateProperty.all(buttonSize),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}