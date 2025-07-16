part of 'chatbot_bloc.dart';

@immutable
abstract class ChatbotEvent {}

class SendMessage extends ChatbotEvent {
  final String message;
  SendMessage(this.message);
}

class ClearChat extends ChatbotEvent {}
