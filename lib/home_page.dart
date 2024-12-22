import 'package:flutter/material.dart';
import 'first_screen//signup_page.dart'; // SignUpPage를 가져오기
import 'first_screen//login.dart';
import '../../widgets/font.dart';
import '../../widgets/button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  //버튼스타일 변수
  static const Size buttonSize = Size(230,53);
  static const buttonblank = SizedBox(height: 5);
  static final buttonradius = BorderRadius.circular(30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '안녕하세요!\n내 옷장 탐색기 EvenT 입니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 50), // 텍스트와 이미지 사이 간격
            Image.asset( // 이미지
              'assets/homepage_img.png',

            ),
            const SizedBox(height: 50), // 여백
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0), // 양옆 마진
              child: ElevatedButton(
                style: AppButtonStyles.loginButton(),// style
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: const Text(
                  '로그인',
                  style: AppFonts.loginStyle,
                ),
              ),
            ),
            buttonblank, // 여백
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0), // 양옆 마진
              child: OutlinedButton(
                style: AppButtonStyles.signupButton(),
                onPressed: () {
                  // 다른 페이지 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpPage(),
                    ),
                  );
                },
                child: const Text(
                    '회원가입',
                    style: AppFonts.signupStyle
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}