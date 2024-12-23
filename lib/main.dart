import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart'; // API 요청을 위한 서비스 파일 가져오기

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UploadHomePage(),
    );
  }
}

class UploadHomePage extends StatefulWidget {
  const UploadHomePage({super.key});

  @override
  State<UploadHomePage> createState() => _UploadHomePageState();
}

class _UploadHomePageState extends State<UploadHomePage> {
  final ImagePicker _picker = ImagePicker();
  final List<Map<String, dynamic>> _images = [];
  final ApiService _apiService = ApiService(); // ApiService 인스턴스 생성

  bool _isSaving = false;
  String _saveMessage = '';

  Future<void> _uploadImage(String userId) async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      var result = await _apiService.uploadImage(userId, imageFile.path);

      if (result['success']) {
        setState(() {
          _images.add({
            'localPath': imageFile.path,
            'serverData': result['data'], // 서버 응답 데이터 추가
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('업로드 실패: ${result['error']}')),
        );
      }
    }
  }

  Future<void> _saveData(String userId, Map<String, dynamic> data) async {
    setState(() {
      _isSaving = true;
      _saveMessage = '저장 중...';
    });

    var result = await _apiService.saveData(userId, data);

    if (result['success']) {
      setState(() {
        _saveMessage = '저장됨';
      });

      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _saveMessage = '';
      });
    } else {
      setState(() {
        _saveMessage = '저장 실패: ${result['error']}';
      });
    }

    setState(() {
      _isSaving = false;
    });
  }

  Widget _buildEditableBox(Map<String, dynamic> data, String userId) {
    String selectedColor = data['attributes']['color'];
    String selectedCategory = data['categoryName'];
    String selectedLength = data['attributes']['length'];
    String selectedPattern = data['attributes']['print'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.file(
          File(data['localPath']),
          fit: BoxFit.cover,
          height: 150,
          width: double.infinity,
        ),
        const SizedBox(height: 16),
        const Text('아래와 같은 옷이 맞나요?', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DropdownButton<String>(
              value: selectedColor,
              items: ['빨강', '노랑', '파랑', '흰색'].map((color) {
                return DropdownMenuItem(value: color, child: Text(color));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedColor = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedCategory,
              items: ['셔츠', '아우터', '가디건', '바지'].map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedLength,
              items: ['짧음', '미디', '긴'].map((length) {
                return DropdownMenuItem(value: length, child: Text(length));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLength = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedPattern,
              items: ['스트라이프', '없음'].map((pattern) {
                return DropdownMenuItem(value: pattern, child: Text(pattern));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPattern = value!;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () {
              final updatedData = {
                ...data,
                'attributes': {
                  'color': selectedColor,
                  'length': selectedLength,
                  'print': selectedPattern,
                },
                'categoryName': selectedCategory,
              };
              _saveData(userId, updatedData);
            },
            child: const Text('저장'),
          ),
        ),
        if (_isSaving) Center(child: Text(_saveMessage)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 업로드', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () => _uploadImage('isaac'),
              child: const Text('사진 업로드'),
            ),
            const SizedBox(height: 16),
            ..._images.map((image) => _buildEditableBox(image, 'isaac')),
          ],
        ),
      ),
    );
  }
}
