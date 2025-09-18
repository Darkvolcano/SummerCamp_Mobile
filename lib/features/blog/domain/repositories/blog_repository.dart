import 'package:summercamp/features/blog/domain/entities/blog.dart';

abstract class BlogRepository {
  Future<List<Blog>> getBlogs();
}
