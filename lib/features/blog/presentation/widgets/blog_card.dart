import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/features/blog/domain/entities/blog.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final VoidCallback? onTap;

  const BlogCard({super.key, required this.blog, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      // elevation: 4,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog.title,
                style: textTheme.titleMedium?.copyWith(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  color: AppTheme.summerAccent,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                blog.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  fontFamily: "Quicksand",
                  color: Colors.black87,
                  height: 1.4,
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
            ],
          ),
        ),
      ),
    );
  }
}
