import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/config/constants.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:intl/intl.dart';

class DriverRegisterScreen extends StatefulWidget {
  const DriverRegisterScreen({super.key});

  @override
  State<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final String _apiKey = AppConstants.geminiApiKey;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dobController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _licenseExpiryController = TextEditingController();
  final _addressController = TextEditingController();

  String? _apiDob;
  String? _apiExpiry;

  bool _obscurePassword = true;
  bool _isLoading = false;
  File? _licenseImage;
  bool _isScanning = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    _licenseNumberController.dispose();
    _licenseExpiryController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // scan image using gemini AI
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 100,
    );

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
        Bạn là AI hỗ trợ nhập liệu. Hãy trích xuất thông tin từ Bằng Lái Xe này để điền vào form đăng ký.
        
        Yêu cầu quan trọng:
        1. Sửa lỗi chính tả tiếng Việt (ví dụ: Nguyền -> Nguyễn, So -> Số).
        2. Phân biệt số 0 và chữ O chuẩn xác.
        3. Tách riêng Họ và Tên.
        4. Trả về JSON thuần túy (không markdown) theo cấu trúc sau:
        {
          "license_number": "Số giấy phép lái xe (chỉ lấy số)",
          "first_name": "Họ và Tên đệm (Ví dụ: NGUYỄN VĂN)",
          "last_name": "Tên (Ví dụ: A)",
          "dob": "Ngày sinh (định dạng dd/MM/yyyy)",
          "address": "Nơi cư trú / Địa chỉ đầy đủ (Viết liền 1 dòng, không xuống dòng)",
          "expiry_date": "Ngày hết hạn (định dạng dd/MM/yyyy) hoặc 'Không thời hạn'"
        }
      """;

      final List<String> modelsToTry = [
        'gemini-2.0-flash',
        'gemini-2.0-pro',
        'gemini-pro-vision',
      ];

      bool isSuccess = false;

      for (String modelName in modelsToTry) {
        if (!mounted) break;
        try {
          final model = GenerativeModel(
            model: modelName,
            apiKey: _apiKey,
            generationConfig: GenerationConfig(temperature: 0.0),
          );

          final response = await model.generateContent([
            Content.multi([TextPart(promptText), imagePart]),
          ]);

          if (response.text != null && response.text!.isNotEmpty) {
            // clean json response
            String cleanJson = response.text!
                .replaceAll('```json', '')
                .replaceAll('```', '')
                .trim();

            final Map<String, dynamic> data = jsonDecode(cleanJson);

            // fill data into form
            _fillFormWithAiData(data);

            isSuccess = true;
            break;
          }
        } catch (e) {
          print("Model $modelName thất bại: $e");
          continue;
        }
      }

      if (!isSuccess && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể quét thông tin. Vui lòng nhập tay.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi kết nối AI: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }

  // fill data into form
  void _fillFormWithAiData(Map<String, dynamic> data) {
    setState(() {
      if (data['license_number'] != null) {
        _licenseNumberController.text = data['license_number'].toString();
      }

      if (data['first_name'] != null) {
        _firstNameController.text = data['first_name'].toString();
      }

      if (data['last_name'] != null) {
        _lastNameController.text = data['last_name'].toString();
      }

      if (data['address'] != null) {
        String rawAddr = data['address'].toString();
        String cleanAddr = rawAddr.replaceAll('\n', ', ');
        cleanAddr = cleanAddr.replaceAll(RegExp(r'\s+'), ' ').trim();
        cleanAddr = cleanAddr.replaceAll(RegExp(r',\s*,'), ',');

        _addressController.text = cleanAddr;
      }

      if (data['dob'] != null) {
        String dobRaw = data['dob'].toString();
        _dobController.text = dobRaw;
        _apiDob = _formatDateForApi(dobRaw);
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã điền thông tin từ ảnh thành công!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String? _formatDateForApi(String dateStr) {
    try {
      dateStr = dateStr
          .replaceAll('.', '/')
          .replaceAll('-', '/')
          .replaceAll(' ', '');
      final format = DateFormat('dd/MM/yyyy');
      final date = format.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return null;
    }
  }

  Future<void> _uploadLicenseWithRetry(String token, File imageFile) async {
    bool uploadSuccess = false;
    int retryCount = 0;

    while (!uploadSuccess) {
      try {
        final provider = context.read<AuthProvider>();
        // Gọi hàm upload mới trong provider
        await provider.uploadLicense(imageFile, token);
        uploadSuccess = true;
        print("Upload license thành công!");
      } catch (e) {
        retryCount++;
        print("Upload thất bại ($retryCount): $e. Thử lại sau 2s...");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Lỗi upload ảnh ($retryCount). Đang thử lại..."),
              duration: const Duration(milliseconds: 1000),
            ),
          );
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  Future<void> _submitRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_apiDob == null && _dobController.text.isNotEmpty) {
      _apiDob = _formatDateForApi(_dobController.text);
    }
    if (_apiExpiry == null && _licenseExpiryController.text.isNotEmpty) {
      _apiExpiry = _formatDateForApi(_licenseExpiryController.text);
    }

    if (_apiDob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập ngày sinh đúng định dạng dd/MM/yyyy"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final provider = context.read<AuthProvider>();
    final navigator = Navigator.of(context);

    try {
      final oneTimeToken = await provider.driverRegister(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
        dob: _apiDob!,
        licenseNumber: _licenseNumberController.text,
        licenseExpiry: _apiExpiry ?? "2099-12-31",
        driverAddress: _addressController.text,
      );

      if (oneTimeToken == null) {
        throw Exception(
          "Đăng ký thành công nhưng không nhận được token upload ảnh.",
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đang chuẩn bị upload ảnh...")),
        );
      }
      await Future.delayed(const Duration(seconds: 3));

      await _uploadLicenseWithRetry(oneTimeToken, _licenseImage!);

      if (mounted) {
        navigator.pushNamed(
          AppRoutes.verifyOTP,
          arguments: _emailController.text.trim(),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Đăng ký thất bại: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Đăng ký Tài xế",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.summerPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "1. Thông tin Bằng lái xe (Scan)",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.summerPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _showImageSourceSheet,
                  child: Container(
                    height: 180,
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
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Chạm để chụp/tải ảnh bằng lái",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontFamily: "Quicksand",
                                ),
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
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "AI đang phân tích & điền form...",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                _buildTextField(
                  controller: _licenseNumberController,
                  label: "Số GPLX",
                  icon: Icons.credit_card,
                  readOnly: true,
                ),

                const SizedBox(width: 12),

                _buildTextField(
                  controller: _licenseExpiryController,
                  label: "Hết hạn",
                  icon: Icons.event_busy,
                  readOnly: true,
                ),

                const SizedBox(width: 12),

                _buildTextField(
                  controller: _addressController,
                  label: "Địa chỉ thường trú",
                  icon: Icons.home,
                  maxLines: 3,
                  readOnly: true,
                ),

                const SizedBox(height: 24),

                Text(
                  "2. Thông tin Tài khoản & Cá nhân",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.summerPrimary,
                  ),
                ),

                const SizedBox(height: 10),

                _buildTextField(
                  controller: _firstNameController,
                  label: "Họ",
                  icon: Icons.person,
                  readOnly: true,
                ),

                const SizedBox(width: 12),

                _buildTextField(
                  controller: _lastNameController,
                  label: "Tên",
                  icon: Icons.person_outline,
                  readOnly: true,
                ),

                const SizedBox(width: 12),

                _buildTextField(
                  controller: _dobController,
                  label: "Ngày sinh",
                  icon: Icons.cake,
                  readOnly: true,
                ),
                _buildTextField(
                  controller: _emailController,
                  label: "Email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildTextField(
                  controller: _phoneController,
                  label: "Số điện thoại",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontFamily: "Quicksand"),
                    decoration: InputDecoration(
                      labelText: "Mật khẩu",
                      labelStyle: const TextStyle(fontFamily: "Quicksand"),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: AppTheme.summerPrimary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (val) => (val == null || val.length < 6)
                        ? "Mật khẩu tối thiểu 6 ký tự"
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.summerPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Đăng Ký",
                            style: TextStyle(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(fontFamily: "Quicksand"),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: "Quicksand"),
          prefixIcon: Icon(icon, color: AppTheme.summerPrimary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: readOnly ? Colors.grey[100] : Colors.white,
        ),
        validator:
            validator ??
            (val) =>
                (val == null || val.isEmpty) ? "Vui lòng nhập $label" : null,
      ),
    );
  }
}
