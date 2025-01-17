import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../api_service.dart'; // 실제 경로로 수정
import '../widgets/font.dart';
import '../first_screen/signup_db.dart';

class AddPage extends StatefulWidget {
  final String userId; // 외부에서 userId 전달

  const AddPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();

  // OOTD와 주문내역 이미지를 각각 저장할 리스트
  final List<Map<String, dynamic>> _ootdImages = [];
  final List<Map<String, dynamic>> _orderImages = [];

  // 브랜드 선택 관련
  final List<Map<String, String>> _brands = [
    {'name': 'MUSINSA', 'image': 'assets/musinsa.png'},
    {'name': 'ZIGZAG', 'image': 'assets/zigzag.png'},
    {'name': '29CM', 'image': 'assets/29cm.png'},
    {'name': 'ABLY', 'image': 'assets/ably.png'},
  ];
  final Map<String, bool> _brandSelection = {
    'MUSINSA': false,
    'ZIGZAG': false,
    '29CM': false,
    'ABLY': false,
  };

  // 저장 상태
  bool _isSaving = false;
  String _saveMessage = '';

  // 서버에 데이터 저장
  Future<void> _saveData(
      String userId,
      String imageUrl,
      Map<String, dynamic> attributes,
      ) async {
    // 필수 데이터 확인
    if (attributes['categoryName'] == null ||
        attributes['subcategoryName'] == null ||
        attributes['customName'] == null ||
        attributes['attributes'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장 실패: 필수 데이터가 누락되었습니다.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
      _saveMessage = '저장 중...';
    });

    // 전송할 데이터 구성
    final requestData = {
      "userId": userId,
      "fullS3url": imageUrl,
      "vector": [0.1, 0.2, 0.3],
      "closet": [
        {
          "categoryName": attributes['categoryName'],
          "subcategories": [
            {
              "name": attributes['subcategoryName'],
              "items": [
                {
                  "customName": attributes['customName'],
                  "attributes": attributes['attributes'],
                  "s3Url": attributes['s3Url'],
                  "quantity": attributes['quantity'] ?? 1,
                  "status": attributes['status'] ?? 0
                }
              ]
            }
          ]
        }
      ]
    };

    debugPrint('전송 데이터: $requestData');

    // POST 전송
    var result = await _apiService.postData('simpledb/add', requestData);

    // 응답 처리
    if (result['success']) {
      debugPrint('응답 메시지: ${result['data']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장됨: ${result['data']}')),
      );
      setState(() {
        _saveMessage = '저장됨: ${result['data']}';
      });
    } else {
      debugPrint('응답 메시지: ${result['error']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 실패: ${result['error']}')),
      );
      setState(() {
        _saveMessage = '저장 실패: ${result['error']}';
      });
    }

    setState(() {
      _isSaving = false;
    });
  }

  /// 색상 드롭다운
  Widget _buildColorDropdown(Map<String, dynamic> data) {
    final List<Map<String, dynamic>> colorOptions = [
      {'name': '민트', 'color': const Color(0xFFcfffe5)},
      {'name': '화이트', 'color': Colors.white},
      {'name': '베이지', 'color': const Color(0xFFF5F5DC)},
      {'name': '카키', 'color': Colors.green},
      {'name': '그레이', 'color': Colors.grey},
      {'name': '실버', 'color': Colors.grey},
      {'name': '스카이블루', 'color': Colors.lightBlueAccent},
      {'name': '브라운', 'color': Colors.brown},
      {'name': '핑크', 'color': Colors.pink},
      {'name': '블랙', 'color': Colors.black},
      {'name': '그린', 'color': Colors.green},
      {'name': '오렌지', 'color': Colors.orange},
      {'name': '블루', 'color': Colors.blue},
      {'name': '네이비', 'color': Colors.blueGrey},
      {'name': '레드', 'color': Colors.red},
      {'name': '와인', 'color': Color(0xFF800020)},
      {'name': '옐로우', 'color': Colors.yellow},
      {'name': '퍼플', 'color': Colors.purple},
      {'name': '라벤더', 'color': Color(0xFFE6E6FA)},
      {'name': '골드', 'color': Color(0xFFFFD700)},
      {'name': '네온', 'color': Color(0xFF39FF14)},
    ];

    data['selectedColor'] ??= colorOptions.first['name'];

    return DropdownButton<String>(
      value: data['selectedColor'],
      items: colorOptions.map((colorOption) {
        return DropdownMenuItem<String>(
          value: colorOption['name'],
          child: Row(
            children: [
              Container(
                width: 15,
                height: 15,
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                  color: colorOption['color'],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 0.5),
                ),
              ),
              Text(colorOption['name']),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          data['selectedColor'] = value!;
        });
      },
    );
  }

  /// 브랜드 아이콘 목록
  Widget _buildBrandIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _brands.map((brand) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  final brandName = brand['name']!;
                  _brandSelection[brandName] = !_brandSelection[brandName]!;
                  final message = _brandSelection[brandName]!
                      ? '$brandName 을(를) 선택했습니다.'
                      : '$brandName 을(를) 해제했습니다.';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                });
              },
              child: CircleAvatar(
                backgroundImage: AssetImage(brand['image']!),
                backgroundColor: _brandSelection[brand['name']]!
                    ? Colors.blue
                    : Colors.grey[300],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              brand['name']!,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }

  /// 각 옷 아이템에 대한 편집 박스
  Widget _buildEditableBox(Map<String, dynamic> data, String userId, int index) {
    final List<String> categoryOptions = ['상의', '하의', '아우터', '원피스'];
    final List<String> subcategoryOptions = [
      '티셔츠','니트웨어','셔츠','후드티','청바지','팬츠','스커트','조거팬츠',
      '코트','재킷','점퍼','패딩','가디건','짚업','드레스',
    ];
    final List<String> lengthOptions = ['숏', '롱', '미디'];

    data['selectedCategory'] ??= categoryOptions.first;
    data['selectedSubcategory'] ??= subcategoryOptions.first;
    data['selectedLength'] ??= lengthOptions.first;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '아래와 같은 옷이 맞나요? (#${index + 1})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 카테고리 / 서브카테고리 선택
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: data['selectedCategory'],
                  items: categoryOptions.map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) {
                    data['selectedCategory'] = value!;
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  value: data['selectedSubcategory'],
                  items: subcategoryOptions.map((subcategory) {
                    return DropdownMenuItem(value: subcategory, child: Text(subcategory));
                  }).toList(),
                  onChanged: (value) {
                    data['selectedSubcategory'] = value!;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 색상 / 길이
          Row(
            children: [
              Expanded(child: _buildColorDropdown(data)),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButton<String>(
                  value: data['selectedLength'],
                  items: lengthOptions.map((length) {
                    return DropdownMenuItem(value: length, child: Text(length));
                  }).toList(),
                  onChanged: (value) {
                    data['selectedLength'] = value!;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 저장 버튼
          Center(
            child: ElevatedButton(
              onPressed: () {
                final updatedData = <String, dynamic>{
                  'categoryName': data['selectedCategory'],
                  'subcategoryName': data['selectedSubcategory'],
                  'customName': '사용자 정의 이름',
                  'attributes': {
                    'color': data['selectedColor'],
                    'length': data['selectedLength'],
                  },
                  's3Url': 'https://example.com/uploaded_image.jpg',
                  'quantity': 1,
                  'status': 0,
                };

                _saveData(
                  userId,
                  'https://example.com/full_image_url.jpg', // 임의 URL
                  updatedData,
                );
              },
              child: const Text('저장'),
            ),
          ),

          // 저장 진행 상태/결과 메시지
          if (_isSaving) Center(child: Text(_saveMessage)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar에 "간단추가" 버튼을 액션으로 추가
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        // title: const Text('Add Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8A39F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // 모서리 라운딩
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupDBPage(userId: widget.userId),
                  ),
                );
              },
              child: const Text(
                '간단추가',
                style: AppFonts.loginStyle,
              ),
            ),
          ),
        ],
      ),

      // 내용은 스크롤 가능
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            // OOTD 업로드 안내
            const Text(
              '당신의 OOTD를 업로드해주세요',
              style: AppFonts.highlightStyle,
            ),
            const SizedBox(height: 8),

            /// OOTD 이미지 미리보기 + 업로드 버튼
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ..._ootdImages.map(
                      (image) => Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(image['localPath']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // + 버튼
                GestureDetector(
                  onTap: () async {
                    final XFile? pickedImage =
                    await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        _ootdImages.add({'localPath': pickedImage.path});
                      });
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7DEDD),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // OOTD 이미지별 편집 박스
            ..._ootdImages.asMap().entries.map((entry) {
              final index = entry.key;
              final imageData = entry.value;
              return _buildEditableBox(imageData, widget.userId, index);
            }),

            const SizedBox(height: 16),

            // 주문내역 업로드 안내
            const Text(
              '주문내역을 캡처해 업로드해주세요',
              style: AppFonts.highlightStyle,
            ),
            const SizedBox(height: 15),

            // 브랜드 아이콘 목록
            _buildBrandIcons(),
            const SizedBox(height: 16),

            /// 주문 이미지 미리보기 + 업로드 버튼
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ..._orderImages.map(
                      (image) => Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(image['localPath']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // + 버튼
                GestureDetector(
                  onTap: () async {
                    final XFile? pickedImage =
                    await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      setState(() {
                        _orderImages.add({'localPath': pickedImage.path});
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('주문 내역 업로드 완료')),
                      );
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7DEDD),
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ],
        ),
      ),

      // ------------------------------------------------
      // 기존의 bottomNavigationBar는 제거
      // ------------------------------------------------
      // bottomNavigationBar: SafeArea(
      //   child: Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: SizedBox(
      //       height: 50,
      //       width: double.infinity,
      //       child: ElevatedButton(
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: const Color(0xFFB8A39F),
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(8), // 각지게 하려면 0으로
      //           ),
      //         ),
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => SignupDBPage(userId: widget.userId),
      //             ),
      //           );
      //         },
      //         child: const Text(
      //           '간단추가',
      //           style: TextStyle(color: Colors.white, fontSize: 16),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}