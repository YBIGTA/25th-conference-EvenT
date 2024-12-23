// // import 'package:flutter/material.dart';
// // import 'package:swipe_cards/swipe_cards.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// //
// // // 서버 요청 함수
// // Future<List<SwipeItem>> fetchInitialCards(String userId) async {
// //   try {
// //     final response = await http.get(
// //       Uri.parse('http://localhost:8080/pinecone/search?userId=$userId'),
// //     );
// //
// //     if (response.statusCode == 200) {
// //       final List<dynamic> data = json.decode(response.body);
// //
// //       return data.map((item) {
// //         final s3Url = item['item']['s3Url'];
// //         return SwipeItem(
// //           content: s3Url ?? 'https://via.placeholder.com/391x579',
// //           likeAction: () => print("스타일을 좋아하셨습니다.❤️"),
// //           nopeAction: () => print("스타일을 싫어하셨습니다.💔"),
// //           superlikeAction: () => print("스타일을 저장하셨습니다!😙"),
// //         );
// //       }).toList();
// //     } else {
// //       throw Exception("Failed to load cards");
// //     }
// //   } catch (e) {
// //     print("Error: $e");
// //     return [];
// //   }
// // }
// //
// // Future<void> requestMoreCards(String userId) async {
// //   try {
// //     final response = await http.post(
// //       Uri.parse('http://localhost:8080/pinecone/action/add'),
// //       headers: {'Content-Type': 'application/json'},
// //       body: json.encode({"userId": userId, "clothesId": 101}), // clothesId는 예시값
// //     );
// //
// //     if (response.statusCode != 200) {
// //       throw Exception("Failed to request more cards");
// //     }
// //   } catch (e) {
// //     print("Error: $e");
// //   }
// // }
// //
// //
// //
// // // 앱바
// // class StylePage extends StatelessWidget {
// //   final String userId;
// //   StylePage({required this.userId});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     print(userId);
// //     return SwipeCardView(userId: userId);
// //   }
// // }
// //
// //
// //
// // class SwipeCardView extends StatefulWidget {
// //   final String userId;
// //   SwipeCardView({required this.userId});
// //
// //   @override
// //   _SwipeCardViewState createState() => _SwipeCardViewState();
// // }
// //
// // class _SwipeCardViewState extends State<SwipeCardView> {
// //   List<SwipeItem> swipeItems = [];
// //   MatchEngine? matchEngine;
// //
// //   final List<String> cardImages = [
// //     'https://via.placeholder.com/391x579',
// //     'https://via.placeholder.com/397x551',
// //     'https://via.placeholder.com/394x602',
// //   ];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //
// //     // SwipeItem 생성
// //     for (int i = 0; i < cardImages.length; i++) {
// //       swipeItems.add(SwipeItem(
// //         content: cardImages[i],
// //         likeAction: () {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text("스타일을 좋아하셨습니다.❤️ ${i + 1}")),
// //           );
// //         },
// //         nopeAction: () {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text("스타일을 싫어하셨습니다.💔 ${i + 1}")),
// //           );
// //         },
// //         superlikeAction: () {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text("스타일을 저장하셨습니다!😙 ${i + 1}")),
// //           );
// //         },
// //       ));
// //     }
// //
// //     // MatchEngine 초기화
// //     matchEngine = MatchEngine(swipeItems: swipeItems);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Stack(
// //       children: [
// //         Align(
// //           alignment: Alignment.topCenter, // 수평 가운데 정렬
// //           child: Padding(
// //             padding: const EdgeInsets.only(top: 50), // 상단에서 150px 아래로 배치
// //             child: SwipeCards(
// //               matchEngine: matchEngine!,
// //               itemBuilder: (BuildContext context, int index) {
// //                 return _buildCard(swipeItems[index].content);
// //               },
// //               onStackFinished: () {
// //                 ScaffoldMessenger.of(context).showSnackBar(
// //                   const SnackBar(content: Text("No more cards!")),
// //                 );
// //               },
// //               upSwipeAllowed: true,
// //               fillSpace: false,
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildCard(String imageUrl) {
// //     return Container(
// //       width: 316,
// //       height: 551,
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(25),
// //         color: Colors.white,
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.1),
// //             blurRadius: 22,
// //             offset: const Offset(0, 17),
// //           ),
// //         ],
// //       ),
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(25),
//               child: Image.network(imageUrl, fit: BoxFit.fill),
//             ),
//           ),
//
//           // 하단 그라데이션
//           Positioned(
//             bottom: 0,
//             child: Container(
//               height: 140,
//               width: 316,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                   colors: [Colors.black, Colors.transparent],
//                 ),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(25),
//                   bottomRight: Radius.circular(25),
//                 ),
//               ),
//             ),
//           ),
//
//           //하단 아이콘들
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: IconButton(
//               icon: Icon(Icons.clear, color: Colors.white, size: 30),
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("스타일을 싫어하셨습니다.💔")),
//                 );
//               },
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             right: 20,
//             child: IconButton(
//               icon: Icon(Icons.check, color: Colors.white, size: 30),
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("스타일을 좋아하셨습니다.❤️")),
//                 );
//               },
//             ),
//           ),
//           Positioned(
//             bottom: 20,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: IconButton(
//                 icon: Icon(Icons.favorite, color: Colors.white, size: 30),
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("스타일을 저장하셨습니다!😙")),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//
// // Future<void> requestMoreCards(String userId) async {
// //   try {
// //     final response = await http.post(
// //       Uri.parse('http://43.203.171.133:8080/pinecone/action/add'),
// //       headers: {'Content-Type': 'application/json'},
// //       body: json.encode({"userId": userId, "clothesId": 101}), // clothesId는 예시값
// //     );
// //
// //     if (response.statusCode != 200) {
// //       throw Exception("Failed to request more cards");
// //     }
// //   } catch (e) {
// //     print("Error: $e");
// //   }
// // }
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// 서버 요청 함수들
Future<List<SwipeItem>> fetchInitialCards(String userId, Function handleSwipeCallback, BuildContext context) async {
  try {
    final response = await http.get(
      Uri.parse('http://43.203.171.133:8080/pinecone/search?userId=user00'),
    );

    if (response.statusCode == 200) {
      print("fetchInitialCards()");
      final List<dynamic> data = json.decode(response.body);
      print("data: $data");



      // SwipeItem 리스트 생성
      final items = data.map((item) {
        final s3Url = item['item']['s3Url'];
        return SwipeItem(
          content: s3Url,
          likeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("스타일을 좋아하셨습니다.❤️"), duration: Duration(milliseconds: 500),)// 0.5초
            );
            handleSwipeCallback(); // 오른쪽 스와이프 처리
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
          superlikeAction:  () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("스타일을 저장하셨습니다!😙"), duration: Duration(milliseconds: 500),),
            );
            handleSwipeCallback();
            print("Card saved: $s3Url");
          }
        );
      }).toList();
      print("리턴: $items");
      return items;
    } else {
      throw Exception("Failed to load cards");
    }
  } catch (e) {
    print("Error: $e");
    return [];
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

  @override
  void initState() {
    super.initState();
    loadInitialCards(); // 초기 데이터 로드
  }

  /// 서버에서 초기 데이터 로드
  void loadInitialCards() async {
    final fetchedItems = await fetchInitialCards(widget.userId, handleSwipe, context);
    print("loadInitialCards()");

    setState(() {
      swipeItems.addAll(fetchedItems); // 가져온 데이터 추가
      updateMatchEngine(); // MatchEngine 업데이트
    });
    print("loadInitialCards() 후 : ${swipeItems.length}개");
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
      print("UpdateMatchEngine : Swipe Items: $swipeItems");
      print("MatchEngine updated with ${swipeItems.length} items.");
    });
  }

  /// 스와이프 처리
  void handleSwipe() async {
    print("handleSwipe(): ${swipeItems.length}");
    setState(() {
      if (swipeItems.isNotEmpty) {
        swipeItems.removeAt(0); // 첫 번째 카드 제거
      }

      print("남은 카드 길이: ${swipeItems.length}");

      // 카드가 2개 이하일 때 추가 데이터 로드
      if (swipeItems.length <= 2) {
        print("카드 부족! Fetching more...");
        fetchAndAddMoreCards(); // 추가 데이터 로드
      }

      // MatchEngine 업데이트
      updateMatchEngine();
      // matchEngine?.currentItem = swipeItems.first;


    });
  }

  /// 추가 데이터 로드
  void fetchAndAddMoreCards() async {
    print("fetchAndAddMoreCards()");
    final moreCards = await fetchInitialCards(widget.userId, handleSwipe, context);

    setState(() {
      swipeItems.addAll(moreCards); // 새 카드 추가
      updateMatchEngine(); // MatchEngine 동기화
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Building UI with ${swipeItems.length} swipe items.");
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
                  colors: [Colors.black, Colors.transparent],
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
                icon: Icon(Icons.favorite, color: Colors.white, size: 30),
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