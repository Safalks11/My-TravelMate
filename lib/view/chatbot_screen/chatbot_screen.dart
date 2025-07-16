import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/chatbot_controller.dart';
import 'chatbot_bloc.dart';

class TravelChatBotScreen extends StatefulWidget {
  const TravelChatBotScreen({super.key});

  @override
  TravelChatBotScreenState createState() => TravelChatBotScreenState();
}

class TravelChatBotScreenState extends State<TravelChatBotScreen> {
  final TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext context) {
    final text = textController.text;
    if (text.trim().isEmpty) return;

    context.read<ChatbotBloc>().add(SendMessage(text));
    textController.clear();
    _scrollToBottom();
  }

  void _clearChat(BuildContext context) {
    context.read<ChatbotBloc>().add(ClearChat());
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatbotBloc, ChatbotState>(
      builder: (context, state) {
        List<ChatMessageModel> chat = [];

        if (state is ChatbotLoaded) {
          chat = state.chat;
          _scrollToBottom();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'AI ChatBot',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.white,
            elevation: 1,
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _clearChat(context),
                tooltip: "Clear Chat",
              ),
            ],
          ),
          backgroundColor: Colors.grey[100],
          body: Column(
            children: [
              Expanded(
                child: ChatList(chat: chat, controller: _scrollController),
              ),
              _buildInputField(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(context),
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: "Ask me anything...",
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.message, color: Colors.blueAccent),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () => _sendMessage(context),
            mini: true,
            backgroundColor: Colors.blueAccent,
            elevation: 2,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  final List<ChatMessageModel> chat;
  final ScrollController controller;

  const ChatList({required this.chat, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatbotBloc, ChatbotState>(
      builder: (context, state) {
        if (state is ChatbotLoaded) {
          return ListView.builder(
            controller: controller,
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: state.chat.length,
            itemBuilder: (context, index) {
              return ChatBubble(
                message: state.chat[state.chat.length - 1 - index],
                isGrouped: _shouldGroupMessage(state.chat, index),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(color: Colors.blueAccent),
        );
      },
    );
  }

  bool _shouldGroupMessage(List<ChatMessageModel> chat, int index) {
    if (index == 0) return false;
    return chat[index].fromAssistant == chat[index - 1].fromAssistant;
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isGrouped;

  const ChatBubble({required this.message, required this.isGrouped, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.fromAssistant ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
          top: isGrouped ? 2 : 8,
          bottom: 2,
          left: message.fromAssistant ? 12 : 50,
          right: message.fromAssistant ? 50 : 12,
        ),
        padding: const EdgeInsets.all(14),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          gradient: message.fromAssistant
              ? const LinearGradient(
                  colors: [Colors.white, Colors.white],
                )
              : const LinearGradient(
                  colors: [Colors.blueAccent, Color(0xFF007BFF)],
                ),
          borderRadius: BorderRadius.circular(isGrouped ? 14 : 18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: message.loading
            ? _buildShimmerEffect()
            : MarkdownBody(
                data: message.message,
                selectable: true,
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color:
                        message.fromAssistant ? Colors.black87 : Colors.white,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 150,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
