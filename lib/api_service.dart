import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://43.203.171.133:8080'; // 서버 주소 설정

// 데이터 저장 메서드
  Future<Map<String, dynamic>> saveData(String userId, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('$baseUrl/simpledb/add'); // 전체 URL 생성
      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId, 'data': data}),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return {'success': true, 'data': responseData};
      } else {
        return {'success': false, 'error': response.body};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

// 데이터 전송 메서드 (URL 지정 가능)
  Future<Map<String, dynamic>> postData(String url, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('$baseUrl/$url'); // 전체 URL 생성
      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return {'success': true, 'data': responseData};
      } else {
        return {'success': false, 'error': response.body};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

// 이미지 업로드 메서드
  Future<Map<String, dynamic>> uploadImage(String userId, String filePath) async {
    try {
      final uri = Uri.parse('$baseUrl/s3/upload/$userId'); // 업로드 URL
      var request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var responseData = json.decode(responseBody);
        return {'success': true, 'data': responseData};
      } else {
        String responseBody = await response.stream.bytesToString();
        return {'success': false, 'error': responseBody};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}