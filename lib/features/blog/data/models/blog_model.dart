import 'package:summercamp/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  const BlogModel({
    required super.blogId,
    required super.title,
    required super.content,
    required super.authorId,
    super.isActive,
    required super.createdAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      blogId: json['id'],
      title: json['title'],
      content: json['content'],
      authorId: json['authorId'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': blogId,
    'title': title,
    'content': content,
    'authorId': authorId,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
  };
}
