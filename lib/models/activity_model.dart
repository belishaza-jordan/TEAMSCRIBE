class ActivityModel {
  final String   id;
  final String   type;         // section_updated | section_done | member_joined
  final String   description;
  final String   userId;
  final String   userName;
  final String   userInitials;
  final String?  groupName;
  final DateTime createdAt;

  const ActivityModel({
    required this.id,
    required this.type,
    required this.description,
    required this.userId,
    required this.userName,
    required this.userInitials,
    this.groupName,
    required this.createdAt,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        id:           json['id'].toString(),
        type:         json['type']          as String,
        description:  json['description']   as String,
        userId:       json['user_id'].toString(),
        userName:     json['user_name']     as String? ?? 'Unknown',
        userInitials: json['user_initials'] as String? ?? '?',
        groupName:    json['group_name']    as String?,
        createdAt:    DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
      );
}

class MemberProgressModel {
  final String  userId;
  final String  name;
  final String  initials;
  final String? avatarUrl;
  final String  role;
  final int     sectionsTotal;
  final int     sectionsDone;
  final int     avgProgress;
  final int     completionRate;
  final String? lastActiveAt;

  const MemberProgressModel({
    required this.userId,
    required this.name,
    required this.initials,
    this.avatarUrl,
    required this.role,
    required this.sectionsTotal,
    required this.sectionsDone,
    required this.avgProgress,
    required this.completionRate,
    this.lastActiveAt,
  });

  factory MemberProgressModel.fromJson(Map<String, dynamic> json) =>
      MemberProgressModel(
        userId:         json['user_id'].toString(),
        name:           json['name']            as String,
        initials:       json['initials']         as String,
        avatarUrl:      json['avatar_url']       as String?,
        role:           json['role']             as String,
        sectionsTotal:  (json['sections_total']  as num?)?.toInt() ?? 0,
        sectionsDone:   (json['sections_done']   as num?)?.toInt() ?? 0,
        avgProgress:    (json['avg_progress']    as num?)?.toInt() ?? 0,
        completionRate: (json['completion_rate'] as num?)?.toInt() ?? 0,
        lastActiveAt:   json['last_active_at']   as String?,
      );
}
