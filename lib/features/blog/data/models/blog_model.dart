import 'package:summercamp/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  const BlogModel({
    required super.id,
    required super.title,
    required super.content,
    required super.authorId,
    required super.isActive,
    required super.creatAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['blogId'],
      title: json['title'],
      content: json['content'],
      authorId: json['authorId'],
      isActive: json['isActive'],
      creatAt: DateTime.parse(json['creatAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'blogId': id,
    'title': title,
    'content': content,
    'authorId': authorId,
    'isActive': isActive,
    'creatAt': creatAt.toIso8601String(),
  };
}
