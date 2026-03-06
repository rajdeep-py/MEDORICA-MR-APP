import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../models/visual_ads.dart';
import '../../provider/visual_ads_provider.dart';
import '../../theme/app_theme.dart';

class VisualAdsScreen extends ConsumerStatefulWidget {
  const VisualAdsScreen({super.key});

  @override
  ConsumerState<VisualAdsScreen> createState() => _VisualAdsScreenState();
}

class _VisualAdsScreenState extends ConsumerState<VisualAdsScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _nextImage() {
    if (_isTransitioning || _currentIndex >= _filteredAds.length - 1) return;
    setState(() => _isTransitioning = true);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ).then((_) {
      setState(() => _isTransitioning = false);
    }).catchError((_) {
      setState(() => _isTransitioning = false);
    });
  }

  void _previousImage() {
    if (_isTransitioning || _currentIndex <= 0) return;
    setState(() => _isTransitioning = true);
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ).then((_) {
      setState(() => _isTransitioning = false);
    }).catchError((_) {
      setState(() => _isTransitioning = false);
    });
  }

  List<VisualAd> get _filteredAds => ref.watch(visualAdsFilteredProvider);
  List<String> get _categories => ref.watch(visualAdsCategoriesProvider);
  String? get _selectedCategory => ref.watch(filteredVisualAdsProvider);

  @override
  Widget build(BuildContext context) {
    final ads = _filteredAds;

    if (ads.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_circle_left, color: AppColors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text(
            'No visual ads available',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Image Carousel with Zoom
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index];
              return InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                child: Container(
                  color: AppColors.black,
                  child: Image.asset(
                    ad.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.black,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Iconsax.image,
                                size: 48,
                                color: AppColors.quaternary,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'Image not found',
                                style: AppTypography.body.copyWith(
                                  color: AppColors.quaternary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                ad.imagePath,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.quaternary,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          // Top Bar: Back and Filter Icons
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withAlpha(200),
                    AppColors.black.withAlpha(0),
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Iconsax.arrow_circle_left,
                        color: AppColors.white,
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),

                  // Filter Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      border: Border.all(
                        color: AppColors.white.withAlpha(50),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        value: _selectedCategory,
                        hint: Text(
                          'All Slides',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        dropdownColor: AppColors.black,
                        icon: const Icon(
                          Iconsax.arrow_down_1,
                          color: AppColors.white,
                          size: 16,
                        ),
                        items: [
                          DropdownMenuItem<String?>(
                            value: null,
                            child: Text(
                              'All Slides',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          ..._categories.map((category) {
                            return DropdownMenuItem<String?>(
                              value: category,
                              child: Text(
                                category,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          ref.read(filteredVisualAdsProvider.notifier).state = value;
                          setState(() => _currentIndex = 0);
                          _pageController.jumpToPage(0);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navigation Buttons (Previous/Next)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.black.withAlpha(200),
                    AppColors.black.withAlpha(0),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Info Text
                  Text(
                    '${_currentIndex + 1} / ${ads.length}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    ads[_currentIndex].title,
                    style: AppTypography.body.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Navigation Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Previous Button
                      Container(
                        decoration: BoxDecoration(
                          color: (_currentIndex > 0 && !_isTransitioning)
                              ? AppColors.white.withAlpha(30)
                              : AppColors.white.withAlpha(15),
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          border: Border.all(
                            color: (_currentIndex > 0 && !_isTransitioning)
                                ? AppColors.white.withAlpha(50)
                                : AppColors.white.withAlpha(20),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Iconsax.arrow_left_3,
                            color: AppColors.white,
                          ),
                          onPressed: (_currentIndex > 0 && !_isTransitioning)
                              ? _previousImage
                              : null,
                        ),
                      ),

                      // Indicator Dots
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            ads.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == _currentIndex
                                    ? AppColors.white
                                    : AppColors.white.withAlpha(100),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Next Button
                      Container(
                        decoration: BoxDecoration(
                          color: (_currentIndex < ads.length - 1 && !_isTransitioning)
                              ? AppColors.white.withAlpha(30)
                              : AppColors.white.withAlpha(15),
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          border: Border.all(
                            color: (_currentIndex < ads.length - 1 && !_isTransitioning)
                                ? AppColors.white.withAlpha(50)
                                : AppColors.white.withAlpha(20),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Iconsax.arrow_right_3,
                            color: AppColors.white,
                          ),
                          onPressed: (_currentIndex < ads.length - 1 && !_isTransitioning)
                              ? _nextImage
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}