class UploadModel {
  final String id;
  final String sectionId;
  final String uploadedBy;
  final String fileUrl;
  final String fileName;
  final int fileSizeBytes;
  final DateTime uploadedAt;

  const UploadModel({
    required this.id,
    required this.sectionId,
    required this.uploadedBy,
    required this.fileUrl,
    required this.fileName,
    required this.fileSizeBytes,
    required this.uploadedAt,
  });

  factory UploadModel.fromJson(Map<String, dynamic> json) => UploadModel(
        id: json['id'] as String,
        sectionId: json['section_id'] as String,
        uploadedBy: json['uploaded_by'] as String,
        fileUrl: json['file_url'] as String,
        fileName: json['file_name'] as String,
        fileSizeBytes: json['file_size_bytes'] as int,
        uploadedAt: DateTime.parse(json['uploaded_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'section_id': sectionId,
        'uploaded_by': uploadedBy,
        'file_url': fileUrl,
        'file_name': fileName,
        'file_size_bytes': fileSizeBytes,
        'uploaded_at': uploadedAt.toIso8601String(),
      };
}
