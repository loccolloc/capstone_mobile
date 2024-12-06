import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenAIService {
  final String? _apiKey = dotenv.env['CHAT_KEY'];

  final String _url = 'https://api.openai.com/v1/chat/completions';

  Future<String> fetchResponse(String userMessage) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $_apiKey',
      },
      body: json.encode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content":
                "Bạn là một trợ lý điều khiển nhà thông minh tên là Aya! Bạn cũng là một trợ lý ảo thông minh giống như Alexa.Người dùng mà bạn đang hỗ trợ là chủ sở hữu của hệ thống này, hãy luôn nhớ rằng đây là người bạn phục vụ."
          },
          {"role": "user", "content": userMessage},
        ],
      }),
    );

    if (response.statusCode == 200) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedResponse);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to load response');
    }
  }
}
