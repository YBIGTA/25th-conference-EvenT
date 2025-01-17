import 'package:event_flutter/config/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ClosetPage extends StatefulWidget {
  final String userId;
  const ClosetPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ClosetPage> createState() => _ClosetPageState();
}

class _ClosetPageState extends State<ClosetPage> {
  late Future<List<String>> _closetItemsFuture;

  @override
  void initState() {
    super.initState();
    // userId를 사용해 서버에서 사진 경로 데이터 받아오기
    _closetItemsFuture = fetchClosetData(widget.userId);
  }

  /// 서버에서 사진 로컬 경로 리스트를 가져오는 메서드
  Future<List<String>> fetchClosetData(String userId) async {
    // 서버 Url
    final serverUrl = createUrl('simpledb/get?userId=$userId');
    print('서버 url : $serverUrl');

    try {
      final response = await http.get(Uri.parse(serverUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print("서버에서 받은 데이터: $jsonData");

        // 응답이 리스트 형태의 로컬 경로로 구성된 경우 처리
        return jsonData.cast<String>();
      } else {
        print('에러 : ${response.statusCode}');
        throw Exception('데이터를 불러오지 못했습니다. 상태코드: ${response.statusCode}');
      }
    } catch (e) {
      print("서버 요청 실패 : $e");
      // 로컬 데이터 반환
      return _getLocalClosetItems();
    }
  }

  /// 로컬 데이터 정의
  List<String> _getLocalClosetItems() {
    return [
      'assets/images/green/long_sleeve.png',
      'assets/images/beige/long_pants.png',
      'assets/images/brown/padded_jk.png',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), // 양옆 마진 추가
        child: FutureBuilder<List<String>>(
          future: _closetItemsFuture,
          builder: (context, snapshot) {
            // 로딩 중
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // 에러
            else if (snapshot.hasError) {
              return Center(child: Text('에러 발생: ${snapshot.error}'));
            }
            // 데이터 없음
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('옷장에 옷이 없습니다.'));
            }

            // 서버에서 받은 사진 경로 리스트를 표시
            final items = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // 상하 간격 유지
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,    // 한 줄에 3개
                mainAxisSpacing: 8,   // 위아래 간격
                crossAxisSpacing: 8,  // 좌우 간격
                childAspectRatio: 1,  // 정사각형
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0), // 블록에 Radius 적용
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0), // 이미지에 Radius 적용
                    child: Image.asset(
                      item,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50, color: Colors.red);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}