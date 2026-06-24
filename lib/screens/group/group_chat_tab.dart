import 'package:flutter/material.dart';
import '../../config/theme.dart';

class GroupChatTab extends StatefulWidget {
  const GroupChatTab({super.key});

  @override
  State<GroupChatTab> createState() => _GroupChatTabState();
}

class _GroupChatTabState extends State<GroupChatTab> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();

  static const _messages = [
    _Msg('MR', 'Maya',   'Just pushed the intro section — take a look when you get a chance', '9:02', false),
    _Msg('',   '',       'Looks great, clean structure. I\'ll start methodology tonight',      '9:05', true),
    _Msg('JK', 'Jordan', 'Lit review is done — 12 sources cited and formatted',               '9:14', false),
    _Msg('',   '',       'Nice work. Priya, how is the data analysis coming?',                 '9:20', true),
    _Msg('PN', 'Priya',  'About 30% through, should have the charts ready by Friday',         '9:31', false),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Messages list ─────────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            controller:    _scrollCtrl,
            padding:       const EdgeInsets.fromLTRB(16, 16, 16, 8),
            itemCount:     _messages.length,
            itemBuilder:   (_, i) => _BubbleRow(msg: _messages[i]),
          ),
        ),

        // ── Input bar ─────────────────────────────────────────────────
        _InputBar(controller: _controller),
      ],
    );
  }
}

// ─── Message bubble ───────────────────────────────────────────────────────────

class _BubbleRow extends StatelessWidget {
  final _Msg msg;

  const _BubbleRow({required this.msg});

  @override
  Widget build(BuildContext context) {
    if (msg.isMe) {
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
                    decoration: BoxDecoration(
                      color:        AppColors.blue,
                      borderRadius: const BorderRadius.only(
                        topLeft:     Radius.circular(16),
                        topRight:    Radius.circular(16),
                        bottomLeft:  Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Text(msg.content,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14, height: 1.4)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(msg.time,
                    style: const TextStyle(
                        color: AppColors.grayText, fontSize: 11)),
              ],
            ),
          ],
        ),
      );
    }

    // Others' message
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius:          18,
            backgroundColor: _avatarColor(msg.initials),
            child: Text(msg.initials,
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
                          color: AppColors.whiteText, fontSize: 14, height: 1.4)),
                ),
              ),
              const SizedBox(height: 4),
              Text('${msg.sender} · ${msg.time}',
                  style: const TextStyle(
                      color: AppColors.grayText, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Chat input bar ───────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;

  const _InputBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:  AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      padding: EdgeInsets.fromLTRB(
          12, 10, 12, MediaQuery.of(context).viewInsets.bottom + 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Attachment
            GestureDetector(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.attach_file_outlined,
                    color: AppColors.grayText, size: 22),
              ),
            ),

            // Text field
            Expanded(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color:        AppColors.background,
                  borderRadius: BorderRadius.circular(21),
                  border:       Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                      color: AppColors.whiteText, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText:        'Message',
                    hintStyle:       TextStyle(color: AppColors.grayText),
                    border:          InputBorder.none,
                    contentPadding:  EdgeInsets.symmetric(
                        horizontal: 16, vertical: 11),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Send button
            GestureDetector(
              onTap: () {},
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

// ─── Helpers & data ───────────────────────────────────────────────────────────

Color _avatarColor(String s) {
  const colors = [
    Color(0xFF1E3A5F), Color(0xFF1A3D2B), Color(0xFF3D1F4D),
    Color(0xFF4D2C1A), Color(0xFF1D3640), Color(0xFF3D3220),
  ];
  int h = 0;
  for (final c in s.codeUnits) { h += c; }
  return colors[h % colors.length];
}

class _Msg {
  final String initials, sender, content, time;
  final bool   isMe;
  const _Msg(this.initials, this.sender, this.content, this.time, this.isMe);
}
