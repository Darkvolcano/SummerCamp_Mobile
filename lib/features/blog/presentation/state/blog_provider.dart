import 'package:flutter/material.dart';
import 'package:summercamp/features/blog/domain/entities/blog.dart';
import 'package:summercamp/features/blog/domain/use_cases/get_blogs.dart';

class BlogProvider with ChangeNotifier {
  final GetBlogs getBlogsUseCase;

  BlogProvider(this.getBlogsUseCase);

  List<Blog> _blogs = [];
  List<Blog> get blogs => _blogs;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadBlogs() async {
    _loading = true;
    notifyListeners();

    try {
      _blogs = await getBlogsUseCase();
    } catch (e) {
      print("Lỗi load blogs: $e");
      _blogs = [];
    }

    _loading = false;
    notifyListeners();
  }
}
