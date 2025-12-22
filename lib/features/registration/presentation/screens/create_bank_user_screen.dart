import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';

class CreateBankUserScreen extends StatefulWidget {
  const CreateBankUserScreen({super.key});

  @override
  State<CreateBankUserScreen> createState() => _CreateBankUserScreenState();
}

class _CreateBankUserScreenState extends State<CreateBankUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankNumberController = TextEditingController();
  final _bankCodeController = TextEditingController();

  List<_Bank> _banks = [];
  bool _isLoadingBanks = true;
  _Bank? _selectedBank;

  bool _isPrimary = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchBanks();
  }

  @override
  void dispose() {
    _bankNumberController.dispose();
    _bankCodeController.dispose();
    super.dispose();
  }

  Future<void> _fetchBanks() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://api.vietqr.io/v2/banks');
      if (response.data['code'] == '00') {
        final List<dynamic> data = response.data['data'];
        if (mounted) {
          setState(() {
            _banks = data.map((json) => _Bank.fromJson(json)).toList();
            _isLoadingBanks = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingBanks = false);
      }
      debugPrint("Error fetching banks: $e");
    }
  }

  Future<void> _createBank() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBank == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Vui lòng chọn ngân hàng")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final bankName = "${_selectedBank!.shortName} - ${_selectedBank!.name}";

      await context.read<AuthProvider>().createBankUser(
        bankName: bankName,
        bankNumber: _bankNumberController.text.trim(),
        bankCode: _bankCodeController.text.trim(),
        isPrimary: _isPrimary,
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi thêm bank: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppTheme.summerPrimary),
        title: const Text(
          "Thêm tài khoản ngân hàng",
          style: TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: AppTheme.summerPrimary,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFFF5F7F8),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isLoadingBanks
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Autocomplete<_Bank>(
                      displayStringForOption: (bank) =>
                          "${bank.shortName} - ${bank.name}",
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<_Bank>.empty();
                        }
                        return _banks.where((bank) {
                          final query = textEditingValue.text.toLowerCase();
                          return bank.name.toLowerCase().contains(query) ||
                              bank.shortName.toLowerCase().contains(query) ||
                              bank.code.toLowerCase().contains(query);
                        });
                      },
                      onSelected: (_Bank selection) {
                        setState(() {
                          _selectedBank = selection;
                          _bankCodeController.text = selection.code;
                        });
                      },
                      fieldViewBuilder:
                          (
                            context,
                            textEditingController,
                            focusNode,
                            onFieldSubmitted,
                          ) {
                            return TextFormField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              style: const TextStyle(fontFamily: "Quicksand"),
                              decoration: InputDecoration(
                                labelText: "Ngân hàng",
                                hintText: "Nhập tên hoặc mã ngân hàng",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.account_balance),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Vui lòng chọn ngân hàng";
                                }
                                if (_selectedBank == null) {
                                  return "Vui lòng chọn từ danh sách gợi ý";
                                }
                                return null;
                              },
                            );
                          },
                    ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bankCodeController,
                readOnly: true,
                style: const TextStyle(fontFamily: "Quicksand"),
                decoration: InputDecoration(
                  labelText: "Mã ngân hàng",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.code),
                ),
                validator: (v) => v == null || v.isEmpty
                    ? "Vui lòng chọn ngân hàng để lấy mã"
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bankNumberController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontFamily: "Quicksand"),
                decoration: InputDecoration(
                  labelText: "Số tài khoản",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.numbers),
                ),
                validator: (v) => v == null || v.isEmpty
                    ? "Vui lòng nhập số tài khoản"
                    : null,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text(
                  "Đặt làm mặc định",
                  style: TextStyle(fontFamily: "Quicksand"),
                ),
                value: _isPrimary,
                onChanged: (v) => setState(() => _isPrimary = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: AppTheme.summerAccent,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createBank,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.summerAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Lưu thông tin",
                          style: TextStyle(
                            color: Colors.white,
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
}

class _Bank {
  final int id;
  final String name;
  final String code;
  final String shortName;
  final String logo;

  _Bank({
    required this.id,
    required this.name,
    required this.code,
    required this.shortName,
    required this.logo,
  });

  factory _Bank.fromJson(Map<String, dynamic> json) {
    return _Bank(
      id: json['id'],
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      shortName: json['shortName'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}
