class SectionModel {
  final String  id;
  final String  groupId;
  final String  title;
  final String? assignedTo;
  final String? assignedName;
  final String? assignedInitials;
  final String  status; // not_started | in_progress | done
  final int     progress; // 0-100
  final String? dueDate;
  final String? updatedAt;

  const SectionModel({
    required this.id,
    required this.groupId,
    required this.title,
    this.assignedTo,
    this.assignedName,
    this.assignedInitials,
    required this.status,
    this.progress  = 0,
    this.dueDate,
    this.updatedAt,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
        id:               json['id'].toString(),
        groupId:          json['group_id'].toString(),
        title:            json['title']             as String,
        assignedTo:       json['assigned_to']?.toString(),
        assignedName:     json['assigned_name']     as String?,
        assignedInitials: json['assigned_initials'] as String?,
        status:           json['status']            as String? ?? 'not_started',
        progress:         (json['progress']         as num?)?.toInt() ?? 0,
        dueDate:          json['due_date']           as String?,
        updatedAt:        json['updated_at']         as String?,
      );

  SectionModel copyWith({
    String? status,
    int?    progress,
  }) => SectionModel(
        id:               id,
        groupId:          groupId,
        title:            title,
        assignedTo:       assignedTo,
        assignedName:     assignedName,
        assignedInitials: assignedInitials,
        status:           status    ?? this.status,
        progress:         progress  ?? this.progress,
        dueDate:          dueDate,
        updatedAt:        updatedAt,
      );
}
