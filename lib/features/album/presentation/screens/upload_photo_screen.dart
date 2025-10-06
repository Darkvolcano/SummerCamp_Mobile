import 'dart:io';
import 'package:flutter/material.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:summercamp/core/config/staff_theme.dart';

class UploadPhotoScreen extends StatefulWidget {
  final Camp camp;
  const UploadPhotoScreen({super.key, required this.camp});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final List<File> _picked = [];

  Future<void> _pickMultiImages() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        requestType: RequestType.image,
        maxAssets: 20, // max image in 1 pick
      ),
    );

    if (result != null && result.isNotEmpty) {
      final files = await Future.wait(
        result.map((e) async {
          final file = await e.file;
          return file!;
        }),
      );

      setState(() {
        _picked.addAll(files);
      });
    }
  }

  void _removeAt(int index) {
    setState(() {
      _picked.removeAt(index);
    });
  }

  Future<void> _uploadPhotos() async {
    if (_picked.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn ít nhất một ảnh")),
      );
      return;
    }

    // call API multipart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Giả lập upload ${_picked.length} ảnh thành công"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload Photo - ${widget.camp.name}",
          style: const TextStyle(
            fontFamily: "Fredoka",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: StaffTheme.staffPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _picked.isEmpty
                  ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.photo_library,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : GridView.builder(
                      itemCount: _picked.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) {
                        final file = _picked[index];
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(file, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: InkWell(
                                onTap: () => _removeAt(index),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickMultiImages,
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Chọn ảnh"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _uploadPhotos,
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text("Upload"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: StaffTheme.staffPrimary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
