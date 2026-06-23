class MessageModel {
  final String id;
  final String groupId;
  final String senderId;
  final String content;
  final DateTime sentAt;
  final bool isRead;

  const MessageModel({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    required this.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'] as String,
        groupId: json['group_id'] as String,
        senderId: json['sender_id'] as String,
        content: json['content'] as String,
        sentAt: DateTime.parse(json['sent_at'] as String),
        isRead: json['is_read'] as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'group_id': groupId,
        'sender_id': senderId,
        'content': content,
        'sent_at': sentAt.toIso8601String(),
        'is_read': isRead,
      };
}
