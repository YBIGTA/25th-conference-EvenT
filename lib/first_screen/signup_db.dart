import 'package:flutter/material.dart';
import 'tops_details.dart';
import 'bottoms_details.dart';
import '../../widgets/font.dart';

//블록 사이 여백
const btwblocks = SizedBox(height: 24);
const btwtxt = SizedBox(height: 8);


class SignupDBPage extends StatelessWidget {
  final String userId;
  const SignupDBPage({super.key, required this.userId});

  // 상의 블록 데이터
  static const List<Map<String, String>> topsItems = [
    {'label': '긴팔상의', 'imagePath': 'assets/images/long_sleeve.png'},
    {'label': '반팔상의', 'imagePath': 'assets/images/short_sleeve.png'},
    {'label': '셔츠', 'imagePath': 'assets/images/shirt.png'},
    {'label': '민소매', 'imagePath': 'assets/images/sleeveless.png'},
  ];

  // 하의 블록 데이터
  static const List<Map<String, String>> bottomsItems = [
    {'label': '반바지', 'imagePath': 'assets/images/short_pants.png'},
    {'label': '긴바지', 'imagePath': 'assets/images/long_pants.png'},
    {'label': '스커트', 'imagePath': 'assets/images/skirts.png'}
  ];

  // 아우터 블록 데이터
  static const List<Map<String, String>> outersItems = [
    {'label': '패딩', 'imagePath': 'assets/images/short_pants.png'},
    {'label': '코트', 'imagePath': 'assets/images/long_pants.png'},
    {'label': '기다건', 'imagePath': 'assets/images/skirts.png'},
    {'label': '재킷', 'imagePath': 'assets/images/skirts.png'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // 그림자 제거
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 질문 텍스트
            const Text(
              'Q3. 집에 무슨 옷이 있더라?',
              textAlign: TextAlign.center,
              style: AppFonts.highlightStyle,
            ),
            const SizedBox(height: 16),

            // 상의 텍스트
            const Text(
              '상의',
              style: AppFonts.bodyStyle,
              textAlign: TextAlign.left,
            ),
            btwtxt,

            // 상의 블록
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: EdgeInsets.zero,
              itemCount: topsItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = topsItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            TopsDetailPage(
                              label: item['label']!,
                              imagePath: item['imagePath']!,
                              userId: userId,
                            ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: buildClothingBlock(item['label']!, item['imagePath']!),
                );
              },
            ),
            btwblocks,

            // 하의 텍스트
            const Text(
              '하의',
              style: AppFonts.bodyStyle,
              textAlign: TextAlign.left,
            ),
            btwtxt,

            // 하의 블록
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: EdgeInsets.zero,
              itemCount: bottomsItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = bottomsItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            BottomsDetailPage(
                              label: item['label']!,
                              imagePath: item['imagePath']!,
                              userId: userId,
                            ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: buildClothingBlock(item['label']!, item['imagePath']!),
                );
              },
            ),
            btwblocks,

            // 아우터 텍스트
            const Text(
              '아우터',
              style: AppFonts.bodyStyle,
              textAlign: TextAlign.left,
            ),
            btwtxt,

            // 아우터 블록
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: EdgeInsets.zero,
              itemCount: outersItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = outersItems[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            BottomsDetailPage(
                              label: item['label']!,
                              imagePath: item['imagePath']!,
                              userId: userId,
                            ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: buildClothingBlock(item['label']!, item['imagePath']!),
                );
              },

            ),
          ],
        ),
      ),
    );
  }

  Widget buildClothingBlock(String label, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0, // 그림자 제거
//       ),
//       body: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3, // 한 줄에 3개의 블록
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//         ),
//         padding: const EdgeInsets.all(30),
//         itemCount: topsItems.length,
//         itemBuilder: (context, index) {
//           final item = topsItems[index];
//           return GestureDetector(
//             onTap: () {
//               // 상세 페이지로 이동하며 데이터 전달
//               Navigator.push(
//                 context,
//                 PageRouteBuilder(
//                   pageBuilder: (context, animation1, animation2) => TopsDetailPage(
//                     label: item['label']!,
//                     imagePath: item['imagePath']!,
//                     userId: userId,
//                   ),
//                   transitionDuration: Duration.zero, // 모션 제거
//                   reverseTransitionDuration: Duration.zero, // 모션 제거
//                 ),
//               );
//             },
//             child: buildClothingBlock(item['label']!, item['imagePath']!),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget buildClothingBlock(String label, String imagePath) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey, width: 0.7),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Image.asset(
//                 imagePath,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//           const SizedBox(height:5),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
