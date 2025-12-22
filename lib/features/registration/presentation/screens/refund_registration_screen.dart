import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/features/auth/presentation/state/auth_provider.dart';
import 'package:summercamp/features/registration/presentation/screens/create_bank_user_screen.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';

class RefundRegistrationScreen extends StatefulWidget {
  final int registrationId;

  const RefundRegistrationScreen({super.key, required this.registrationId});

  @override
  State<RefundRegistrationScreen> createState() =>
      _RefundRegistrationScreenState();
}

class _RefundRegistrationScreenState extends State<RefundRegistrationScreen> {
  int? _selectedBankUserId;
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadBankUsers();
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitRefund() async {
    if (_selectedBankUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng chọn tài khoản ngân hàng nhận tiền"),
        ),
      );
      return;
    }
    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập lý do hoàn tiền")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<RegistrationProvider>().refundRegistration(
        registrationId: widget.registrationId,
        bankUserId: _selectedBankUserId!,
        reason: _reasonController.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi hoàn tiền: $e"),
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

  Future<void> _navigateToCreateBankScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateBankUserScreen()),
    );

    if (result == true && mounted) {
      context.read<AuthProvider>().loadBankUsers();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thêm tài khoản thành công"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bankUsers = context.watch<AuthProvider>().bankUsers;

    if (_selectedBankUserId == null && bankUsers.isNotEmpty) {
      try {
        final primaryBank = bankUsers.firstWhere((bank) => bank.isPrimary);
        _selectedBankUserId = primaryBank.bankUserId;
      } catch (_) {
        // _selectedBankUserId = bankUsers.first.bankUserId;
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppTheme.summerPrimary),
        title: const Text(
          "Yêu cầu hoàn tiền",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Chọn tài khoản nhận tiền:",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            if (bankUsers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    "Chưa có tài khoản ngân hàng. Vui lòng thêm mới.",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bankUsers.length,
                itemBuilder: (context, index) {
                  final bank = bankUsers[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RadioListTile<int>(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Text(
                        "${bank.bankName} - ${bank.bankNumber}",
                        style: const TextStyle(
                          fontFamily: "Quicksand",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        bank.bankCode,
                        style: const TextStyle(fontSize: 12),
                      ),
                      value: bank.bankUserId,
                      // groupValue: _selectedBankUserId,
                      // onChanged: (val) {
                      //   setState(() => _selectedBankUserId = val);
                      // },
                      activeColor: AppTheme.summerAccent,
                      secondary: bank.isPrimary
                          ? const Chip(
                              label: Text(
                                "Mặc định",
                                style: TextStyle(fontSize: 10),
                              ),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            )
                          : null,
                    ),
                  );
                },
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _navigateToCreateBankScreen,
                icon: const Icon(Icons.add, size: 18),
                label: const Text("Thêm tài khoản ngân hàng"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.summerAccent,
                  side: const BorderSide(color: AppTheme.summerAccent),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Lý do hoàn tiền:",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Nhập lý do yêu cầu hoàn tiền...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: const TextStyle(fontFamily: "Quicksand"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitRefund,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.summerAccent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  "Gửi yêu cầu hoàn tiền",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
