class GroupModel {
  final String id;
  final String name;
  final String description;
  final List<String> memberIds;
  final String createdBy;
  final DateTime createdAt;

  const GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.memberIds,
    required this.createdBy,
    required this.createdAt,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        memberIds: List<String>.from(json['member_ids'] as List),
        createdBy: json['created_by'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'member_ids': memberIds,
        'created_by': createdBy,
        'created_at': createdAt.toIso8601String(),
      };
}
