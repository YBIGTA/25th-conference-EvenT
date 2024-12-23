import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  /// 이미지 업로드 API 요청 함수
  Future<Map<String, dynamic>> uploadImage(String userId, String file) async {
    try {
      final uri = Uri.parse('http://43.203.171.133:8080/s3/upload/isaac');

      // HTTP MultipartRequest 생성
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', file));

      // 요청 보내기
      var response = await request.send();

      // 응답 처리
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var responseData = json.decode(responseBody); // JSON 형식으로 디코딩
        return {'success': true, 'data': responseData};
      } else {
        String responseBody = await response.stream.bytesToString();
        return {'success': false, 'error': responseBody};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// 데이터 저장 API 요청 함수
  Future<Map<String, dynamic>> saveData(String userId, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('http://43.203.171.133:8080/simpledb/add');

      // HTTP POST 요청 생성
      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId, 'data': data}),
      );

      // 응답 처리
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body); // JSON 형식으로 디코딩
        return {'success': true, 'data': responseData};
      } else {
        return {'success': false, 'error': response.body};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
