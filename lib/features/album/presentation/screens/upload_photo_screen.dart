import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/features/album/presentation/state/album_provider.dart';
import 'package:summercamp/features/schedule/domain/entities/schedule.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';

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

  final GlobalKey _dropdownKey = GlobalKey();

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

  Future<void> _loadPhotos(int albumId) async {
    final provider = context.read<AlbumProvider>();
    await provider.loadPhotos(albumId);
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

  void _removePickedImage(int index) {
    setState(() {
      _picked.removeAt(index);
    });
  }

  void _viewImage(ImageProvider imageProvider, String tag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          extendBodyBehindAppBar: true,
          body: Center(
            child: Hero(
              tag: tag,
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image(image: imageProvider),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAlbumDropdown() async {
    final albumProvider = context.read<AlbumProvider>();
    final albums = albumProvider.albums;

    if (albums.isEmpty) return;

    final RenderBox? renderBox =
        _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final RelativeRect position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + size.height,
      offset.dx + size.width,
      offset.dy + size.height + 300,
    );

    final int? selected = await showMenu<int>(
      context: context,
      position: position,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      surfaceTintColor: Colors.white,
      color: Colors.white,
      elevation: 4,
      constraints: BoxConstraints(
        minWidth: size.width,
        maxWidth: size.width,
        maxHeight: 300,
      ),
      items: albums.map((album) {
        return PopupMenuItem<int>(
          value: album.albumId,
          height: 30,
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
    );

    if (selected != null && selected != _selectedAlbumId) {
      setState(() {
        _selectedAlbumId = selected;
        _picked.clear();
      });
      _loadPhotos(selected);
    }
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
        message: "Vui lòng chọn ít nhất một ảnh mới để tải lên",
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
        message: "Đã upload ${_picked.length} ảnh mới thành công.",
        type: DialogType.success,
      );

      setState(() {
        _picked.clear();
      });
      _loadPhotos(_selectedAlbumId!);
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
    final existingPhotos = albumProvider.albumPhotos;
    final bool isLoadingPhotos = albumProvider.loading;

    final int totalItemCount = existingPhotos.length + _picked.length;

    String selectedAlbumTitle = "Vui lòng chọn Album";
    if (_selectedAlbumId != null && albums.isNotEmpty) {
      try {
        selectedAlbumTitle = albums
            .firstWhere((a) => a.albumId == _selectedAlbumId)
            .title;
      } catch (_) {}
    }

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
                  GestureDetector(
                    key: _dropdownKey,
                    onTap: _showAlbumDropdown,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Chọn Album",
                        labelStyle: const TextStyle(
                          fontFamily: "Quicksand",
                          color: StaffTheme.staffPrimary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: StaffTheme.staffPrimary,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: StaffTheme.staffPrimary,
                            width: 2.0,
                          ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedAlbumTitle,
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontWeight: _selectedAlbumId != null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: _selectedAlbumId != null
                                    ? Colors.black87
                                    : Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                Expanded(
                  child: _selectedAlbumId == null
                      ? Center(
                          child: Text(
                            "Vui lòng chọn Album để xem và thêm ảnh",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              color: Colors.grey.shade600,
                            ),
                          ),
                        )
                      : isLoadingPhotos && existingPhotos.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: StaffTheme.staffPrimary,
                          ),
                        )
                      : totalItemCount == 0
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
                                'Album trống. Hãy thêm ảnh mới!',
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
                          itemCount: totalItemCount,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1,
                              ),
                          itemBuilder: (context, index) {
                            if (index < existingPhotos.length) {
                              final photo = existingPhotos[index];
                              final tag = 'existing_${photo.photo}';

                              return GestureDetector(
                                onTap: () =>
                                    _viewImage(NetworkImage(photo.photo), tag),
                                child: Hero(
                                  tag: tag,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      photo.photo,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) =>
                                          Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                              Icons.broken_image,
                                              color: Colors.grey,
                                            ),
                                          ),
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                    : null,
                                                strokeWidth: 2,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              final pickedIndex = index - existingPhotos.length;
                              final file = _picked[pickedIndex];
                              final tag = 'new_$pickedIndex';

                              return GestureDetector(
                                onTap: () => _viewImage(FileImage(file), tag),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Hero(
                                      tag: tag,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          file,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: InkWell(
                                        onTap: () =>
                                            _removePickedImage(pickedIndex),
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
                                    Positioned(
                                      bottom: 4,
                                      left: 4,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: const Text(
                                          "Mới",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isUploading || _selectedAlbumId == null
                            ? null
                            : _pickMultiImages,
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
                          disabledForegroundColor: Colors.grey,
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
                        label: Text(
                          _picked.isNotEmpty
                              ? "Tải lên (${_picked.length})"
                              : "Tải lên",
                          style: const TextStyle(
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
