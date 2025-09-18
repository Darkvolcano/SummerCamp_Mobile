import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:summercamp/features/blog/data/models/blog_model.dart';
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
      final jsonString = await rootBundle.loadString("assets/mock/blogs.json");
      final List<dynamic> jsonList = json.decode(jsonString);

      _blogs = jsonList.map((e) => BlogModel.fromJson(e)).toList();

      // Uncomment if use this line to call API
      // _blogs = await getBlogsUseCase();
    } catch (e) {
      print("Lỗi load blogs: $e");
      _blogs = [];
    }

    _loading = false;
    notifyListeners();
  }
}
