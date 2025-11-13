import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/core/utils/price_formatter.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';
import 'package:summercamp/features/camper/domain/entities/camper.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_failure_screen.dart';
import 'package:summercamp/features/registration/presentation/screens/registration_success_screen.dart';
import 'package:summercamp/features/registration/presentation/state/registration_provider.dart';

class RegistrationConfirmScreen extends StatefulWidget {
  final Camp camp;
  final List<Camper> campers;
  final int paymentId;
  final int? appliedPromotionId;
  final String? promotionCode;
  final String? note;

  const RegistrationConfirmScreen({
    super.key,
    required this.camp,
    required this.campers,
    required this.paymentId,
    this.appliedPromotionId,
    this.promotionCode,
    this.note,
  });

  @override
  State<RegistrationConfirmScreen> createState() =>
      _RegistrationConfirmScreenState();
}

class _RegistrationConfirmScreenState extends State<RegistrationConfirmScreen> {
  bool _isLoading = false;

  Future<void> _handleRegistration() async {
    setState(() {
      _isLoading = true;
    });

    final provider = context.read<RegistrationProvider>();
    final navigator = Navigator.of(context);

    try {
      await provider.createRegistration(
        campId: widget.camp.campId,
        campers: widget.campers,
        appliedPromotionId: widget.appliedPromotionId,
        note: widget.note,
      );

      if (mounted) {
        navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const RegistrationSuccessScreen()),
        );
      }
      // final paymentUrl = await provider.createRegistration(
      //   campId: widget.camp.campId,
      //   campers: widget.campers,
      //   appliedPromotionId: widget.promotionCode,
      //   note: widget.note,
      // );

      // print("URL nhận được tại UI: $paymentUrl");

      // final uri = Uri.tryParse(paymentUrl);

      // if (uri != null && await canLaunchUrl(uri)) {
      //   await launchUrl(uri, mode: LaunchMode.externalApplication);
      //   if (mounted) {
      //     Navigator.of(context).popUntil((route) => route.isFirst);
      //   }
      // } else {
      //   throw Exception('Không thể mở đường dẫn thanh toán: $paymentUrl');
      // }
      // } catch (e) {
      //   if (mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text('Đã xảy ra lỗi: ${e.toString()}'),
      //         backgroundColor: Colors.red,
      //       ),
      //     );
      //   }
      // } finally {
      //   if (mounted) {
      //     setState(() {
      //       _isLoading = false;
      //     });
      //   }
      // }
    } catch (e) {
      if (mounted) {
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                RegistrationFailedScreen(errorMessage: e.toString()),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final String paymentMethod = switch (widget.paymentId) {
      1 => "Chuyển khoản ngân hàng",
      _ => "Khác",
    };

    final double finalPricePerCamper = widget.camp.discountedPrice;
    final bool hasPromotion = widget.camp.promotion != null;
    final double totalPrice = finalPricePerCamper * widget.campers.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Xác nhận đăng ký",
          style: textTheme.titleLarge?.copyWith(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.summerPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.camp.name,
                      style: textTheme.titleLarge?.copyWith(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.bold,
                        color: AppTheme.summerAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${DateFormatter.formatFromString(widget.camp.startDate)} - ${DateFormatter.formatFromString(widget.camp.endDate)}",
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
                        const Icon(Icons.attach_money, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          "Giá: ${PriceFormatter.format(finalPricePerCamper)} / Camper",
                          style: textTheme.bodyMedium?.copyWith(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        if (hasPromotion)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "(${PriceFormatter.format(widget.camp.price)})",
                              style: textTheme.bodySmall?.copyWith(
                                fontFamily: "Quicksand",
                                color: Colors.grey,
                                fontSize: 15,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.grey,
                              ),
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
              "Camper đã chọn",
              style: textTheme.titleMedium?.copyWith(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
                color: AppTheme.summerPrimary,
              ),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3 / 2,
              ),
              itemCount: widget.campers.length,
              itemBuilder: (context, index) {
                final c = widget.campers[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppTheme.summerPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.summerPrimary, width: 1),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(
                          "assets/images/default_avatar.png",
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        c.camperName,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold,
                          color: AppTheme.summerPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Text(
              "Thông tin thanh toán",
              style: textTheme.titleMedium?.copyWith(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.bold,
                color: AppTheme.summerPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.payment, color: Colors.teal),
                        const SizedBox(width: 8),
                        Text(
                          paymentMethod,
                          style: textTheme.bodyMedium?.copyWith(
                            fontFamily: "Quicksand",
                          ),
                        ),
                      ],
                    ),

                    if (widget.promotionCode != null &&
                        widget.promotionCode!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.discount, color: Colors.deepOrange),
                          const SizedBox(width: 8),
                          Text(
                            "Mã khuyến mãi: ${widget.promotionCode}",
                            style: textTheme.bodyMedium?.copyWith(
                              fontFamily: "Quicksand",
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (widget.note != null && widget.note!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.note_alt_outlined,
                            color: Colors.blueGrey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Ghi chú: ${widget.note}",
                              style: textTheme.bodyMedium?.copyWith(
                                fontFamily: "Quicksand",
                                color: Colors.blueGrey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(
                          Icons.summarize,
                          color: AppTheme.summerAccent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Tổng tiền: ${PriceFormatter.format(totalPrice)}",
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

            const SizedBox(height: 30),

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
                onPressed: _isLoading ? null : _handleRegistration,
                icon: _isLoading
                    ? Container()
                    : const Icon(Icons.check_circle, size: 22),
                label: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        "Xác nhận thông tin",
                        style: textTheme.titleMedium?.copyWith(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold,
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
