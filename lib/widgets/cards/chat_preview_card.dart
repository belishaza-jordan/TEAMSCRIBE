import 'package:flutter/material.dart';
import '../../models/message_model.dart';
import '../../utils/date_formatter.dart';
import '../common/app_avatar.dart';

class ChatPreviewCard extends StatelessWidget {
  final String groupName;
  final MessageModel lastMessage;
  final VoidCallback onTap;

  const ChatPreviewCard({
    super.key,
    required this.groupName,
    required this.lastMessage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: AppAvatar(name: groupName),
      title: Text(groupName,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        lastMessage.content,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        DateFormatter.timeAgo(lastMessage.sentAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
