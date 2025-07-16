import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../controller/chatbot_controller.dart';

part 'chatbot_event.dart';
part 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final ChatbotController chatbotController;

  ChatbotBloc(this.chatbotController) : super(ChatbotLoaded([])) {
    on<SendMessage>(_onSendMessage);
    on<ClearChat>(_onClearChat);
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatbotState> emit) async {
    if (event.message.trim().isEmpty) return;

    final currentChat =
        state is ChatbotLoaded ? List<ChatMessageModel>.from((state as ChatbotLoaded).chat) : [];

    currentChat.add(ChatMessageModel(message: event.message, fromAssistant: false));

    currentChat.add(ChatMessageModel(message: "", fromAssistant: true, loading: true));

    emit(ChatbotLoaded(List.from(currentChat)));

    try {
      await chatbotController.sendMessage(event.message);

      currentChat.removeLast();
      currentChat.add(chatbotController.chat.last);

      emit(ChatbotLoaded(List.from(currentChat)));
    } catch (e) {
      currentChat.removeLast();
      currentChat.add(ChatMessageModel(
        message: "Failed to get response. Try again!",
        fromAssistant: true,
      ));

      emit(ChatbotLoaded(List.from(currentChat)));
    }
  }

  void _onClearChat(ClearChat event, Emitter<ChatbotState> emit) {
    emit(ChatbotLoaded([]));
  }
}
