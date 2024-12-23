import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// 서버 요청 함수들
Future<Map<String, dynamic>> fetchInitialCards(
    String userId,
    Function handleSwipeCallback,
    BuildContext context,
    ) async {

  try {
    final response = await http.get(
      Uri.parse('http://43.203.171.133:8080/pinecone/search?userId=user00'),
    );

    if (response.statusCode == 200) {
      print("-----fetchInitialCards()-----");
      final List<dynamic> data = json.decode(response.body);
      // print("data: $data");

      // clothesId 리스트 생성
      List<int> clothesIds = [];

      for (var item in data) {
        final clothesId = item['item']['clothesId'];
        clothesIds.add(clothesId);
      }

      // SwipeItem 리스트 생성
      final items = data.map((item) {
        final s3Url = item['item']['s3Url'];
        // final clothesId = item['item']['clothesId'];
        return SwipeItem(
          content: s3Url,

          // 오른쪽 스와이프
          likeAction: () async {
            // POST 요청
            await sendLikeAction(userId);
            // 스낵바
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("스타일을 좋아하셨습니다.❤️"), duration: Duration(milliseconds: 500),)// 0.5초
            );
            // 카드 남은 길이 계산 및 업데이트
            handleSwipeCallback();
            print("Card liked: $s3Url");
          },
          nopeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("스타일을 싫어하셨습니다.💔️"), duration: Duration(milliseconds: 500),),
            );
            handleSwipeCallback(); // 왼쪽 스와이프 처리
            print("Card disliked: $s3Url");
          },
          // 위쪽 스와이프 : 저장
          superlikeAction:  () async {
            // final currentClothesId = clothesIds[0];

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("스타일을 저장하셨습니다!😙"), duration: Duration(milliseconds: 500),),
            );
            final updatedClothesIds = await handleSwipeCallback();
            final currentClothesId = updatedClothesIds[0];
            await sendSaveAction(userId, currentClothesId);
            print("Card saved: $s3Url, clothesId: $currentClothesId");
          }
        );
      }).toList();

      final mappedreturn = {"swipeItems": items, "clothesIds": clothesIds,};

      print("리턴: $mappedreturn");

      // Map으로 반환
      return mappedreturn;
    } else {
      throw Exception("Failed to load cards");
    }
  } catch (e) {
    print("Error: $e");
    return {
      "swipeItems": [],
      "clothesIds": [],
    };
  }
}

// 좋아요 시 POST 요청
Future<void> sendLikeAction(String userId) async {
  final url = Uri.parse('http://43.203.171.133:8080/pinecone/action/like');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'userId': 'isaac'});

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      print("POST 요청 성공: ${response.body}");
    } else {
      print("POST 요청 실패: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("POST 요청 중 오류 발생: $e");
  }
}

// 저장 시 POST 요청
Future<void> sendSaveAction(String userId, int clothesId) async {
  print('------sendSaveAction------');
  final url = Uri.parse('http://43.203.171.133:8080/pinecone/action/save');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({'userId': 'isaac', 'clothesId' : clothesId});
  print("요청 바디 : $body");

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      print("POST 요청 성공: ${response.body}");
    } else {
      print("POST 요청 실패: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("POST 요청 중 오류 발생: $e");
  }
}

/// 페이지 및 UI 코드
class StylePage extends StatelessWidget {
  final String userId;
  StylePage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return SwipeCardView(userId: userId);
  }
}

class SwipeCardView extends StatefulWidget {

  final String userId;
  SwipeCardView({required this.userId});

  @override
  _SwipeCardViewState createState() => _SwipeCardViewState();
}

class _SwipeCardViewState extends State<SwipeCardView> {
  List<SwipeItem> swipeItems = []; // SwipeItem 리스트
  MatchEngine? matchEngine;
  List clothesId = [];

  @override
  void initState() {
    super.initState();
    loadInitialCards(); // 초기 데이터 로드
  }

  /// 서버에서 초기 데이터 로드
  void loadInitialCards() async {
    final result = await fetchInitialCards(widget.userId, handleSwipe, context);
    print("-----loadInitialCards()-----");

    setState(() {
      final fetchedItems = result['swipeItems'] as List<SwipeItem>;
      final fetchedClothesIds = result["clothesIds"] as List<int>;

      // 가져온 데이터 추가
      swipeItems.addAll(fetchedItems);
      clothesId.addAll(fetchedClothesIds);

      updateMatchEngine(); // MatchEngine 업데이트
    });
    print("loadInitialCards() 후 : ${swipeItems.length}개, ClothesId: $clothesId");
  }

  /// MatchEngine 업데이트
  void updateMatchEngine() {
    if (swipeItems.isEmpty) {
      print("No SwipeItems available to update MatchEngine!");
      return;
    }

    setState(() {
      matchEngine = MatchEngine(swipeItems: List.from(swipeItems));
      print("UpdateMatchEngine : Current Item: ${matchEngine?.currentItem?.content}");
      // print("UpdateMatchEngine : Swipe Items: $swipeItems");
      print("UpdateMatchEngine : MatchEngine updated with ${swipeItems.length} items.");
    });
  }

  /// 스와이프 처리
  Future<List<dynamic>> handleSwipe() async {
    print("------handleSwipe(): ${swipeItems.length}------");
    setState(() {
      if (swipeItems.isNotEmpty) {
        swipeItems.removeAt(0); // 첫 번째 카드 제거
      }
      if (clothesId.isNotEmpty) {
        clothesId.removeAt(0); // clothesId 리스트에서 제거
      }

      print("스와이프 후 남은 카드 길이: ${swipeItems.length}");
      print("스와이프 후 남은 clothes id : $clothesId");

      // 카드가 2개 이하일 때 추가 데이터 로드
      if (swipeItems.length <= 2) {
        print("카드 부족! Fetching more...");
        fetchAndAddMoreCards(); // 추가 데이터 로드
      }

      // MatchEngine 업데이트
      updateMatchEngine();
      // matchEngine?.currentItem = swipeItems.first;
    });
    return clothesId;
  }

  /// 추가 데이터 로드
  void fetchAndAddMoreCards() async {
    print("------fetchAndAddMoreCards()------");
    final moreCards = await fetchInitialCards(widget.userId, handleSwipe, context);

    setState(() {
      final newSwipeItems = moreCards["swipeItems"] as List<SwipeItem>;
      final newClothesIds = moreCards["clothesIds"] as List<int>;

      // 기존 리스트에 새 데이터 추가
      swipeItems.addAll(newSwipeItems); // 새 카드 추가
      clothesId.addAll(newClothesIds); // clothesid도 추가
      updateMatchEngine(); // MatchEngine 동기화
    });
    print("fetchAndAddMoreCards후 : ${swipeItems.length}개, ClothesId: ${clothesId.length}개");
  }

  @override
  Widget build(BuildContext context) {
    print("------Building UI with ${swipeItems.length} swipe items.------");
    return Scaffold(
      body: Stack(
        children: [
          if (matchEngine != null && swipeItems.isNotEmpty)
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SwipeCards(
                  key: UniqueKey(),
                  matchEngine: matchEngine!,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCard(swipeItems[index].content);
                  },
                  onStackFinished: () {
                    setState(() {
                      print("All cards swiped. Fetching new cards...");
                      fetchAndAddMoreCards(); // 카드 소진 시 새 데이터 가져오기
                    });
                  },
                  upSwipeAllowed: true,
                  fillSpace: false,
                ),
              ),
            ),
          if (matchEngine == null || swipeItems.isEmpty)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildCard(String imageUrl) {
    return Container(
      width: 316,
      height: 551,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 22,
            offset: const Offset(0, 17),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),

          // 하단 그라데이션
          Positioned(
            bottom: 0,
            child: Container(
              height: 140,
              width: 316,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
            ),
          ),

          //하단 아이콘들
          Positioned(
            bottom: 20,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.clear, color: Colors.white, size: 30),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("스타일을 싫어하셨습니다.💔")),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.check, color: Colors.white, size: 30),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("스타일을 좋아하셨습니다.❤️")),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: IconButton(
                icon: Icon(Icons.favorite, color: Colors.redAccent, size: 30),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("스타일을 저장하셨습니다!😙")),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}