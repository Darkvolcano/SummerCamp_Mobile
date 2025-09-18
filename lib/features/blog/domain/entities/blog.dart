class Blog {
  final int id;
  final String title;
  final String content;
  final int authorId;
  final bool isActive;
  final DateTime creatAt;

  const Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.isActive,
    required this.creatAt,
  });
}
