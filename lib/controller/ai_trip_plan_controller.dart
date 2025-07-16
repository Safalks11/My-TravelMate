import 'package:google_generative_ai/google_generative_ai.dart';

class AiTripPlanController {
  late final GenerativeModel _geminiModel;
  late final ChatSession _chatSession;

  final List<ChatMessageModel> chat = [];

  AiTripPlanController() {
    _geminiModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: 'AIzaSyDzU9BG8CLz7yHFC2Y_QpEwGn8y8XSnRmk',
      systemInstruction: Content.text(
        """You are a Kerala-based smart travel assistant. 
        When users provide travel type, budget, location, and number of days, suggest personalized trip plans with activities, sightseeing, and local tips. 
        Make sure to divide the trip plan into daily itineraries.
        When a user provides just a place, return a list of the best places to visit there with descriptions.
        Keep responses simple and user-friendly.
        """,
      ),
    );

    _chatSession = _geminiModel.startChat();
  }

  /// Generates a detailed trip plan using structured inputs
  Future<String> getTripPlan(String travelType, String place, String budget, String days) async {
    final input =
        "I am planning a $travelType trip to $place for $days days with a budget of $budget. "
        "Please suggest a simple daily itinerary with top places, activities, and local tips.";

    final response = await _chatSession.sendMessage(Content.text(input));
    return response.text ?? "Sorry, I couldn't generate a trip plan.";
  }

  /// Handles general message input and AI reply, maintains chat history
  Future<void> sendMessage(String text) async {
    chat.add(ChatMessageModel(message: text, fromAssistant: false, loading: true));

    final response = await _chatSession.sendMessage(Content.text(text));

    final reply = response.text ?? "I couldn't understand that. Can you rephrase?";

    chat.removeLast(); // remove loading message
    chat.add(ChatMessageModel(message: reply, fromAssistant: true));
  }
}

class ChatMessageModel {
  final String message;
  final bool fromAssistant;
  final bool loading;

  ChatMessageModel({
    required this.message,
    required this.fromAssistant,
    this.loading = false,
  });
}
