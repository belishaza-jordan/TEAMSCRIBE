class MessageModel {
  final String   id;
  final String   groupId;
  final String   userId;
  final String   senderName;
  final String   senderInitials;
  final String   content;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.senderName,
    required this.senderInitials,
    required this.content,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id:             json['id'].toString(),
        groupId:        json['group_id'].toString(),
        userId:         json['user_id'].toString(),
        senderName:     json['sender_name']     as String? ?? 'Unknown',
        senderInitials: json['sender_initials'] as String? ?? '?',
        content:        json['content']         as String,
        createdAt:      DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
      );
}
