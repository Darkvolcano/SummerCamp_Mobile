class Blog {
  final int blogId;
  final String title;
  final String content;
  final int authorId;
  final bool isActive;
  final DateTime createAt;

  const Blog({
    required this.blogId,
    required this.title,
    required this.content,
    required this.authorId,
    required this.isActive,
    required this.createAt,
  });
}
