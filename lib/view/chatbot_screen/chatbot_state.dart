part of 'chatbot_bloc.dart';

@immutable
class ChatbotState {}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotLoaded extends ChatbotState {
  final List<ChatMessageModel> chat;

  ChatbotLoaded(this.chat);
}

class ChatbotError extends ChatbotState {
  final String message;

  ChatbotError(this.message);
}
