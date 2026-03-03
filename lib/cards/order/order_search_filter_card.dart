import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';

class OrderSearchFilterCard extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onFilterTapped;

  const OrderSearchFilterCard({
    super.key,
    required this.onSearchChanged,
    this.onFilterTapped,
  });

  @override
  State<OrderSearchFilterCard> createState() => _OrderSearchFilterCardState();
}

class _OrderSearchFilterCardState extends State<OrderSearchFilterCard> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search by Order ID...',
                hintStyle: AppTypography.body.copyWith(
                  color: AppColors.quaternary,
                ),
                prefixIcon: const Icon(
                  Iconsax.search_normal,
                  size: 20,
                  color: AppColors.quaternary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 20,
                          color: AppColors.quaternary,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            widget.onSearchChanged('');
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ),
          if (widget.onFilterTapped != null) ...[
            Container(
              height: 40,
              width: 1,
              color: AppColors.border,
            ),
            IconButton(
              icon: const Icon(
                Iconsax.filter,
                size: 20,
                color: AppColors.quaternary,
              ),
              onPressed: widget.onFilterTapped,
            ),
          ],
        ],
      ),
    );
  }
}