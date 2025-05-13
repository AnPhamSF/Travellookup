import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiChatService {
  final String apiKey = 'AIzaSyCy8DR8OMy4WnVH5HByDyMf4ZXcYLKNBFA'; // <-- Thay bằng key thật

  Future<String> sendMessage(String message) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': message}
          ]
        }
      ]
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      return 'Lỗi khi gọi API: ${response.statusCode}';
    }
  }
}
