import 'package:flutter/material.dart';
import 'package:summercamp/core/config/app_routes.dart';
import 'package:summercamp/core/config/app_theme.dart';
import 'package:summercamp/core/utils/date_formatter.dart';
import 'package:summercamp/core/utils/price_formatter.dart';
import 'package:summercamp/features/camp/domain/entities/camp.dart';

class CampDetailScreen extends StatefulWidget {
  final Camp camp;
  const CampDetailScreen({super.key, required this.camp});

  @override
  State<CampDetailScreen> createState() => _CampDetailScreenState();
}

class _CampDetailScreenState extends State<CampDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _checkRegistrationStatus() {
    try {
      final now = DateTime.now();
      final start = DateTime.parse(
        widget.camp.registrationStartDate.toString(),
      );
      final end = DateTime.parse(widget.camp.registrationEndDate.toString());

      if (now.isBefore(start)) {
        return -1;
      } else if (now.isAfter(end)) {
        return 1;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Widget _buildPriceDetail(BuildContext context) {
    if (widget.camp.promotion == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Giá",
            style: TextStyle(fontFamily: "Quicksand", color: Colors.grey),
          ),
          Text(
            "${PriceFormatter.format(widget.camp.price)}/người",
            style: const TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppTheme.summerAccent,
            ),
          ),
        ],
      );
    }
    final double price = widget.camp.price;
    final double percent = (widget.camp.promotion!.percent as num).toDouble();
    final double maxDiscount = (widget.camp.promotion!.maxDiscountAmount as num)
        .toDouble();
    double discount = price * (percent / 100);
    if (discount > maxDiscount) discount = maxDiscount;
    final double newPrice = price - discount;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${PriceFormatter.format(price)}/người",
          style: const TextStyle(
            fontFamily: "Quicksand",
            color: Colors.grey,
            fontSize: 14,
            decoration: TextDecoration.lineThrough,
            decorationColor: Colors.grey,
          ),
        ),
        Text(
          "${PriceFormatter.format(newPrice)}/người",
          style: const TextStyle(
            fontFamily: "Quicksand",
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppTheme.summerAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    final status = _checkRegistrationStatus();
    String buttonText = "Đăng ký ngay";
    Color buttonColor = AppTheme.summerAccent;
    VoidCallback? onPressed;

    if (status == -1) {
      buttonText = "Chưa mở đăng ký";
      buttonColor = Colors.grey;
      onPressed = null;
    } else if (status == 1) {
      buttonText = "Đã hết hạn đăng ký";
      buttonColor = Colors.grey;
      onPressed = null;
    } else {
      buttonText = "Đăng ký ngay";
      buttonColor = AppTheme.summerAccent;
      onPressed = () => Navigator.pushNamed(
        context,
        AppRoutes.registrationForm,
        arguments: widget.camp,
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: buttonColor,
        disabledBackgroundColor: Colors.grey.shade300,
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: const TextStyle(
          fontFamily: "Quicksand",
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTabContent(TextTheme textTheme) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        switch (_tabController.index) {
          case 0:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mô tả chi tiết",
                  style: textTheme.titleLarge?.copyWith(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.camp.description,
                  style: textTheme.bodyLarge?.copyWith(
                    fontFamily: "Quicksand",
                    color: Colors.black87,
                    height: 1.5,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          case 1:
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  "Chưa có đánh giá nào",
                  style: TextStyle(fontFamily: "Quicksand", color: Colors.grey),
                ),
              ),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final camp = widget.camp;

    String registrationStartDate = "";
    String registrationEndDate = "";
    try {
      registrationStartDate = DateFormatter.formatDate(
        camp.registrationStartDate,
      );
      registrationEndDate = DateFormatter.formatDate(camp.registrationEndDate);
    } catch (e) {
      registrationStartDate = camp.registrationStartDate.toString();
      registrationEndDate = camp.registrationEndDate.toString();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildPriceDetail(context),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 20,
            //       vertical: 12,
            //     ),
            //   ),
            //   onPressed: () => Navigator.pushNamed(
            //     context,
            //     AppRoutes.registrationForm,
            //     arguments: camp,
            //   ),
            //   child: const Text(
            //     "Đăng ký ngay",
            //     style: TextStyle(
            //       fontFamily: "Quicksand",
            //       fontWeight: FontWeight.bold,
            //       fontSize: 14,
            //     ),
            //   ),
            // ),
            _buildRegisterButton(),
          ],
        ),
      ),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            backgroundColor: AppTheme.summerPrimary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    camp.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          camp.name,
                          style: textTheme.headlineMedium?.copyWith(
                            fontFamily: "Quicksand",
                            fontWeight: FontWeight.bold,
                            color: AppTheme.summerPrimary,
                            fontSize: 24,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: Colors.grey,
                            ),

                            const SizedBox(width: 4),

                            Expanded(
                              child: Text(
                                camp.place,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontFamily: "Quicksand",
                                  color: Colors.black,
                                  fontSize: 18,
                                  height: 0.9,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        if (camp.campType != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                camp.campType!.name,
                                style: const TextStyle(
                                  fontFamily: "Quicksand",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    color: Color(0xFFF5F7F8),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 15,
                                spreadRadius: 0,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                _buildDetailRow(
                                  Icons.calendar_month_outlined,
                                  "Thời gian diễn ra",
                                  "${DateFormatter.formatFromString(camp.startDate)} - ${DateFormatter.formatFromString(camp.endDate)}",
                                ),
                                const Divider(height: 24),
                                _buildDetailRow(
                                  Icons.app_registration_rounded,
                                  "Thời gian đăng ký",
                                  "$registrationStartDate - $registrationEndDate",
                                ),
                                const Divider(height: 24),
                                _buildDetailRow(
                                  Icons.groups_outlined,
                                  "Số lượng",
                                  "Từ ${camp.minParticipants} đến ${camp.maxParticipants} trẻ",
                                ),
                                const Divider(height: 24),
                                _buildDetailRow(
                                  Icons.child_care_outlined,
                                  "Độ tuổi",
                                  "${camp.minAge ?? '?'} - ${camp.maxAge ?? '?'} tuổi",
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.transparent,
                                width: 0,
                              ),
                            ),
                          ),
                          child: TabBar(
                            controller: _tabController,

                            dividerColor: Colors.transparent,

                            indicator: const UnderlineTabIndicator(
                              borderSide: BorderSide(
                                color: Color(0xFF1565C0),
                                width: 3.0,
                              ),
                              // insets: EdgeInsets.symmetric(horizontal: 16.0),
                            ),

                            labelColor: Color(0xFF1565C0),
                            unselectedLabelColor: Colors.grey,
                            labelStyle: const TextStyle(
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            tabs: const [
                              Tab(text: "Tổng quan"),
                              Tab(text: "Đánh giá"),
                            ],
                            onTap: (index) {
                              setState(() {});
                            },
                          ),
                        ),

                        const SizedBox(height: 24),

                        _buildTabContent(textTheme),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 8),
        Icon(icon, color: AppTheme.summerPrimary, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "Quicksand",
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
