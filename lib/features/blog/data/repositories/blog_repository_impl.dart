import 'package:summercamp/features/blog/data/models/blog_model.dart';
import 'package:summercamp/features/blog/data/services/blog_api_service.dart';
import 'package:summercamp/features/blog/domain/entities/blog.dart';
import 'package:summercamp/features/blog/domain/repositories/blog_repository.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogApiService service;
  BlogRepositoryImpl(this.service);

  @override
  Future<List<Blog>> getBlogs() async {
    final list = await service.fetchBlogs();
    return list.map((e) => BlogModel.fromJson(e)).toList();
  }
}
