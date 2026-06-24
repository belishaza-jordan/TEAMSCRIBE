import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';

/// "Chat" tab — shows recent conversations across all groups.
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  static const _chats = [
    _Chat('Climate Policy Brief',    'POLS 340', 'Priya: About 30% through, should have the charts ready by Friday', '9:31', true),
    _Chat('Database Systems Report', 'CS 425',   'Alex: I updated the ER diagram, take a look',                      'Yesterday', false),
    _Chat('Marketing Launch Plan',   'MKTG 210', 'Diego: Final section merged and exported!',                        'Mon', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:           AppColors.background,
        elevation:                 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Messages',
          style: TextStyle(
              color: AppColors.whiteText, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _chats.length,
        separatorBuilder: (_, i) =>
            Divider(height: 1, color: AppColors.border, indent: 72),
        itemBuilder: (context, i) => _ChatTile(
          chat: _chats[i],
          onTap: () => Navigator.pushNamed(context, AppRoutes.groupDetail),
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  final _Chat chat;
  final VoidCallback onTap;

  const _ChatTile({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final initials = chat.name.split(' ').map((w) => w[0]).take(2).join();
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: _color(initials),
        child: Text(initials,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(chat.name,
                style: const TextStyle(
                    color: AppColors.whiteText,
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ),
          Text(chat.time,
              style: TextStyle(
                  color: chat.unread ? AppColors.blue : AppColors.grayText,
                  fontSize: 12)),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          chat.lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: chat.unread ? AppColors.whiteText : AppColors.grayText,
            fontSize: 13,
            fontWeight: chat.unread ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Color _color(String s) {
    const c = [
      Color(0xFF1E3A5F), Color(0xFF1A3D2B), Color(0xFF3D1F4D),
      Color(0xFF4D2C1A), Color(0xFF1D3640), Color(0xFF3D3220),
    ];
    int h = 0;
    for (final x in s.codeUnits) { h += x; }
    return c[h % c.length];
  }
}

class _Chat {
  final String name, course, lastMessage, time;
  final bool unread;
  const _Chat(this.name, this.course, this.lastMessage, this.time, this.unread);
}
