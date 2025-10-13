import 'package:summercamp/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  const BlogModel({
    required super.blogId,
    required super.title,
    required super.content,
    required super.authorId,
    required super.isActive,
    required super.createAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      blogId: json['blogId'],
      title: json['title'],
      content: json['content'],
      authorId: json['authorId'],
      isActive: json['isActive'],
      createAt: DateTime.parse(json['createAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'blogId': blogId,
    'title': title,
    'content': content,
    'authorId': authorId,
    'isActive': isActive,
    'createAt': createAt.toIso8601String(),
  };
}
