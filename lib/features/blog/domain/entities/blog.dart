class Blog {
  final int blogId;
  final String title;
  final String content;
  final int authorId;
  final bool? isActive;
  final DateTime createdAt;

  const Blog({
    required this.blogId,
    required this.title,
    required this.content,
    required this.authorId,
    this.isActive,
    required this.createdAt,
  });
}
