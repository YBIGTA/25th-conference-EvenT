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
  late Future<List<ClosetItem>> _closetItemsFuture;

  @override
  void initState() {
    super.initState();
    // userId를 사용해 서버에서 옷 데이터 받아오기
    _closetItemsFuture = fetchClosetData(widget.userId);
  }

  /// 서버에서 ClosetItem 리스트를 가져오는 예시 메서드
  Future<List<ClosetItem>> fetchClosetData(String userId) async {
    // 서버 Url
    final Serverurl = createUrl('simpledb/get?userId=$userId');
    print('서버 url : $Serverurl');
    final response = await http.get(Uri.parse(Serverurl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<ClosetItem> result = [];

      // 응답 구조에 맞춰 파싱
      if (jsonData['categories'] != null) {
        for (var cat in jsonData['categories']) {
          final catName = cat['categoryName'] ?? '';
          if (cat['subcategories'] != null) {
            for (var sub in cat['subcategories']) {
              final subName = sub['name'] ?? '';
              if (sub['items'] != null) {
                for (var itm in sub['items']) {
                  result.add(
                    ClosetItem(
                      categoryName: catName,
                      subcategoryName: subName,
                      s3Url: itm['s3Url'] ?? '',
                      customName: itm['customName'] ?? '',
                      color: itm['attributes']?['color'] ?? '',
                      printType: itm['attributes']?['print'] ?? '',
                      length: itm['attributes']?['length'] ?? '',
                    ),
                  );
                }
              }
            }
          }
        }
      }
      print("서버에서 받은 데이터 : $result");

      return result;
    } else {
      print('에러 : $response.statusCode');
      throw Exception('데이터를 불러오지 못했습니다. 상태코드: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userId}의 옷장'),  // 예시
      ),
      body: FutureBuilder<List<ClosetItem>>(
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

          // 여기서 items 사용 가능
          final items = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,    // 한 줄에 3개
              mainAxisSpacing: 8,   // 위아래 간격
              crossAxisSpacing: 8,  // 좌우 간격
              childAspectRatio: 1,  // 정사각형
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  // 상세 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClosetDetailPage(item: item),
                    ),
                  );
                },
                child: Container(
                  color: Colors.grey[200],
                  child: _buildItemImage(item.s3Url),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// s3Url (또는 로컬 path)에 따라 이미지 로딩
  Widget _buildItemImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(url, fit: BoxFit.cover);
    } else {
      return Image.asset(url, fit: BoxFit.cover);
    }
  }
}

/// ClosetItem 모델
class ClosetItem {
  final String categoryName;     // 예: "외투"
  final String subcategoryName;  // 예: "코트"
  final String s3Url;            // 링크(네트워크) or 로컬 path
  final String customName;       // 사용자가 붙인 별명
  final String color;            // 색상
  final String printType;        // 프린트/패턴
  final String length;           // 기장

  ClosetItem({
    required this.categoryName,
    required this.subcategoryName,
    required this.s3Url,
    required this.customName,
    required this.color,
    required this.printType,
    required this.length,
  });
}

/// ClosetDetailPage (같은 파일에 정의)
class ClosetDetailPage extends StatelessWidget {
  final ClosetItem item;
  const ClosetDetailPage({Key? key, required this.item}) : super(key: key);

  // 상세 페이지에서도 같은 로직으로 이미지를 보여줄 수 있음
  Widget _buildItemImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(url, fit: BoxFit.cover);
    } else {
      return Image.asset(url, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.customName.isEmpty ? '옷 상세정보' : item.customName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _buildItemImage(item.s3Url),
            ),
            const SizedBox(height: 16),
            Text('카테고리: ${item.categoryName}'),
            Text('하위 카테고리: ${item.subcategoryName}'),
            Text('색상: ${item.color}'),
            Text('프린트: ${item.printType}'),
            Text('기장: ${item.length}'),
            if (item.customName.isNotEmpty)
              Text('사용자 이름: ${item.customName}'),
          ],
        ),
      ),
    );
  }
}