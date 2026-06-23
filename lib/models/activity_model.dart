class ActivityModel {
  final String id;
  final String groupId;
  final String actorId;
  final ActivityType type;
  final String description;
  final DateTime timestamp;

  const ActivityModel({
    required this.id,
    required this.groupId,
    required this.actorId,
    required this.type,
    required this.description,
    required this.timestamp,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        id: json['id'] as String,
        groupId: json['group_id'] as String,
        actorId: json['actor_id'] as String,
        type: ActivityType.values.byName(json['type'] as String),
        description: json['description'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'group_id': groupId,
        'actor_id': actorId,
        'type': type.name,
        'description': description,
        'timestamp': timestamp.toIso8601String(),
      };
}

enum ActivityType { upload, comment, statusChange, memberJoined, merge }
