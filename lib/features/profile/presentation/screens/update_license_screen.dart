import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:summercamp/core/config/constants.dart';
import 'package:summercamp/core/config/driver_theme.dart';
import 'package:summercamp/core/widgets/custom_dialog.dart';
import 'package:summercamp/features/auth/domain/entities/user.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';

class UpdateLicenseScreen extends StatefulWidget {
  final User user;
  const UpdateLicenseScreen({super.key, required this.user});

  @override
  State<UpdateLicenseScreen> createState() => _UpdateLicenseScreenState();
}

class _UpdateLicenseScreenState extends State<UpdateLicenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final String _apiKey = AppConstants.geminiApiKey;

  late TextEditingController _licenseNumberController;
  late TextEditingController _licenseExpiryController;
  late TextEditingController _addressController;

  File? _licenseImage;
  bool _isScanning = false;
  String? _apiExpiry;

  @override
  void initState() {
    super.initState();
    _licenseNumberController = TextEditingController(text: "");
    _licenseExpiryController = TextEditingController(text: "");
    _addressController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _licenseNumberController.dispose();
    _licenseExpiryController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 90);

    if (pickedFile != null) {
      setState(() {
        _licenseImage = File(pickedFile.path);
        _isScanning = true;
      });
      await _processImageWithGemini();
    }
  }

  Future<void> _processImageWithGemini() async {
    if (_licenseImage == null) return;

    try {
      final imageBytes = await _licenseImage!.readAsBytes();
      final imagePart = DataPart('image/jpeg', imageBytes);

      final promptText = """
        Bạn là hệ thống trích xuất dữ liệu Giấy Phép Lái Xe (GPLX) Việt Nam.
        Hãy trích xuất thông tin từ ảnh này và trả về JSON thuần túy (không markdown) theo cấu trúc:
        {
          "license_number": "Số giấy phép (chỉ lấy số)",
          "address": "Nơi cư trú (Viết liền 1 dòng, sửa lỗi chính tả)",
          "expiry_date": "Có giá trị đến (dd/MM/yyyy) hoặc 'Không thời hạn'"
        }
        Nếu không phải ảnh bằng lái xe, trả về: {"error": "invalid_image"}
      """;

      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(temperature: 0.0),
      );

      final response = await model.generateContent([
        Content.multi([TextPart(promptText), imagePart]),
      ]);

      if (response.text != null) {
        String cleanJson = response.text!
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        final Map<String, dynamic> data = jsonDecode(cleanJson);

        if (data.containsKey('error')) {
          throw Exception("Ảnh không hợp lệ. Vui lòng chụp đúng Bằng Lái Xe.");
        }

        _fillFormWithAiData(data);
      }
    } catch (e) {
      if (mounted) {
        showCustomDialog(
          context,
          title: "Lỗi quét ảnh",
          message: e.toString(),
          type: DialogType.error,
        );
        setState(() => _licenseImage = null);
      }
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  void _fillFormWithAiData(Map<String, dynamic> data) {
    setState(() {
      if (data['license_number'] != null) {
        _licenseNumberController.text = data['license_number'].toString();
      }
      if (data['address'] != null) {
        _addressController.text = data['address'].toString().replaceAll(
          '\n',
          ', ',
        );
      }
      if (data['expiry_date'] != null) {
        String expRaw = data['expiry_date'].toString();
        _licenseExpiryController.text = expRaw;

        if (expRaw.toLowerCase().contains("không")) {
          _apiExpiry = "2099-12-31";
        } else {
          _apiExpiry = _formatDateForApi(expRaw);
        }
      }
    });
    showCustomDialog(
      context,
      title: "Thành công",
      message: "Đã trích xuất thông tin!",
      type: DialogType.success,
    );
  }

  String? _formatDateForApi(String dateStr) {
    try {
      dateStr = dateStr.replaceAll('.', '/').replaceAll('-', '/');
      final format = DateFormat('dd/MM/yyyy');
      final date = format.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return null;
    }
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    if (_apiExpiry == null && _licenseExpiryController.text.isNotEmpty) {
      _apiExpiry = _formatDateForApi(_licenseExpiryController.text);
      if (_apiExpiry == null &&
          !_licenseExpiryController.text.toLowerCase().contains("không")) {
        showCustomDialog(
          context,
          title: "Lỗi",
          message: "Định dạng ngày hết hạn sai (dd/MM/yyyy)",
          type: DialogType.warning,
        );
        return;
      }
      if (_licenseExpiryController.text.toLowerCase().contains("không")) {
        _apiExpiry = "2099-12-31";
      }
    }

    final provider = context.read<AuthProvider>();

    try {
      await provider.updateDriverLicense(
        licenseNumber: _licenseNumberController.text,
        licenseExpiry: _apiExpiry ?? "2099-12-31",
        driverAddress: _addressController.text,
        newLicenseImage: _licenseImage,
      );

      if (mounted) {
        showCustomDialog(
          context,
          title: "Thành công",
          message: "Cập nhật thông tin bằng lái thành công!",
          type: DialogType.success,
          onConfirm: () => Navigator.pop(context),
        );
      }
    } catch (e) {
      if (mounted) {
        showCustomDialog(
          context,
          title: "Lỗi cập nhật",
          message: e.toString(),
          type: DialogType.error,
        );
      }
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Thư viện ảnh'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Chụp ảnh mới'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cập nhật Bằng lái",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: DriverTheme.driverPrimary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ảnh Bằng lái mới (Scan để điền)",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _showImageSourceSheet,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                    image: _licenseImage != null
                        ? DecorationImage(
                            image: FileImage(_licenseImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _licenseImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Chạm để tải ảnh",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
              if (_isScanning)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      CircularProgressIndicator(strokeWidth: 2),
                      SizedBox(width: 10),
                      Text(
                        "AI đang đọc thông tin...",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),
              const Text(
                "Thông tin trích xuất",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),

              _buildTextField(
                controller: _licenseNumberController,
                label: "Số GPLX",
                icon: Icons.credit_card,
              ),
              _buildTextField(
                controller: _licenseExpiryController,
                label: "Ngày hết hạn (dd/MM/yyyy)",
                icon: Icons.event_busy,
              ),
              _buildTextField(
                controller: _addressController,
                label: "Địa chỉ trên bằng lái",
                icon: Icons.home,
                maxLines: 3,
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: (isLoading || _isScanning) ? null : _submitUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DriverTheme.driverAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Cập nhật thông tin",
                          style: TextStyle(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontFamily: "Quicksand"),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: DriverTheme.driverPrimary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (val) =>
            (val == null || val.isEmpty) ? "Vui lòng nhập $label" : null,
      ),
    );
  }
}
