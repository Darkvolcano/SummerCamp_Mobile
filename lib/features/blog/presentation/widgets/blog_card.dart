import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/blog/domain/entities/blog.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final VoidCallback? onTap;

  const BlogCard({super.key, required this.blog, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề blog
              Text(
                blog.title,
                style: textTheme.titleMedium?.copyWith(
                  fontFamily: "Fredoka",
                  fontWeight: FontWeight.bold,
                  color: AppTheme.summerAccent,
                ),
              ),
              const SizedBox(height: 8),

              // Nội dung tóm tắt
              Text(
                blog.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  fontFamily: "Nunito",
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),

              // Trạng thái + ngày
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        blog.isActive ? Icons.check_circle : Icons.cancel,
                        color: blog.isActive ? Colors.green : Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        blog.isActive ? "Đang hiển thị" : "Đã ẩn",
                        style: textTheme.bodySmall?.copyWith(
                          fontFamily: "Nunito",
                          color: blog.isActive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Ngày đăng: ${DateTime.now().toString().substring(0, 10)}",
                    style: textTheme.bodySmall?.copyWith(
                      fontFamily: "Nunito",
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
