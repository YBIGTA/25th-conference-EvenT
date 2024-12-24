import 'package:flutter/material.dart';

class AppFonts {
  // 상단바 폰트 스타일
  static const TextStyle appBarStyle = TextStyle(
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    fontSize: 18.0,
    color: Colors.black, // 필요에 따라 색상 지정
  );

  // 본문 폰트 스타일
  static const TextStyle bodyStyle = TextStyle(
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: Colors.black,
  );

  // 본문 강조 폰트 스타일
  static const TextStyle highlightStyle = TextStyle(
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
    color: Colors.black87, // 강조 색상
  );



  // 간접DB 폰트 스타일 (간접디비페이지에서사용)
  static const TextStyle signupDB = TextStyle(
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
    color: Colors.black,
  );

  // 간접DB 디테일페이지 폰트 스타일
  static const TextStyle detailsDB = TextStyle(
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Colors.black,
  );


  // 간접DB 디테일페이지 폰트 스타일 2
  static const TextStyle detailsDB2 = TextStyle(
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    fontSize: 14.0,
    color: Colors.black,
  );

  // 로그인 폰트
  static const TextStyle loginStyle = TextStyle(
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    fontSize: 17.0,
    color: Colors.white, // 강조 색상
  );

  // 회원가입 폰트
  static const TextStyle signupStyle = TextStyle(
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    fontSize: 17.0,
    color: Colors.black87, // 강조 색상
  );


}