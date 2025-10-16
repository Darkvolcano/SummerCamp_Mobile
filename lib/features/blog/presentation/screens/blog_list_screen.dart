import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/blog/domain/entities/blog.dart';
import 'package:summercamp/features/blog/presentation/state/blog_provider.dart';
import 'package:summercamp/features/blog/presentation/widgets/blog_card.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BlogProvider>().loadBlogs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BlogProvider>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Blog Trại Hè",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
        centerTitle: true,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.blogs.isEmpty
          ? Center(
              child: Text(
                "Chưa có bài viết nào",
                style: textTheme.bodyMedium?.copyWith(
                  fontFamily: "Quicksand",
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.blogs.length,
              itemBuilder: (context, index) {
                Blog blog = provider.blogs[index];
                return BlogCard(
                  blog: blog,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.blogDetail,
                      arguments: blog,
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.summerAccent,
        onPressed: () => provider.loadBlogs(),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
