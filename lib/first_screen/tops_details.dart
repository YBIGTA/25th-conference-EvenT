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
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data), // 데이터를 JSON으로 변환하여 요청 본문에 포함
    );

    print("서버 상태 코드: ${response.statusCode}");
    print("서버 응답 본문: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print("요청 실패: 상태 코드: ${response.statusCode}, 응답: ${response.body}");
      return false;
    }
  } catch (e) {
    print("네트워크 오류 발생: $e");
    return false;
  }
}

class TopsDetailPage extends StatefulWidget {
  final String label; // 블록 이름
  final String imagePath; // 블록 이미지
  final String userId;

  const TopsDetailPage({
    Key? key,
    required this.label,
    required this.imagePath,
    required this.userId,
  }) : super(key: key);

  @override
  _TopsDetailPageState createState() => _TopsDetailPageState();
}

class _TopsDetailPageState extends State<TopsDetailPage> {
  String selectedColor = '화이트'; // 기본 선택 색상
  String selectedLength = ''; // 기본값은 선택하지 않은 상태
  String customName = '';
  bool showColorOptions = false; // 색상 선택 토글 상태

  // 색상 리스트
  final List<String> colorOptions = [
    '민트', '화이트', '베이지', '카키', '그레이', '실버', '스카이블루',
    '브라운', '핑크', '블랙', '그린', '오렌지', '블루', '네이비',
    '레드', '와인', '퍼플', '옐로우', '라벤더', '골드',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 347,
          height: 450,
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
              Column(
                children: [
                  const SizedBox(height: 20),
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
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.imagePath),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // 지우기
                        // 색상 및 기장 버튼을 같은 행(Row)에 배치
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 색상 버튼
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
                            // 기장 버튼
                            Row(
                              children: [
                                const Text(
                                  '기장',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Row(
                                  children: ['롱', '숏', '미디움']
                                      .map(
                                        (length) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // 이미 선택된 기장을 다시 클릭하면 취소
                                          if (selectedLength == length) {
                                            selectedLength = ''; // 선택 취소
                                          } else {
                                            selectedLength = length; // 새로운 기장 선택
                                          }
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: selectedLength == length ? Colors.blue : Colors.grey[200],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          length,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: selectedLength == length ? Colors.white : Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                      .toList(),
                                ),
                              ],
                            ),
                          ],
                        ),



                        // 색상 옵션 표시
                        if (showColorOptions)
                          Column(
                            children: colorOptions
                                .map(
                                  (color) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedColor = color;
                                    showColorOptions = false;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  width: double.infinity,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _getColor(color),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: selectedColor == color ? Colors.blue : Colors.grey,
                                      width: selectedColor == color ? 2 : 1,
                                    ),
                                  ),
                                ),
                              ),
                            )
                                .toList(),
                          ),
                        const SizedBox(height: 20),

                        //메모
                        // const Text(
                        //   '메모',
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                        const SizedBox(height: 5),
                        TextField(
                          decoration: InputDecoration(
                            hintText: '메모를 입력하세요.',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40), // 보더
                              borderSide: BorderSide(
                                color: Colors.brown, // 포커스 상태의 테두리 색상
                                width: 1.5, // 포커스 상태에서 두꺼운 테두리
                              )
                            )
                          ),
                          onChanged: (value) {
                            setState(() {
                              customName = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ElevatedButton(
                      onPressed: () async {
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
                                      "customName": customName,
                                      "attributes": {
                                        "color": selectedColor,
                                        "length": selectedLength.isEmpty
                                            ? "선택되지 않음"
                                            : selectedLength,
                                      },
                                      "s3Url": widget.imagePath,
                                      "quantity": 1,
                                      "state": 1,
                                    }
                                  ],
                                }
                              ],
                            }
                          ],
                        };

                        print("전송할 데이터: ${json.encode(data)}");

                        final bool success = await sendDataToServer(data, apiUrl);

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("옷장이 성공적으로 업데이트되었습니다!")),
                          );
                        } else {
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
                  ),
                  const SizedBox(height: 8),
                ],
              ),
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
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
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

  Color _getColor(String color) {
    switch (color) {
      case '민트':
        return Color(0xFF98FF98);
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
      default:
        return Colors.white;
    }
  }
}