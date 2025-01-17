import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import 'dart:convert';

class SavePage extends StatefulWidget {
  final String userId;

  const SavePage({Key? key, required this.userId}) : super(key: key);

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  // 서버에서 가져온 데이터를 담을 리스트
  List<String> savedStyles = [];
  bool isLoading = true;

  // 서버 연결 실패 시 표시할 기본 이미지 URL 리스트
  final List<String> defaultSavedStyles = [
    'https://even-t.s3.ap-northeast-2.amazonaws.com/users/directdb_pic/isaac/snap_card_1306575169793834134.jpg',
    'https://even-t.s3.ap-northeast-2.amazonaws.com/users/directdb_pic/isaac/snap_card_1306492209030432561.jpg',
    'https://even-t.s3.ap-northeast-2.amazonaws.com/users/directdb_pic/isaac/snap_card_1306543109147551713.jpg',
    'https://even-t.s3.ap-northeast-2.amazonaws.com/users/directdb_pic/isaac/snap_card_1306571723373110942.jpg',
  ];

  @override
  void initState() {
    print("-------탭이동----------");
    super.initState();
    _fetchSavedStyles(widget.userId);
  }

  // 서버에서 데이터 가져오는 함수 - 저장한 코디
  Future<void> _fetchSavedStyles(String userId) async {
    try {
      final serverUrl = createUrl('pinecone/action/save/list?userId=$userId');
      print('저장 ServerUrl=$serverUrl');
      final response = await http.get(Uri.parse(serverUrl));
      print('저장 서버 - ${response.body}');

      if (response.statusCode == 200) {
        // 서버에서 받은 데이터 파싱
        final List<dynamic> data = json.decode(response.body);

        // // 'fulls3url' 추출
        // final List<String> urls = data.map((item) => item['fulls3url'].toString()).toList();
        // urls.add('https://even-t.s3.ap-northeast-2.amazonaws.com/users/directdb_pic/isaac/snap_card_1306575169793834134.jpg');

        // 데이터를 문자열 리스트로 변환
        final List<String> urls = data.cast<String>();

        // 중복 제거 (선택 사항)
        final uniqueUrls = urls.toSet().toList();

        print('save - 서버에서 받은 데이터 : $urls');
        setState(() {
          savedStyles = uniqueUrls;
          isLoading = false;
        });
      } else {
        // 에러 처리: 서버 응답 코드가 200이 아닐 경우
        throw Exception('Failed to load styles: ${response.statusCode}');
      }
    } catch (e) {
      print("저장: Error fetching data: $e");
      setState(() {
        // 서버 연결 실패 시 기본 이미지 리스트 할당
        savedStyles = defaultSavedStyles;
        isLoading = false;
      });
    }
  }

  // 서버에서 데이터 가져오는 함수 - 가능 코디
  Future<Map<String, List<String>>> fetchPossibleCoordi(String userId) async {
    try {
      final serverUrl = createUrl('compare/user/matched?userId=$userId');
      print('가능 코디 GET url: $serverUrl');
      final response = await http.get(Uri.parse(serverUrl));
      print("가능 코디 응답 : ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('가능 코디 서버에서 받은 데이터: $data');
        return data.map((key, value) => MapEntry(key, List<String>.from(value)));
      } else {
        throw Exception('Failed to load possible coordi data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching possible coordi data: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Colors.black, // 선택된 탭의 텍스트 색상
          unselectedLabelColor: Colors.grey, // 선택되지 않은 탭의 텍스트 색상
          indicator: BoxDecoration(
            color: Colors.transparent, // 탭 배경색 제거
            border: Border(
              bottom: BorderSide(
                color: Color(0xFF9C9291), // 선택된 탭 아래쪽 사각형 색상
                width: 5.0,
              ),
            ),
          ),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Color(0xFFC4B8B6); // 탭 클릭 시 배경색
              }
              return null; // 기본 상태에선 색상 없음
            },
          ),
          tabs: const [
            Tab(text: "저장한 스타일"),
            Tab(text: "가능한 코디"),
            Tab(text: "추천 아이템"),
          ],
        ),
        body: TabBarView(
          children: [
            _buildSavedStylesTab(),
            _buildPossibleCoordiTab(),
            _buildRecommendedTab(),
          ],
        ),
      ),
    );
  }

  // "저장한 스타일" 탭 UI
  Widget _buildSavedStylesTab() {
    print("--------저장한 스타일 탭--------");

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (savedStyles.isEmpty) {
      return const Center(child: Text("저장된 스타일이 없습니다."));
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        1.0, // 좌측마진
        1.0, // 상단마진
        1.0, // 우측마진
        125.0, // 하단마진
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 한 줄에 몇개 블럭 넣을건지
        crossAxisSpacing: 0.5,
        mainAxisSpacing: 0.5,
        childAspectRatio: 3 / 4, // 블럭 크기 비율
      ),
      itemCount: savedStyles.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0), // 모서리 radius 설정
            color: Colors.grey[200], // 배경색 (이미지 로딩 실패 시 표시)
          ),
          clipBehavior: Clip.hardEdge, // 둥근 모서리에 맞춰 클립
          child: Image.network(
            savedStyles[index],
            fit: BoxFit.cover, // 이미지를 블럭에 맞게 채우기
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.broken_image, size: 50), // 로딩 실패 시 아이콘 표시
              );
            },
          ),
        );
      },
    );
  }

  // "가능 코디" 탭 UI
  Widget _buildPossibleCoordiTab() {
    print("--------가능 코디 탭--------");
    return FutureBuilder<Map<String, List<String>>>(
      future: fetchPossibleCoordi(widget.userId), // 서버에서 데이터 가져오기
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 데이터를 성공적으로 가져온 경우
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final styleToClothes = snapshot.data!;
          final firstStyleImage = styleToClothes.keys.first; // 첫 번째 스타일 이미지
          final clothesImages = styleToClothes[firstStyleImage]!; // 관련된 옷 이미지 리스트

          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final leftImageHeight = constraints.maxWidth * 0.7; // 왼쪽 이미지 높이 설정

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 왼쪽 네트워크 이미지
                    Expanded(
                      flex: 7,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        height: leftImageHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13.0),
                          color: Colors.grey[200],
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(
                          firstStyleImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image, size: 50),
                            );
                          },
                        ),
                      ),
                    ),
                    // 오른쪽 로컬 이미지들
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: clothesImages.take(2).map((clothesLink) {
                          return Container(
                            height: leftImageHeight / 2 - 4, // 오른쪽 이미지 높이 설정
                            margin: const EdgeInsets.only(bottom: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.grey[200],
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Image.asset(
                              clothesLink,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.broken_image, size: 50),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }

        // 데이터가 없거나 에러가 발생한 경우
        return _buildDefaultPossibleCoordi();
      },
    );
  }

  Widget _buildDefaultPossibleCoordi() {
    print("buildDefault실행");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 첫 번째 큰 이미지 (왼쪽 이미지)
          Container(
            width: double.infinity, // 가로 전체 차지
            height: 300, // 고정된 높이
            margin: const EdgeInsets.only(bottom: 16.0), // 아래 여백
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.grey[200],
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              'https://even-t.s3.ap-northeast-2.amazonaws.com/users/directdb_pic/isaac/snap_card_1306575169793834134.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, size: 50),
                );
              },
            ),
          ),
          // 두 번째, 세 번째 이미지 (오른쪽 두 사진)
          Row(
            children: [
              // 첫 번째 작은 이미지
              Expanded(
                child: Container(
                  height: 150, // 고정된 높이
                  margin: const EdgeInsets.only(right: 8.0), // 오른쪽 여백
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.grey[200],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    'assets/images/green/long_sleeve.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 50),
                      );
                    },
                  ),
                ),
              ),
              // 두 번째 작은 이미지
              Expanded(
                child: Container(
                  height: 150, // 고정된 높이
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.grey[200],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    'assets/images/beige/long_pants.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 50),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // 스타일 블럭 UI
  Widget _buildStyleBlock(String styleLink, List<String> clothesLinks) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 스타일 이미지
          Container(
            width: 100, // 스타일 이미지 폭
            height: 133, // 3:4 비율
            margin: const EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[200],
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              styleLink,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, size: 50),
                );
              },
            ),
          ),
          // 옷 이미지 리스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: clothesLinks.take(3).map((clothesLink) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  width: double.infinity,
                  height: 66.5, // 스타일 이미지의 세로 크기 133의 절반
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[200],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    clothesLink,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 50),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  //"추천아이템" 탭 UI
  Widget _buildRecommendedTab() {
    return const Center(child: Text("추천코디 기능은 여기에 구현될 예정입니다."));
  }
}