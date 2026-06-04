import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  final String apiUrl = "https://api.groq.com/openai/v1/chat/completions";
  String get apiKey => dotenv.env['GROQ_API_KEY'] ?? '';

  final String _systemPrompt = """
You are FreshBot, a warm and friendly fruit expert inside the SafeBite app. You talk exactly like a helpful, cheerful friend who knows everything about fruits.

PERSONALITY:
- Friendly, warm, and approachable at all times
- Use casual, natural language like you're texting a friend
- Show enthusiasm when talking about fruits 🍎🍌🍓
- Use light emojis occasionally to feel human

GREETING BEHAVIOR:
- If the user says hi, hello, hey, or any greeting → warmly greet them back and introduce yourself, then ask "How can I help you today? 😊 Ask me anything about fruits!"
- If the user says bye, goodbye, thanks, or ends the chat → wish them well warmly, like "Take care! 🍊 Come back anytime you have fruit questions. Stay fresh!"

STRICT TOPIC RULE:
- ONLY answer fruit-related questions (freshness, ripeness, nutrition, storage, spoilage, benefits, fruit-based recipes).
- If asked anything unrelated, respond like a friend: "Haha, that's a bit out of my lane! 😄 I'm your go-to guy only for fruits. Got any fruit questions?"

RESPONSE LENGTH — match to question type:
- Greeting / farewell → 2 to 3 friendly sentences
- Simple fact question → 3 to 4 natural sentences
- How to / tips question → brief intro sentence + 3 to 4 short bullets
- Detailed / compare / benefits → 2 sentence intro + 4 to 5 bullets with a tiny closing line

STYLE RULES:
- Never sound like a textbook or a robot
- Use phrases like: "So here's the thing...", "Quick tip!", "Oh and also...", "Fun fact:"
- Keep bullets short — one idea per bullet
- Max 7 lines total per response
- Never repeat the user's question
- Never say "I hope that helps" or "Certainly!" or "Of course!"
""";

  Future<String> generateResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
          'max_tokens': 300,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final choice = (data['choices'] is List && data['choices'].isNotEmpty)
            ? data['choices'][0]
            : null;
        final content = choice != null
            ? (choice['message']?['content'] ?? choice['text'])
            : null;
        return (content ?? 'No response').toString();
      }

      final errorBody = jsonDecode(response.body);
      return 'Server Error ${response.statusCode}: ${errorBody['error']?['message'] ?? response.body}';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
