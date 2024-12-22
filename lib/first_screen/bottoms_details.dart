import 'package:flutter/material.dart';
import 'signup_db.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';


// 서버 URL
final String apiUrl = createUrl('users/login');

// 서버로 데이터 전송 함수
Future<bool> sendDataToServer(Map<String, dynamic> data, String apiUrl) async {
  try {
    // POST 요청 보내기
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data), // 데이터를 JSON으로 변환하여 요청 본문에 포함
    );

    // 디버깅용 로그 출력
    print("서버 상태 코드: ${response.statusCode}");
    print("서버 응답 본문: ${response.body}");

    // 응답 상태 코드 확인
    if (response.statusCode == 200 || response.statusCode == 201) {
      // 요청 성공
      return true;
    } else {
      // 요청 실패 시 상태 코드와 응답 내용 출력
      print("요청 실패: 상태 코드: ${response.statusCode}, 응답: ${response.body}");
      return false;
    }
  } catch (e) {
    // 네트워크 오류 또는 기타 예외 처리
    print("네트워크 오류 발생: $e");
    return false;
  }
}


class BottomsDetailPage extends StatefulWidget {
  final String label; // 블록 이름
  final String imagePath; // 블록 이미지
  final String userId;

  const BottomsDetailPage({
    Key? key,
    required this.label,
    required this.imagePath,
    required this.userId,
  }) : super(key: key);

  @override
  _BottomsDetailPageState createState() => _BottomsDetailPageState();
}

class _BottomsDetailPageState extends State<BottomsDetailPage> {
  String selectedColor = '하양'; // 기본 선택 색상
  bool hasPrinting = false; // 프린팅 있음 상태
  bool showColorOptions = false; // 색상 선택 토글 상태

  // 색상 리스트
  final List<String> colorOptions = [
    '민트', '화이트', '베이지', '카키', '그레이', '실버', '스카이블루',
    '브라운', '핑크', '블랙', '그린', '오렌지', '블루', '네이비',
    '레드', '와인', '퍼플', '옐로우', '라벤더', '골드', //'네온',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 347,
          height: 500,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 22,
                offset: Offset(0, 5),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Stack(
            children: [
              // 내용
              Column(
                children: [
                  const SizedBox(height: 20),
                  // 안내 텍스트
                  const Text(
                    '자세한 정보를 입력한 뒤 옷장에 추가해주세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.30,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 이미지
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.imagePath), // 전달된 이미지
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 라벨
                  Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 색상 및 프린팅 옵션
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            // 색상 텍스트 및 토글 버튼
                            Row(
                              children: [
                                const Text(
                                  '색상',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showColorOptions = !showColorOptions;
                                    });
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.grey, width: 1),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(left: 5),
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: _getColor(selectedColor),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // 프린팅 텍스트 및 있음/없음 버튼
                            Row(
                              children: [
                                const Text(
                                  '프린팅',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          hasPrinting = true;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: hasPrinting ? Colors.blue : Colors.grey[200],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '있음',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: hasPrinting ? Colors.white : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          hasPrinting = false;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: !hasPrinting ? Colors.blue : Colors.grey[200],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '없음',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: !hasPrinting ? Colors.white : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // 색상 선택 옵션
                        if (showColorOptions)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: colorOptions
                                  .map((color) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedColor = color;
                                    showColorOptions = false;
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _getColor(color),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selectedColor == color ? Colors.blue : Colors.grey,
                                      width: selectedColor == color ? 2 : 1,
                                    ),
                                  ),
                                ),
                              ))
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // 추가하기 버튼
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // 전송할 데이터 구성
                        final Map<String, dynamic> data = {
                          "userId": widget.userId,
                          "categories": [
                            {
                              "categoryName": "상의",
                              "subcategories": [
                                {
                                  "name": widget.label,
                                  "items": [
                                    {
                                      "customName": "", // 사용자 정의 이름이 필요하면 여기에 추가
                                      "attributes": {
                                        "color": selectedColor,
                                        "print": "",
                                        "length": "" // 길이 추가 필요 시 값 입력
                                      },
                                      "s3Url": widget.imagePath,
                                      "quantity": 1,
                                      "state" : 1
                                    }
                                  ]
                                }
                              ]
                            }
                          ]
                        };

                        // 프린트
                        print("전송할 데이터: ${json.encode(data)}");

                        // 데이터 전송
                        final bool success = await sendDataToServer(data, apiUrl);

                        // 결과 처리
                        if (success) {
                          // 성공 메시지 표시
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("옷장이 성공적으로 업데이트되었습니다!")),
                          );
                          // 성공 시 다른 페이지로 이동하거나 다른 작업 수행 가능
                        } else {
                          // 실패 메시지 표시
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("데이터 전송에 실패했습니다. 다시 시도해주세요.")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB8A39F),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        '추가하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // 네모 박스 내부의 X 버튼
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => SignupDBPage(userId: widget.userId),
                        transitionDuration: Duration.zero, // 모션 제거
                        reverseTransitionDuration: Duration.zero, // 모션 제거
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 색상 이름에 따른 색상 반환
  Color _getColor(String color) {
    switch (color) {
      case '민트':
        return Color(0xFF98FF98); // 민트
      case '화이트':
        return Colors.white;
      case '베이지':
        return Color(0xFFF5F5DC);
      case '카키':
        return Color(0xFFBDB76B);
      case '그레이':
        return Colors.grey;
      case '실버':
        return Color(0xFFC0C0C0);
      case '스카이블루':
        return Color(0xFF87CEEB);
      case '브라운':
        return Color(0xFFA52A2A);
      case '핑크':
        return Colors.pink;
      case '블랙':
        return Colors.black;
      case '그린':
        return Colors.green;
      case '오렌지':
        return Colors.orange;
      case '블루':
        return Colors.blue;
      case '네이비':
        return Color(0xFF000080);
      case '레드':
        return Colors.red;
      case '와인':
        return Color(0xFF722F37);
      case '퍼플':
        return Colors.purple;
      case '옐로우':
        return Colors.yellow;
      case '라벤더':
        return Color(0xFFE6E6FA);
      case '골드':
        return Color(0xFFFFD700);
    // case '네온':
    //   return Color(0xFF39FF14);
      default:
        return Colors.white;
    }
  }
}