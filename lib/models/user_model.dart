class UserModel {
  final String  id;
  final String  name;
  final String  email;
  final String? avatarUrl;
  final String  university;
  final bool    emailVerified;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.university,
    this.emailVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id:            json['id'].toString(),
        name:          json['name']           as String,
        email:         json['email']          as String,
        avatarUrl:     json['avatar_url']     as String?,
        university:    json['university']     as String? ?? '',
        emailVerified: json['email_verified'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id':         id,
        'name':       name,
        'email':      email,
        'avatar_url': avatarUrl,
        'university': university,
      };
}
