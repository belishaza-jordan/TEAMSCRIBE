class InvitationModel {
  final String  id;
  final String  groupId;
  final String  groupName;
  final String? groupCourse;
  final String  inviterName;
  final String  email;
  final DateTime expiresAt;

  const InvitationModel({
    required this.id,
    required this.groupId,
    required this.groupName,
    this.groupCourse,
    required this.inviterName,
    required this.email,
    required this.expiresAt,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) => InvitationModel(
    id:          json['id'].toString(),
    groupId:     json['group_id'].toString(),
    groupName:   json['group_name']   as String,
    groupCourse: json['group_course'] as String?,
    inviterName: json['inviter_name'] as String,
    email:       json['email'] as String? ?? '',
    expiresAt:   DateTime.parse(json['expires_at'] as String),
  );
}
