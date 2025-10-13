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
        title: Text(
          blog.title,
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Fredoka",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blog.title,
              style: textTheme.headlineSmall?.copyWith(
                fontFamily: "Fredoka",
                fontWeight: FontWeight.bold,
                color: AppTheme.summerAccent,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row(
                //   children: [
                //     Icon(
                //       blog.isActive ? Icons.check_circle : Icons.cancel,
                //       color: blog.isActive ? Colors.green : Colors.red,
                //       size: 18,
                //     ),
                //     const SizedBox(width: 6),
                //     Text(
                //       blog.isActive ? "Đang hiển thị" : "Đã ẩn",
                //       style: textTheme.bodyMedium?.copyWith(
                //         fontFamily: "Nunito",
                //         color: blog.isActive ? Colors.green : Colors.red,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //   ],
                // ),
                Text(
                  "Ngày đăng: ${DateFormatter.formatDate(blog.createAt)}",
                  style: textTheme.bodySmall?.copyWith(
                    fontFamily: "Nunito",
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),

            Text(
              blog.content,
              style: textTheme.bodyLarge?.copyWith(
                fontFamily: "Nunito",
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
