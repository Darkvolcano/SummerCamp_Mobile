import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/core/utils/price_formatter.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
// import 'package:summercamp/features/registration/domain/entities/registration.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_confirm_screen.dart';
// import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';
import 'package:summercamp/features/camper/presentation/state/camper_provider.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';

class RegistrationFormScreen extends StatefulWidget {
  final Camp camp;
  const RegistrationFormScreen({super.key, required this.camp});

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  final _promotionCodeController = TextEditingController();
  int _selectedPaymentId = 1;
  final _noteController = TextEditingController();
  final List<Camper> _selectedCampers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CamperProvider>().loadCampers();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final provider = context.read<RegistrationProvider>();
    final camperProvider = context.watch<CamperProvider>();
    final campers = camperProvider.campers;
    final camp = widget.camp;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Đăng ký trại",
          style: textTheme.titleMedium?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
      ),
      body: camperProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            camp.name,
                            style: textTheme.titleLarge?.copyWith(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.bold,
                              color: AppTheme.summerAccent,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            camp.description,
                            style: textTheme.bodyMedium?.copyWith(
                              fontFamily: "Quicksand",
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${DateFormatter.formatFromString(camp.startDate)} - ${DateFormatter.formatFromString(camp.endDate)}",
                                style: textTheme.bodyMedium?.copyWith(
                                  fontFamily: "Quicksand",
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.attach_money,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                PriceFormatter.format(camp.price),
                                style: textTheme.titleMedium?.copyWith(
                                  fontFamily: "Quicksand",
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.summerAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Chọn Camper",
                    style: textTheme.titleMedium?.copyWith(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: campers.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          // childAspectRatio: 0.85,
                        ),
                    itemBuilder: (context, index) {
                      final camper = campers[index];
                      final isSelected = _selectedCampers.any(
                        (c) => c.camperId == camper.camperId,
                      );

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedCampers.removeWhere(
                                (c) => c.camperId == camper.camperId,
                              );
                            } else {
                              _selectedCampers.add(camper);
                            }
                          });
                        },
                        child: Card(
                          elevation: isSelected ? 6 : 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isSelected
                                  ? AppTheme.summerAccent
                                  : Colors.grey.shade300,
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 36,
                                      backgroundImage: const AssetImage(
                                        "assets/images/default_avatar.png",
                                      ),
                                      backgroundColor: AppTheme.summerPrimary
                                          .withValues(alpha: 0.2),
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor:
                                              AppTheme.summerAccent,
                                          child: const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  camper.fullName,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontFamily: "Quicksand",
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? AppTheme.summerAccent
                                            : Colors.grey.shade800,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Camper",
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontFamily: "Quicksand",
                                        color: Colors.grey.shade600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Phương thức thanh toán",
                    style: textTheme.titleMedium?.copyWith(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  RadioGroup<int>(
                    groupValue: _selectedPaymentId,
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedPaymentId = val);
                    },
                    child: Column(
                      children: [
                        RadioMenuButton<int>(
                          value: 1,
                          groupValue: _selectedPaymentId,
                          onChanged: (val) =>
                              setState(() => _selectedPaymentId = val!),
                          child: const Text(
                            "Chuyển khoản ngân hàng",
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _promotionCodeController,
                    style: TextStyle(
                      color: AppTheme.summerPrimary,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: "Mã khuyến mãi",
                      labelStyle: TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(Icons.discount),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextField(
                    controller: _noteController,
                    style: const TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: "Ghi chú (Tùy chọn)",
                      labelStyle: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                      ),
                      prefixIcon: const Icon(Icons.note_alt_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.summerAccent,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.summerAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // onPressed: () {
                      //   if (_selectedCampers.isEmpty) {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //         content: Text("Vui lòng chọn ít nhất 1 Camper"),
                      //       ),
                      //     );
                      //     return;
                      //   }

                      //   for (final camper in _selectedCampers) {
                      //     final r = Registration(
                      //       registrationId:
                      //           DateTime.now().millisecondsSinceEpoch,
                      //       campId: camp.campId,
                      //       camperId: camper.camperId,
                      //       paymentId: _selectedPaymentId,
                      //       registrationCreateAt: DateTime.now(),
                      //       status: "pending",
                      //       price: camp.price,
                      //       promotionId: null,
                      //       promotionCode: _promotionCodeController.text.isEmpty
                      //           ? null
                      //           : _promotionCodeController.text,
                      //       discount: 0,
                      //       campName: camp.name,
                      //       campDescription: camp.description,
                      //       campPlace: camp.place,
                      //       campStartDate: camp.startDate,
                      //       campEndDate: camp.endDate,
                      //     );

                      //     provider.addRegistration(r);
                      //   }

                      //   Navigator.pop(context);
                      // },
                      onPressed: () {
                        if (_selectedCampers.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Vui lòng chọn ít nhất 1 Camper"),
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegistrationConfirmScreen(
                              camp: camp,
                              campers: _selectedCampers,
                              paymentId: _selectedPaymentId,
                              promotionCode:
                                  _promotionCodeController.text.isEmpty
                                  ? null
                                  : _promotionCodeController.text,
                              note: _noteController.text.isEmpty
                                  ? null
                                  : _noteController.text,
                            ),
                          ),
                        );
                      },

                      icon: const Icon(Icons.assignment),
                      label: Text(
                        "Xem lại & Xác nhận",
                        style: textTheme.titleMedium?.copyWith(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
