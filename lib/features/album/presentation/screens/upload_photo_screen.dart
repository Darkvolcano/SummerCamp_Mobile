import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';
import 'package:summercamp/features/album/presentation/state/album_provider.dart';
import 'package:summercamp/features/schedule/domain/entities/schedule.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:summercamp/core/config/staff_theme.dart';

class UploadPhotoScreen extends StatefulWidget {
  final Schedule schedule;
  const UploadPhotoScreen({super.key, required this.schedule});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final List<File> _picked = [];
  bool _isUploading = false;

  int? _selectedAlbumId;
  bool _isLoadingAlbums = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAlbums();
    });
  }

  Future<void> _loadAlbums() async {
    final provider = context.read<AlbumProvider>();
    await provider.loadAlbums(widget.schedule.campId);
    if (mounted) {
      setState(() {
        _isLoadingAlbums = false;
      });
    }
  }

  Future<void> _pickMultiImages() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: const AssetPickerConfig(
        requestType: RequestType.image,
        maxAssets: 50,
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
    if (_selectedAlbumId == null) {
      showCustomDialog(
        context,
        title: "Chưa chọn Album",
        message: "Vui lòng chọn Album trước khi upload",
        type: DialogType.warning,
      );
      return;
    }

    if (_picked.isEmpty) {
      showCustomDialog(
        context,
        title: "Chưa chọn ảnh",
        message: "Vui lòng chọn ít nhất một ảnh để tải lên",
        type: DialogType.warning,
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final provider = context.read<AlbumProvider>();

    try {
      await provider.uploadPhotoToAlbum(_selectedAlbumId!, images: _picked);

      if (!mounted) return;

      setState(() {
        _isUploading = false;
      });

      showCustomDialog(
        context,
        title: "Thành công",
        message: "Đã upload ${_picked.length} ảnh vào album thành công.",
        type: DialogType.success,
      );

      setState(() {
        _picked.clear();
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });

        showCustomDialog(
          context,
          title: "Lỗi",
          message: "Lỗi upload: ${e.toString()}",
          type: DialogType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final albumProvider = context.watch<AlbumProvider>();
    final albums = albumProvider.albums;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Upload Photo - ${widget.schedule.name}",
              style: const TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            backgroundColor: StaffTheme.staffPrimary,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoadingAlbums)
                  const Center(
                    child: LinearProgressIndicator(
                      color: StaffTheme.staffPrimary,
                    ),
                  )
                else if (albums.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Trại này chưa có Album nào. Vui lòng liên hệ Admin để tạo Album trước.",
                            style: TextStyle(fontFamily: "Quicksand"),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  DropdownButtonFormField<int>(
                    initialValue: _selectedAlbumId,
                    decoration: InputDecoration(
                      labelText: "Chọn Album",
                      labelStyle: const TextStyle(fontFamily: "Quicksand"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(
                        Icons.photo_album,
                        color: StaffTheme.staffPrimary,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    items: albums.map((album) {
                      return DropdownMenuItem<int>(
                        value: album.albumId,
                        child: Text(
                          album.title,
                          style: const TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedAlbumId = val;
                      });
                    },
                    hint: const Text(
                      "Vui lòng chọn Album",
                      style: TextStyle(fontFamily: "Quicksand"),
                    ),
                  ),

                const SizedBox(height: 16),

                Expanded(
                  child: _picked.isEmpty
                      ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 60,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Chưa có ảnh nào được chọn',
                                style: TextStyle(
                                  fontFamily: "Quicksand",
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          itemCount: _picked.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
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
                                  top: 4,
                                  right: 4,
                                  child: InkWell(
                                    onTap: () => _removeAt(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
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

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isUploading ? null : _pickMultiImages,
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text(
                          "Thêm ảnh",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: StaffTheme.staffPrimary,
                          side: const BorderSide(
                            color: StaffTheme.staffPrimary,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            (_isUploading ||
                                _picked.isEmpty ||
                                _selectedAlbumId == null)
                            ? null
                            : _uploadPhotos,
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text(
                          "Tải lên",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: StaffTheme.staffPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        if (_isUploading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Container(
                width: 280,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        StaffTheme.staffAccent,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Đang tải lên...',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Vui lòng không tắt ứng dụng',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
