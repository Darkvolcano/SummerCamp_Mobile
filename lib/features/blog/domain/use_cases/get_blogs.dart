import 'package:summercamp/features/blog/domain/entities/blog.dart';
import 'package:summercamp/features/blog/domain/repositories/blog_repository.dart';

class GetBlogs {
  final BlogRepository repository;
  GetBlogs(this.repository);

  Future<List<Blog>> call() async {
    return await repository.getBlogs();
  }
}
