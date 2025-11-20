import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class DriverRegisterScreen extends StatelessWidget {
  const DriverRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Đọc Bằng Lái Xe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const LicenseScannerView(),
    );
  }
}

class LicenseScannerView extends StatefulWidget {
  const LicenseScannerView({super.key});

  @override
  State<LicenseScannerView> createState() => _LicenseScannerViewState();
}

class _LicenseScannerViewState extends State<LicenseScannerView> {
  File? _selectedImage;
  bool _isScanning = false;

  // Các controller
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();

  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  @override
  void dispose() {
    _textRecognizer.close();
    _idController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _classController.dispose();
    _addressController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _clearFields();
      });
      _processImage();
    }
  }

  void _clearFields() {
    _idController.clear();
    _nameController.clear();
    _dobController.clear();
    _classController.clear();
    _addressController.clear();
    _expiryController.clear();
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isScanning = true;
    });

    try {
      final inputImage = InputImage.fromFile(_selectedImage!);
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );
      _extractLicenseInfo(recognizedText);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  String _cleanAddress(String text) {
    String result = text;

    // QUY TẮC 1: Sửa lỗi ký tự "l" (L thường) bị đọc nhầm thành số "1"
    // Nếu chữ "l" nằm cạnh một con số, khả năng cao nó là số 1.
    // Ví dụ: "Cal3" -> "Ca13", "Q1" -> "Q1" (đúng), "Phuong 1" -> "Phuong 1"
    result = result.replaceAllMapped(
      RegExp(r'(?<=[a-zA-Z])l(?=\d)|(?<=\d)l(?=\d)'),
      (match) => "1",
    );

    // QUY TẮC 2: Sửa lỗi "De" + Số -> "Dc" + Số
    // "Dc" (Địa chỉ/Dãy) hay bị đọc nhầm thành "De".
    // Ví dụ: "De8" -> "Dc8", "De13" -> "Dc13"
    result = result.replaceAllMapped(RegExp(r'\bDe(?=\d)'), (match) => "Dc");

    // QUY TẮC 3: Sửa lỗi dấu "&" bị đọc nhầm từ số "8"
    // Trong địa chỉ rất hiếm khi dùng dấu &, mà thường là số 8.
    result = result.replaceAll("&", "8");

    // QUY TẮC 4: Sửa lỗi "CC" -> "C/C" (Chung cư)
    // Chỉ sửa khi nó đứng riêng lẻ (Word boundary)
    result = result.replaceAll(RegExp(r'\bCC\b'), "C/C");

    // QUY TẮC 5: Xóa các ký tự rác ở đầu câu (. , -) do cắt ảnh
    while (result.isNotEmpty &&
        (result.startsWith('.') ||
            result.startsWith(',') ||
            result.startsWith('-') ||
            result.startsWith(' '))) {
      result = result.substring(1);
    }

    return result.trim();
  }

  // === HÀM XỬ LÝ LOGIC MỚI: QUÉT XUNG QUANH (i-1, i, i+1) ===
  void _extractLicenseInfo(RecognizedText text) {
    // 1. Lấy tất cả các dòng text
    List<TextLine> rawLines = [];
    for (TextBlock block in text.blocks) {
      rawLines.addAll(block.lines);
    }

    // 2. Sắp xếp theo tọa độ Y (trên xuống dưới)
    rawLines.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

    List<String> lines = rawLines.map((e) => e.text.trim()).toList();

    // Biến cờ
    bool foundName = false;
    bool foundDob = false;
    bool foundClass = false;
    bool foundExpiry = false;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      String lowerLine = line.toLowerCase();

      // --- 1. TÌM SỐ GPLX ---
      String numbersOnly = line.replaceAll(RegExp(r'[^0-9]'), '');
      if (numbersOnly.length > 6) {
        if (lowerLine.contains("số") ||
            lowerLine.contains("no") ||
            line.startsWith(numbersOnly)) {
          _idController.text = numbersOnly;
        }
      }

      // --- 2. TÌM HỌ TÊN (Chiến thuật quét 3 dòng) ---
      if (!foundName &&
          (lowerLine.contains("họ tên") || lowerLine.contains("full name"))) {
        // Kiểm tra dòng TRƯỚC, dòng HIỆN TẠI, và dòng SAU
        List<int> candidatesIndex = [i, i + 1, i - 1];

        for (int index in candidatesIndex) {
          if (index >= 0 && index < lines.length) {
            String txt = lines[index];
            // Xóa bỏ từ khóa nhãn nếu có
            String cleanTxt = txt
                .replaceAll(
                  RegExp(r'họ tên|full name|[:]', caseSensitive: false),
                  '',
                )
                .trim();

            // ĐIỀU KIỆN CHỌN TÊN:
            // 1. Không chứa số (Quan trọng nhất)
            // 2. Độ dài > 2
            // 3. Không chứa từ khóa khác (Ngày sinh, Quốc tịch)
            if (cleanTxt.length > 2 &&
                !RegExp(r'[0-9]').hasMatch(cleanTxt) &&
                !cleanTxt.toLowerCase().contains("ngày") &&
                !cleanTxt.toLowerCase().contains("birth") &&
                !cleanTxt.toLowerCase().contains("quốc tịch")) {
              _nameController.text = cleanTxt
                  .toUpperCase(); // Ép về in hoa cho đẹp
              foundName = true;
              break; // Tìm thấy rồi thì dừng vòng lặp con
            }
          }
        }
      }

      // --- 3. TÌM NGÀY SINH (Chiến thuật quét 3 dòng) ---
      if (!foundDob &&
          (lowerLine.contains("ngày sinh") || lowerLine.contains("birth"))) {
        RegExp dateReg = RegExp(
          r'(\d{2})\s*[\/.-]\s*(\d{2})\s*[\/.-]\s*(\d{4})',
        );

        List<int> candidatesIndex = [i, i + 1, i - 1];
        for (int index in candidatesIndex) {
          if (index >= 0 && index < lines.length) {
            Match? match = dateReg.firstMatch(lines[index]);
            if (match != null) {
              _dobController.text = match
                  .group(0)!
                  .replaceAll(' ', ''); // Xóa khoảng trắng thừa
              foundDob = true;
              break;
            }
          }
        }
      }

      // --- 4. TÌM ĐỊA CHỈ ---
      if (lowerLine.contains("nơi cư trú") || lowerLine.contains("address")) {
        String address = "";

        String inlineAddr = line;

        // Cách 1: Nếu có dấu hai chấm (:), cắt bỏ phần trước dấu hai chấm
        if (inlineAddr.contains(':')) {
          inlineAddr = inlineAddr.split(':').last.trim();
        }

        // Cách 2: Dùng Regex mạnh để xóa các từ khóa (kể cả không dấu hoặc sai dấu)
        // (nơi|noi): Bắt chữ Nơi hoặc Noi
        // (cư|cu): Bắt chữ Cư hoặc Cu
        // (trú|tru): Bắt chữ Trú hoặc Tru
        inlineAddr = inlineAddr
            .replaceAll(
              RegExp(
                r'(nơi|noi)\s*(cư|cu)\s*(trú|tru|trù)|address|[:\/]',
                caseSensitive: false,
              ),
              '',
            )
            .trim();

        if (inlineAddr.length > 1) address += "$inlineAddr, ";

        // Lấy các dòng tiếp theo
        for (int k = i + 1; k < lines.length; k++) {
          String currentLine = lines[k].trim();
          String lowerK = currentLine.toLowerCase();

          if (lowerK.contains("có giá trị") ||
              lowerK.contains("expires") ||
              lowerK.contains("giám đốc") ||
              lowerK.contains("trưởng phòng") ||
              lowerK.contains("sở gtvt") ||
              (lowerK.startsWith("tp") &&
                  (lowerK.contains("ngày") || lowerK.contains("năm"))) ||
              (lowerK.contains("ngày") &&
                  lowerK.contains("tháng") &&
                  lowerK.contains("năm"))) {
            break;
          }
          address += "$currentLine, ";
        }

        if (address.endsWith(", ")) {
          address = address.substring(0, address.length - 2);
        }

        // Gọi hàm làm sạch tổng quát
        _addressController.text = _cleanAddress(address);
      }

      // --- 5. TÌM HẠNG ---
      if (!foundClass &&
          (lowerLine.contains("hạng") || lowerLine.contains("class"))) {
        RegExp classReg = RegExp(
          r'\b(C1E|D1E|D2E|BE|CE|DE|A1|B1|C1|D1|D2|A|B|C|D)\b',
        );
        // Tìm dòng hiện tại và dòng kế tiếp
        String target = line;
        if (i + 1 < lines.length) target += " ${lines[i + 1]}";

        Match? match = classReg.firstMatch(target);
        if (match != null) {
          _classController.text = match.group(0)!;
          foundClass = true;
        }
      }

      // --- 6. TÌM HẠN SỬ DỤNG ---
      if (!foundExpiry &&
          (lowerLine.contains("có giá trị") || lowerLine.contains("expires"))) {
        if (lowerLine.contains("không thời hạn") ||
            lowerLine.contains("unlimited")) {
          _expiryController.text = "Không thời hạn";
          foundExpiry = true;
        } else {
          RegExp dateReg = RegExp(
            r'(\d{2})\s*[\/.-]\s*(\d{2})\s*[\/.-]\s*(\d{4})',
          );
          Match? match = dateReg.firstMatch(line);
          if (match != null) {
            _expiryController.text = match.group(0)!.replaceAll(' ', '');
            foundExpiry = true;
          } else if (i + 1 < lines.length) {
            Match? matchNext = dateReg.firstMatch(lines[i + 1]);
            if (matchNext != null) {
              _expiryController.text = matchNext.group(0)!.replaceAll(' ', '');
              foundExpiry = true;
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Bằng Lái Xe')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _showImageSourceDialog(),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                          Text("Chạm để chụp bằng lái"),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isScanning) const LinearProgressIndicator(),
            const SizedBox(height: 20),
            _buildTextField("Số GPLX", _idController),
            _buildTextField("Họ và tên", _nameController),
            _buildTextField("Ngày sinh", _dobController),
            _buildTextField("Hạng bằng", _classController),
            _buildTextField("Có giá trị đến", _expiryController),
            _buildTextField("Nơi cư trú", _addressController, maxLines: 3),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showImageSourceDialog(),
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Thư viện ảnh'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Chụp ảnh mới'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
