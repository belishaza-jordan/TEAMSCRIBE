import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/message_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';

class GroupChatTab extends StatefulWidget {
  final String groupId;
  const GroupChatTab({super.key, required this.groupId});

  @override
  State<GroupChatTab> createState() => _GroupChatTabState();
}

class _GroupChatTabState extends State<GroupChatTab> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    context.read<ChatProvider>().sendMessage(widget.groupId, text);

    // Scroll to bottom after the frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();
    final userId   = context.watch<AuthProvider>().currentUser?.id ?? '';

    // Auto-scroll when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });

    return Column(
      children: [
        Expanded(
          child: provider.isLoading && provider.messages.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.blue))
              : provider.messages.isEmpty
                  ? const Center(
                      child: Text(
                        'No messages yet. Say hi! 👋',
                        style: TextStyle(
                            color: AppColors.grayText, fontSize: 14),
                      ),
                    )
                  : ListView.builder(
                      controller:  _scrollCtrl,
                      padding:     const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      itemCount:   provider.messages.length,
                      itemBuilder: (_, i) => _BubbleRow(
                        msg:  provider.messages[i],
                        isMe: provider.messages[i].userId == userId,
                      ),
                    ),
        ),
        _InputBar(
          controller: _controller,
          onSend:     _send,
        ),
      ],
    );
  }
}

// ─── Message bubble ───────────────────────────────────────────────────────────

class _BubbleRow extends StatelessWidget {
  final MessageModel msg;
  final bool         isMe;

  const _BubbleRow({required this.msg, required this.isMe});

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.68),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: const BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft:     Radius.circular(16),
                        topRight:    Radius.circular(16),
                        bottomLeft:  Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Text(msg.content,
                        style: const TextStyle(
                            color:  Colors.white,
                            fontSize: 14,
                            height:   1.4)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(_formatTime(msg.createdAt),
                    style: const TextStyle(
                        color: AppColors.grayText, fontSize: 11)),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius:          18,
            backgroundColor: _avatarColor(msg.senderInitials),
            child: Text(msg.senderInitials,
                style: const TextStyle(
                    color:      Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize:   11)),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.65),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color:        AppColors.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft:     Radius.circular(16),
                      topRight:    Radius.circular(16),
                      bottomLeft:  Radius.circular(4),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(msg.content,
                      style: const TextStyle(
                          color:    AppColors.whiteText,
                          fontSize: 14,
                          height:   1.4)),
                ),
              ),
              const SizedBox(height: 4),
              Text('${msg.senderName} · ${_formatTime(msg.createdAt)}',
                  style: const TextStyle(
                      color: AppColors.grayText, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Input bar ────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback           onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:  AppColors.surface,
        border: Border(
            top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      padding: EdgeInsets.fromLTRB(
          12, 10, 12,
          MediaQuery.of(context).viewInsets.bottom + 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color:        AppColors.background,
                  borderRadius: BorderRadius.circular(21),
                  border:       Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller:      controller,
                  onSubmitted:     (_) => onSend(),
                  textInputAction: TextInputAction.send,
                  style: const TextStyle(
                      color: AppColors.whiteText, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText:       'Message',
                    hintStyle:      TextStyle(color: AppColors.grayText),
                    border:         InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 11),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width:  42,
                height: 42,
                decoration: BoxDecoration(
                  color:        AppColors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helper ───────────────────────────────────────────────────────────────────

Color _avatarColor(String s) {
  const colors = [
    Color(0xFF1E3A5F), Color(0xFF1A3D2B), Color(0xFF3D1F4D),
    Color(0xFF4D2C1A), Color(0xFF1D3640), Color(0xFF3D3220),
  ];
  int h = 0;
  for (final c in s.codeUnits) { h += c; }
  return colors[h % colors.length];
}
