import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/blog/domain/entities/blog.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  const BlogDetailScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppTheme.summerPrimary),
        title: Text(
          blog.title,
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppTheme.summerPrimary,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blog.title,
              style: textTheme.headlineSmall?.copyWith(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
                color: AppTheme.summerAccent,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ngày đăng: ${DateFormatter.formatDate(blog.createdAt)}",
                  style: textTheme.bodySmall?.copyWith(
                    fontFamily: "Quicksand",
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            Text(
              blog.content,
              style: textTheme.bodyLarge?.copyWith(
                fontFamily: "Quicksand",
                color: Colors.black87,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
