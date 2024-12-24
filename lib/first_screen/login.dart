import 'package:event_flutter/home_page.dart';
import 'package:event_flutter/widgets/button.dart';
import 'package:event_flutter/widgets/font.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../main.dart';
import '../../config/constants.dart';
import '../../home_screen/style_page.dart';

import '../../widgets/layout.dart';
import '../../widgets/font.dart';

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}


// 서버로 로그인 요청
Future<bool> login(String userId, String password) async {
  final String serverUrl = createUrl('users/login'); // 서버 URL 변경 필요
  print(serverUrl);

  // 요청 데이터
  final requestBody = {
    'userId': userId,
    'password': password,
  };
  print('Request Body: $requestBody'); // 요청 데이터 디버깅 출력

  try {
    final response = await http.post(
      Uri.parse(serverUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      // 로그인 성공
      print("로그인 성공: ${response.body}");
      return true;
    } else {
      // 로그인 실패
      print("로그인 실패: 상태 코드: ${response.statusCode}, 응답: ${response.body}");
      return false;
    }
  } catch (e) {
    // 네트워크 또는 기타 오류
    print("네트워크 오류: $e");
    return false;
  }
}
class LoginPage extends StatelessWidget {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
            '로그인',
            style: AppFonts.loginStyle,
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0), // 양옆 마진
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // 위쪽으로 정렬
            children: [
              // 상단 마진
              const SizedBox(height: 100),

              // 내용
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome back! \nGlad to see you again :)",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              SizedBox(height: 30),

              // 아이디 필드
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('아이디'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  hintText: '아이디를 입력하세요.',
                  // filled: true,
                  // fillColor: const Color(0xFFF8F8F8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.brown, // 포커스 상태의 테두리 색상
                      width: 1.5, // 포커스 상태에서 두꺼운 테두리
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15), // 간격

              const Align(
                alignment: Alignment.centerLeft,
                child: Text('비밀번호'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호를 입력하세요.',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.brown, // 포커스 상태의 테두리 색상
                      width: 1.5, // 포커스 상태에서 두꺼운 테두리
                    ),
                  ),
                ),
              ),




              SizedBox(height: 24.0), // 간격
              // 로그인 버튼
              ElevatedButton(
                onPressed: () async {
                  // 입력값 가져오기
                  final userId = idController.text;
                  final password = passwordController.text;

                  //디버깅 출력
                  print('Input UserId: $userId');
                  print('Input Password: $password');

                  // 서버로 로그인 요청
                  final success = await login(userId, password);



                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('로그인 성공!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    // 로그인 성공 후 페이지 이동 (예: 홈 화면)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommonLayout(userId: userId), // 이동할 페이지 지정
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('로그인 실패. 아이디와 비밀번호를 확인하세요.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: AppButtonStyles.loginButton(),
                child: const Text(
                  '로그인',
                  style: AppFonts.loginStyle,
                ),
              ),
              const SizedBox(height: 10.0),
              // // 서버 안열었을 때
              // ElevatedButton(
              //   onPressed: () {
              //     // Navigator를 사용하여 signup_db 페이지로 이동
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => CommonLayout(userId:'noID')),
              //     );
              //   },
              //   style: ElevatedButton.styleFrom(
              //     elevation: 0,
              //     backgroundColor: const Color(0xFFB8A39F),
              //     fixedSize: const Size(180, 55),
              //   ),
              //   child: const Text(
              //     '서버X버튼',
              //     style: TextStyle(
              //       fontSize: 15,
              //       color: Colors.white,
              //       fontWeight: FontWeight.w900,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
