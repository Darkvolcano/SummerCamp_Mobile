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
  int? _appliedPromotionId;
  String? _appliedPromotionCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CamperProvider>().loadCampers();
    });

    if (widget.camp.promotion != null) {
      _appliedPromotionCode = widget.camp.promotion!.name; // Hiển thị tên KM
      _appliedPromotionId = widget.camp.promotion!.id; // Lưu ID
    }
  }

  @override
  void dispose() {
    _promotionCodeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final provider = context.read<RegistrationProvider>();
    final camperProvider = context.watch<CamperProvider>();
    final campers = camperProvider.campers;
    final camp = widget.camp;
    final textTheme = Theme.of(context).textTheme;

    final double finalPrice = camp.discountedPrice;
    final bool hasPromotion = camp.promotion != null;

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
                              if (hasPromotion)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      PriceFormatter.format(camp.price),
                                      style: textTheme.bodySmall?.copyWith(
                                        fontFamily: "Quicksand",
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.grey[600],
                                      ),
                                    ),

                                    const SizedBox(width: 20),

                                    Text(
                                      PriceFormatter.format(finalPrice),
                                      style: textTheme.titleMedium?.copyWith(
                                        fontFamily: "Quicksand",
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.summerAccent,
                                      ),
                                    ),
                                  ],
                                )
                              else
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
                                  camper.camperName,
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
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedPaymentId = value);
                      }
                    },
                    child: Column(
                      children: [
                        RadioMenuButton<int>(
                          value: 1,
                          groupValue: _selectedPaymentId,
                          onChanged: (value) =>
                              setState(() => _selectedPaymentId = value!),
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

                  // TextField(
                  //   controller: _promotionCodeController,
                  //   style: TextStyle(
                  //     color: AppTheme.summerPrimary,
                  //     fontFamily: "Quicksand",
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  //   decoration: InputDecoration(
                  //     labelText: "Mã khuyến mãi",
                  //     labelStyle: TextStyle(
                  //       fontFamily: 'Quicksand',
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //     prefixIcon: const Icon(Icons.discount),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //   ),
                  // ),
                  if (!hasPromotion)
                    TextField(
                      controller: TextEditingController(
                        text: _appliedPromotionCode ?? "",
                      ),
                      readOnly: true,
                      style: TextStyle(
                        color: AppTheme.summerPrimary,
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        labelText: "Mã khuyến mãi",
                        labelStyle: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: const Icon(Icons.discount),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: _appliedPromotionCode != null,
                        fillColor: _appliedPromotionCode != null
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.white,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.discount, color: Colors.green.shade800),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Đã áp dụng: ${_appliedPromotionCode ?? ''}",
                              style: textTheme.bodyMedium?.copyWith(
                                fontFamily: "Quicksand",
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                        ],
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

                        String? finalPromotionCode;

                        if (hasPromotion) {
                          finalPromotionCode = _appliedPromotionCode;
                        } else if (_promotionCodeController.text.isNotEmpty) {
                          finalPromotionCode = _promotionCodeController.text;
                          _appliedPromotionId = 0;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegistrationConfirmScreen(
                              camp: camp,
                              campers: _selectedCampers,
                              paymentId: _selectedPaymentId,
                              // promotionCode:
                              //     _promotionCodeController.text.isEmpty
                              //     ? null
                              //     : _promotionCodeController.text,
                              appliedPromotionId: _appliedPromotionId,
                              promotionCode: finalPromotionCode,
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
