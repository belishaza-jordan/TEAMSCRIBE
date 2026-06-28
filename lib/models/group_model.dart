class GroupModel {
  final String         id;
  final String         name;
  final String?        course;
  final String?        description;
  final String         createdBy;
  final int            memberCount;
  final int            sectionsTotal;
  final int            sectionsDone;
  final int            progress; // 0-100
  final List<MemberModel> members;

  final String?        joinCode;

  const GroupModel({
    required this.id,
    required this.name,
    this.course,
    this.description,
    required this.createdBy,
    this.joinCode,
    this.memberCount   = 0,
    this.sectionsTotal = 0,
    this.sectionsDone  = 0,
    this.progress      = 0,
    this.members       = const [],
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        id:            json['id'].toString(),
        name:          json['name']         as String,
        course:        json['course']        as String?,
        description:   json['description']   as String?,
        createdBy:     json['created_by'].toString(),
        joinCode:      json['join_code']    as String?,
        memberCount:   (json['member_count'] as num?)?.toInt() ?? 0,
        sectionsTotal: (json['sections_total'] as num?)?.toInt() ?? 0,
        sectionsDone:  (json['sections_done']  as num?)?.toInt() ?? 0,
        progress:      (json['progress']       as num?)?.toInt() ?? 0,
        members: (json['members'] as List? ?? [])
            .map((m) => MemberModel.fromJson(m as Map<String, dynamic>))
            .toList(),
      );
}

class MemberModel {
  final String  id;
  final String  name;
  final String  email;
  final String? avatarUrl;
  final String  role;

  const MemberModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
        id:        json['id'].toString(),
        name:      json['name']       as String,
        email:     json['email']      as String,
        avatarUrl: json['avatar_url'] as String?,
        role:      (json['pivot'] as Map<String, dynamic>?)?['role'] as String? ?? 'member',
      );

  String get initials {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
