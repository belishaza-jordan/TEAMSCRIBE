import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/chat/message_bubble.dart';
import '../../widgets/chat/chat_input_bar.dart';

class GroupChatTab extends StatefulWidget {
  final String groupId;

  const GroupChatTab({super.key, required this.groupId});

  @override
  State<GroupChatTab> createState() => _GroupChatTabState();
}

class _GroupChatTabState extends State<GroupChatTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().fetchMessages(widget.groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final currentUserId =
        context.read<AuthProvider>().currentUser?.id ?? '';

    return Column(
      children: [
        Expanded(
          child: chatProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final msg = chatProvider.messages[index];
                    return MessageBubble(
                      message: msg,
                      isMe: msg.senderId == currentUserId,
                    );
                  },
                ),
        ),
        ChatInputBar(
          onSend: (text) =>
              context.read<ChatProvider>().sendMessage(widget.groupId, text),
        ),
      ],
    );
  }
}
