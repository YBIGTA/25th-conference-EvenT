import 'package:flutter/material.dart';
import 'signup_db.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../widgets/font.dart';

// 서버 URL
final String apiUrl = createUrl('simpledb/add');

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

  late String imagePath; // 동적으로 변경되는 이미지 경로

  @override
  void initState() {
    super.initState();
    final fileName = widget.imagePath.split('/').last;
    imagePath = 'assets/images/white/$fileName'; // 초기값 설정
  }

  void _updateImagePath(String color) {
    // 색상별 디렉토리를 추가한 이미지 경로 생성
    final colorDir = _mapColorToDirectoryName(color); // 색상 이름을 디렉토리로 사용
    final fileName = widget.imagePath.split('/').last; // 기존 경로에서 파일명만 추출
    setState(() {
      imagePath = 'assets/images/$colorDir/$fileName'; // 새로운 경로 생성
    });
  }

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
        // ▼ 높이를 고정하면 overflow 발생 위험이 있으므로, 스크롤 가능하도록 변경 (필요 시)
        //    필요 없다면 아래 SingleChildScrollView는 제거하셔도 됩니다.
        child: SingleChildScrollView(
          child: Container(
            // width는 유지, height 고정은 제거하는 것을 권장합니다.
            width: 347,
            // height: 420, // <- 제거 권장
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
                    const SizedBox(height: 23),
                    const Text(
                      '자세한 정보를 입력 후 추가해주세요!',
                      textAlign: TextAlign.center,
                      style: AppFonts.detailsDB,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(16),
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

                    // ▼ 색상 및 기장 선택 영역
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 색상 & 기장 버튼을 같은 행(Row)에 배치
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 색상 버튼
                              Row(
                                children: [
                                  const Text(
                                    '색상',
                                    style: AppFonts.detailsDB2,
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      // ▼ 클릭 시 BottomSheet가 팝업으로 뜨도록 변경
                                      showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                        builder: (context) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20, top: 20),
                                            child: Wrap(
                                              spacing: 5,
                                              runSpacing: 10,
                                              children: colorOptions.map((color) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedColor = color;
                                                      _updateImagePath(color);
                                                    });
                                                    Navigator.of(context).pop(); // 팝업 닫기
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets.only(bottom: 8),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                            color: _getColor(color),
                                                            shape: BoxShape.circle,
                                                            border: Border.all(
                                                              color: selectedColor == color
                                                                  ? Colors.blue
                                                                  : Colors.grey,
                                                              width: selectedColor == color ? 2 : 1,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 6),
                                                        Text(color),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      width: 70,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.grey, width: 1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(left: 7),
                                            width: 26,
                                            height: 26,
                                            decoration: BoxDecoration(
                                              color: _getColor(selectedColor),
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.grey, width: 0.5),
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
                                    children: ['크롭', '미디움', '롱']
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
                                          margin: const EdgeInsets.symmetric(horizontal: 3),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: selectedLength == length
                                                ? const Color(0xFFB8A39F)
                                                : Colors.grey[200],
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            length,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: selectedLength == length
                                                  ? Colors.white
                                                  : Colors.black,
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

                          const SizedBox(height: 15),

                          // 메모 입력
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: '메모를 입력하세요.',
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 20.0,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: const BorderSide(
                                    color: Colors.brown,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  customName = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ▼ 데이터 전송 버튼
                    ElevatedButton(
                      onPressed: () async {
                        final Map<String, dynamic> data = {
                          "userId": widget.userId,
                          "fulls3url": '',
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
                                        "print": "",
                                        "length": selectedLength.isEmpty
                                            ? "선택되지 않음"
                                            : selectedLength,
                                      },
                                      "s3Url": imagePath,
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
                            const SnackBar(content: Text("옷장에 옷이 성공적으로 추가되었어요 😚")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("데이터 전송에 실패했습니다. 다시 시도해주세요.")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB8A39F),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(14),
                        elevation: 5,
                        shadowColor: Colors.white70,
                      ),
                      child: const Icon(
                        Icons.add, // 플러스 아이콘
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Positioned(
                  top: 5,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              SignupDBPage(userId: widget.userId),
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
      ),
    );
  }

  String _mapColorToDirectoryName(String color) {
    switch (color) {
      case '민트':
        return 'mint';
      case '화이트':
        return 'white';
      case '베이지':
        return 'beige';
      case '카키':
        return 'khaki';
      case '그레이':
        return 'grey';
      case '실버':
        return 'silver';
      case '스카이블루':
        return 'skyblue';
      case '브라운':
        return 'brown';
      case '핑크':
        return 'pink';
      case '블랙':
        return 'black';
      case '그린':
        return 'green';
      case '오렌지':
        return 'orange';
      case '블루':
        return 'blue';
      case '네이비':
        return 'navy';
      case '레드':
        return 'red';
      case '와인':
        return 'wine';
      case '퍼플':
        return 'purple';
      case '옐로우':
        return 'yellow';
      case '라벤더':
        return 'lavender';
      case '골드':
        return 'gold';
      default:
        return 'unknown'; // 기본값
    }
  }

  Color _getColor(String color) {
    switch (color) {
      case '민트':
        return const Color(0xFF98FF98);
      case '화이트':
        return Colors.white;
      case '베이지':
        return const Color(0xFFF5F5DC);
      case '카키':
        return const Color(0xFFBDB76B);
      case '그레이':
        return Colors.grey;
      case '실버':
        return const Color(0xFFC0C0C0);
      case '스카이블루':
        return const Color(0xFF87CEEB);
      case '브라운':
        return const Color(0xFFA52A2A);
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
        return const Color(0xFF000080);
      case '레드':
        return Colors.red;
      case '와인':
        return const Color(0xFF722F37);
      case '퍼플':
        return Colors.purple;
      case '옐로우':
        return Colors.yellow;
      case '라벤더':
        return const Color(0xFFE6E6FA);
      case '골드':
        return const Color(0xFFFFD700);
      default:
        return Colors.white;
    }
  }
}