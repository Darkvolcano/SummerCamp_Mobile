// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:summercamp/features/camp/domain/entities/camp.dart';
// import 'package:wechat_assets_picker/wechat_assets_picker.dart';
// import 'package:summercamp/core/config/staff_theme.dart';

// class UploadPhotoScreen extends StatefulWidget {
//   final Camp camp;
//   const UploadPhotoScreen({super.key, required this.camp});

//   @override
//   State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
// }

// class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
//   final List<File> _picked = [];

//   Future<void> _pickMultiImages() async {
//     final List<AssetEntity>? result = await AssetPicker.pickAssets(
//       context,
//       pickerConfig: const AssetPickerConfig(
//         requestType: RequestType.image,
//         maxAssets: 20, // max image in 1 pick
//       ),
//     );

//     if (result != null && result.isNotEmpty) {
//       final files = await Future.wait(
//         result.map((e) async {
//           final file = await e.file;
//           return file!;
//         }),
//       );

//       setState(() {
//         _picked.addAll(files);
//       });
//     }
//   }

//   void _removeAt(int index) {
//     setState(() {
//       _picked.removeAt(index);
//     });
//   }

//   Future<void> _uploadPhotos() async {
//     if (_picked.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Vui lòng chọn ít nhất một ảnh")),
//       );
//       return;
//     }

//     // call API multipart
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Giả lập upload ${_picked.length} ảnh thành công"),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Upload Photo - ${widget.camp.name}",
//           style: const TextStyle(
//             fontFamily: "Quicksand",
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: StaffTheme.staffPrimary,
//         foregroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: _picked.isEmpty
//                   ? Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade200,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Center(
//                         child: Icon(
//                           Icons.photo_library,
//                           size: 80,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     )
//                   : GridView.builder(
//                       itemCount: _picked.length,
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             crossAxisSpacing: 8,
//                             mainAxisSpacing: 8,
//                             childAspectRatio: 1,
//                           ),
//                       itemBuilder: (context, index) {
//                         final file = _picked[index];
//                         return Stack(
//                           fit: StackFit.expand,
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.file(file, fit: BoxFit.cover),
//                             ),
//                             Positioned(
//                               top: 6,
//                               right: 6,
//                               child: InkWell(
//                                 onTap: () => _removeAt(index),
//                                 child: Container(
//                                   padding: const EdgeInsets.all(6),
//                                   decoration: const BoxDecoration(
//                                     color: Colors.black54,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: const Icon(
//                                     Icons.close,
//                                     size: 16,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _pickMultiImages,
//                     icon: const Icon(Icons.photo_library),
//                     label: const Text("Chọn ảnh"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: _uploadPhotos,
//                     icon: const Icon(Icons.cloud_upload),
//                     label: const Text("Upload"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: StaffTheme.staffPrimary,
//                       foregroundColor: Colors.white,
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:summercamp/core/config/staff_theme.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadPhotoScreen extends StatefulWidget {
  final Camp camp;
  const UploadPhotoScreen({super.key, required this.camp});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final List<File> _picked = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  int _currentUploadIndex = 0;

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
    if (_picked.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn ít nhất một ảnh")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _currentUploadIndex = 0;
    });

    try {
      final List<String> uploadedUrls = [];
      final storage = FirebaseStorage.instance;

      for (int i = 0; i < _picked.length; i++) {
        setState(() {
          _currentUploadIndex = i + 1;
        });

        final file = _picked[i];
        final fileName =
            'camp_${widget.camp.campId}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final ref = storage.ref().child(
          'camp_photos/${widget.camp.campId}/$fileName',
        );

        // Upload file with progress tracking
        final uploadTask = ref.putFile(file);

        // Listen to upload progress
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          final totalProgress = (i + progress) / _picked.length;

          setState(() {
            _uploadProgress = totalProgress;
          });
        });

        // Wait for upload to complete
        await uploadTask;

        // Get download URL
        final downloadUrl = await ref.getDownloadURL();
        uploadedUrls.add(downloadUrl);
      }

      setState(() {
        _isUploading = false;
      });

      if (!mounted) return;

      // Show success dialog
      _showSuccessDialog(uploadedUrls);

      // Clear picked images
      setState(() {
        _picked.clear();
      });
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi upload: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSuccessDialog(List<String> urls) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            const SizedBox(width: 12),
            const Text(
              'Upload thành công',
              style: TextStyle(fontFamily: "Quicksand"),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đã upload ${urls.length} ảnh lên Firebase Storage',
              style: const TextStyle(fontFamily: "Quicksand"),
            ),
            const SizedBox(height: 12),
            if (urls.isNotEmpty) ...[
              const Text(
                'URL ảnh đầu tiên:',
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  urls.first,
                  style: const TextStyle(fontFamily: "Quicksand", fontSize: 10),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: StaffTheme.staffAccent,
            ),
            child: const Text(
              'OK',
              style: TextStyle(fontFamily: "Quicksand", color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Upload Photo - ${widget.camp.name}",
              style: const TextStyle(
                fontFamily: "Quicksand",
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_library,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Chưa có ảnh nào được chọn',
                                  style: TextStyle(
                                    fontFamily: "Quicksand",
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
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
                        onPressed: _isUploading ? null : _pickMultiImages,
                        icon: const Icon(Icons.photo_library),
                        label: const Text(
                          "Chọn ảnh",
                          style: TextStyle(fontFamily: "Quicksand"),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          disabledBackgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUploading ? null : _uploadPhotos,
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text(
                          "Upload",
                          style: TextStyle(fontFamily: "Quicksand"),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: StaffTheme.staffPrimary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          disabledBackgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Loading Overlay
        if (_isUploading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        StaffTheme.staffAccent,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Đang upload $_currentUploadIndex/${_picked.length} ảnh...',
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        value: _uploadProgress,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          StaffTheme.staffAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(_uploadProgress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 14,
                        color: Colors.grey.shade700,
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
