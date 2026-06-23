class SectionModel {
  final String id;
  final String groupId;
  final String title;
  final String assignedTo;
  final SectionStatus status;
  final DateTime? dueDate;

  const SectionModel({
    required this.id,
    required this.groupId,
    required this.title,
    required this.assignedTo,
    required this.status,
    this.dueDate,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
        id: json['id'] as String,
        groupId: json['group_id'] as String,
        title: json['title'] as String,
        assignedTo: json['assigned_to'] as String,
        status: SectionStatus.values.byName(json['status'] as String),
        dueDate: json['due_date'] != null
            ? DateTime.parse(json['due_date'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'group_id': groupId,
        'title': title,
        'assigned_to': assignedTo,
        'status': status.name,
        'due_date': dueDate?.toIso8601String(),
      };
}

enum SectionStatus { pending, inProgress, submitted, approved }
