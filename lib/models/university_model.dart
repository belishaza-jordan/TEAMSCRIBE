class UniversityModel {
  final String id;
  final String name;
  final String country;

  const UniversityModel({
    required this.id,
    required this.name,
    required this.country,
  });

  factory UniversityModel.fromJson(Map<String, dynamic> json) =>
      UniversityModel(
        id: json['id'] as String,
        name: json['name'] as String,
        country: json['country'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'country': country,
      };
}
