import 'package:flutter/material.dart';
import 'signup_db.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/constants.dart';
import '../../widgets/font.dart';

// void main() {
//   runApp(MyApp());
// }

// 서버로 데이터 전송 함수
Future<bool> sendDataToServer(Map<String, dynamic> data) async {
  // IP 부분
  final String serverUrl = createUrl('users/signup'); // 서버연결

  try {
    final response = await http.post(
      Uri.parse(serverUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data), // 데이터를 JSON으로 변환
    );

    //디버깅
    print("서버 상태 코드: ${response.statusCode}");
    print("서버 응답 본문: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      // 상태 코드와 응답 본문을 통해 실패 원인 파악
      print("요청 실패: 상태 코드: ${response.statusCode}, 응답: ${response.body}");
      return false;
    }
  } catch (e) {
    print("네트워크 오류 발생: $e");
    return false;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpPage(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        canvasColor: Colors.white,
      )
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final ScrollController _scrollController = ScrollController();

  // 입력값
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String selectedGender = '여성'; // 초기값
  int selectedAge = 20; // 초기값

  // 스타일 변수 입력값
  final List<String> selectedStyles = []; // 선택 스타일 저장
  final List<String> styles = [
    '캐주얼', '스트릿', '미니멀', '걸리시',
    '워크웨어', '스포티', '클래식', '로맨틱',
    '시크', '시티보이', '고프코어', '레트로',
  ];

  // 스타일 선택 로직
  void toggleStyleSelection(String style) {
      setState(() {
        if (selectedStyles.contains(style)) {
          selectedStyles.remove(style); // 이미 선택된 스타일이면 제거
        } else {
          if (selectedStyles.length < 3) {
            selectedStyles.add(style); // 최대 3개까지 선택 가능
          }
        }
      });
    }


  // 입력 완료 버튼 클릭
  Future<bool> _submitData() async {
    // 1단계: 필드 입력 확인
    if (nameController.text.isEmpty ||
        idController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('모든 필드를 입력해주세요!'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    // 2단계: 비밀번호 확인
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('비밀번호가 일치하지 않습니다!'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    // 3단계: 스타일 선택 여부 확인
    if (selectedStyles.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('스타일을 3개 선택해주세요.'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    // 모든 조건 충족 -> 데이터 전송
    final data = {
      'name': nameController.text,
      'userId': idController.text,
      'password': passwordController.text,
      'gender': selectedGender,
      'age': selectedAge,
      'select3Styles': selectedStyles,
    };

    final isSuccess = await sendDataToServer(data);

    if (isSuccess) {
      // 서버 전송 성공 처리
      print("전송 데이터: $data");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('회원가입이 완료되었습니다!'),
          duration: Duration(seconds: 2),
        ),
      );
      return true;
    } else {
    // 서버 전송 실패 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('회원가입에 실패했습니다. 다시 시도해주세요.'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

  }


  // 스크롤 제어
  void _scrollToSecondPage() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, // 스크롤 끝으로 이동
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  // 스크롤을 위로 이동
  void _scrollToFirstPage() {
    _scrollController.animateTo(
      0.0, // 스크롤 시작 위치로 이동
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close), // X 버튼
          onPressed: () {
            Navigator.pop(context); // 홈으로 돌아가기
          },
        ),
        title: const Text(
          '회원가입',
          style: AppFonts.appBarStyle,
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // 첫 번째 화면 (회원 정보 입력)
            Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 30), // 양옆 마진
              child:
              Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50), // q1 위 패딩추가
                  const Text(
                    'Q1. 기본 정보를 입력해주세요.',
                    textAlign: TextAlign.center,
                    style: AppFonts.highlightStyle,
                  ),
                  const SizedBox(height: 20),

                  // 이름 입력 필드
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('이름'),
                  ),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: '이름을 입력하세요',
                      filled: true,
                      fillColor: const Color(0xFFF8F8F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 아이디 입력 필드
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('아이디 (닉네임)'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(
                      hintText: '아이디를 입력하세요',
                      filled: true,
                      fillColor: const Color(0xFFF8F8F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 비밀번호 입력 필드
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('비밀번호'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '비밀번호를 입력하세요',
                      filled: true,
                      fillColor: const Color(0xFFF8F8F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  //비밀번호 확인
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: '비밀번호 확인',
                      filled: true,
                      fillColor: const Color(0xFFF8F8F8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      )
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 성별과 나이
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('성별'),
                            const SizedBox(height: 8),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F8F8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedGender,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedGender = newValue!;
                                    });
                                  },
                                  items: ['여성', '남성']
                                      .map(
                                        (gender) => DropdownMenuItem(
                                      value: gender,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(gender),
                                      ),
                                    ),
                                  )
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),

                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('나이'),
                            const SizedBox(height: 8),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F8F8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  isExpanded: true,
                                  value: selectedAge,
                                  onChanged: (int? newValue) {
                                    setState(() {
                                      selectedAge = newValue!;
                                    });
                                  },
                                  items: List.generate(
                                    31,
                                        (index) => DropdownMenuItem(
                                      value: index + 10,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text('${index + 10}'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: _scrollToSecondPage,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFB8A39F),
                      fixedSize: const Size(180,55),
                    ),
                    child: const Text(
                      '입력 완료',
                      style: AppFonts.loginStyle,
                    ),
                  ),
                ],
              ),
            ),




/////////////////////////////////////////////////////////////////////////////////



// 두 번째 화면 (두번째 회원가입 페이지)
            Stack(
              children: [
                // 메인 컨테이너
                Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 스타일 3개 선택
                      const SizedBox(height: 20),
                      const Text(
                        'Q2. 좋아하는 스타일 3개를 선택해주세요.',
                        textAlign: TextAlign.center,
                        style: AppFonts.highlightStyle,
                      ),

                      SizedBox(height: 20),

                      // 스타일 리스트 (4x3 Grid)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GridView.builder(
                          shrinkWrap: true, // 스크롤뷰 안에서 작동하도록 설정
                          physics: const NeverScrollableScrollPhysics(), // GridView 자체 스크롤 비활성화
                          itemCount: styles.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // 한 줄에 3개
                            crossAxisSpacing: 10, // 가로 간격
                            mainAxisSpacing: 10, // 세로 간격
                            childAspectRatio: 2.0, // 가로 세로 비율 설정 (높을수록 세로가 작아짐)
                          ),
                          itemBuilder: (context, index) {
                            final style = styles[index];
                            final isSelected = selectedStyles.contains(style); // 선택 여부 확인
                            return GestureDetector(
                              onTap: () => toggleStyleSelection(style), // 클릭 시 선택/해제
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFB8A39F).withOpacity(0.4) // 선택된 스타일 색상
                                      : Colors.white, // 선택되지 않은 스타일 색상
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFB8A39F) : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  style,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      ElevatedButton(

                        // onPressed: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => SignupDBPage(),
                        //     ),
                        //   );
                        // },
                        onPressed: () async {

                          // DB시 아래 풀기

                          final isFormValid = await _submitData();
                          // 모든 조건이 충족될 경우에만 SignupDBPage로 이동
                          if (isFormValid) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupDBPage(userId: idController.text),
                              ),
                            );
                          }

                        },


                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFFB8A39F),
                          minimumSize: const Size(180, 55),
                        ),
                        child: const Text(
                          '입력 완료',
                          style: AppFonts.loginStyle,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 이건 서버 안열었을 때
                      ElevatedButton(
                        onPressed: () {
                          // Navigator를 사용하여 signup_db 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupDBPage(userId: idController.text)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFFB8A39F),
                          fixedSize: const Size(180, 55),
                        ),
                        child: const Text(
                          '서버x버튼',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),


                    ],
                  ),
                ),


                // 위로가기 버튼
                Positioned(
                  bottom: 60, // 화면 아래에서 20px
                  right: 30, // 화면 오른쪽에서 20px
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: _scrollToFirstPage,

                    backgroundColor: Colors.white,

                    child: const Icon(
                      Icons.arrow_upward,
                      color: const Color(0xFFB8A39F),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}