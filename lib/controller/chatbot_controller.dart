import 'package:google_generative_ai/google_generative_ai.dart';

class ChatbotController {
  final GenerativeModel geminiModel = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyDzU9BG8CLz7yHFC2Y_QpEwGn8y8XSnRmk',
    systemInstruction: Content.text("""You are a Kerala travel assistant.  
    Your job is to provide trip plans, recommend places to visit, suggest activities, and offer emergency information within Kerala.  

    Guidelines:  
    - Only respond to travel-related questions about Kerala.  
    - If the user asks about other topics (politics, general knowledge, tech, history, etc.), reply:  
      *"I am a Kerala travel assistant. Please ask me travel-related questions about Kerala."*  
    - If the user sends spam (repeated messages, random characters, excessive emojis), remind them to ask a proper travel-related question.  
    - Check previous chat history (if available) to provide better responses and avoid redundancy.  
    """),
  );

  final chat = <ChatMessageModel>[];

  Future<void> sendMessage(String text) async {
    chat.add(
        ChatMessageModel(message: text, fromAssistant: false, loading: false));

    final response =
        await geminiModel.startChat().sendMessage(Content.text(text));

    final reply =
        response.text ?? "I couldn't understand that. Can you rephrase?";
    chat.add(
        ChatMessageModel(message: reply, fromAssistant: true, loading: false));
  }
}

class ChatMessageModel {
  final String message;
  final bool fromAssistant;
  final bool loading;

  ChatMessageModel(
      {required this.message,
      required this.fromAssistant,
      this.loading = false});
}
