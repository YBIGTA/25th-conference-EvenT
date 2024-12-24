import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchSavedStyles(widget.userId);
  }

  // 서버에서 데이터 가져오는 함수 - 저장한 코디
  Future<void> _fetchSavedStyles(String userId) async {
    try {
      final serverUrl = createUrl('user/save/list?userId=$userId');
      print('ServerUrl=$serverUrl');
      final response = await http.get(Uri.parse(serverUrl));


      if (response.statusCode == 200) {
        // 서버에서 받은 데이터 파싱
        final List<dynamic> data = json.decode(response.body);
        // 중복 제거
        final uniqueUrls = data.toSet().toList();

        print('서버에서 받은 데이터 : $data');
        setState(() {
          savedStyles = uniqueUrls.map((e) => e.toString()).toList();
          isLoading = false;
        });
      } else {
        // 에러 처리
        throw Exception('Failed to load styles: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // 서버에서 데이터 가져오는 함수 - 가능 코디
  Future<Map<String, List<String>>> fetchPossibleCoordi(String userId) async {
    try {
      final serverUrl = createUrl('compare/user-clothes?userId=testUser123');
      print('가능 코디 GET url: $serverUrl');
      final response = await http.get(Uri.parse(serverUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('서버에서 받은 데이터: $data');
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
        crossAxisSpacing:0.5,
        mainAxisSpacing: 0.5,
        childAspectRatio: 3/4, // 블럭 크기 비율
      ),
      itemCount: savedStyles.length,
      itemBuilder: (context, index) {
        return Container(
          // margin: const EdgeInsets.symmetric(horizontal: 0), // 각 블럭 양옆에 마진 추가
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
          return const Center(child: CircularProgressIndicator()); // 로딩 중
        } else if (snapshot.hasError) {
          return const Center(child: Text("데이터를 가져오는 데 실패했습니다.")); // 에러 처리
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("가능 코디가 없습니다.")); // 데이터 없음
        }

        final styleToClothes = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: styleToClothes.length,
          itemBuilder: (context, index) {
            final styleLink = styleToClothes.keys.elementAt(index);
            final clothesLinks = styleToClothes[styleLink]!;
            return _buildStyleBlock(styleLink, clothesLinks);
          },
        );
      },
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
                  child: Image.network(
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