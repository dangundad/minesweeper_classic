import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:minesweeper_classic/app/admob/ads_banner.dart';
import 'package:minesweeper_classic/app/admob/ads_helper.dart';
import 'package:minesweeper_classic/app/controllers/game_controller.dart';
import 'package:minesweeper_classic/app/controllers/home_controller.dart';
import 'package:minesweeper_classic/app/data/enums/difficulty.dart';
import 'package:minesweeper_classic/app/routes/app_pages.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'app_name'.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.settings, size: 22.r, color: cs.onSurfaceVariant),
            onPressed: () => Get.toNamed(Routes.SETTINGS),
            tooltip: 'settings'.tr,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, cs.tertiary],
              ),
            ),
          ),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cs.surface,
              cs.surfaceContainerLowest.withValues(alpha: 0.93),
              cs.surface.withValues(alpha: 0.95),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 28.h),
                    _buildHeroSection(cs),
                    SizedBox(height: 28.h),
                    _buildSectionLabel(cs, LucideIcons.layers, 'select_difficulty'.tr),
                    SizedBox(height: 12.h),
                    _buildDifficultyCards(),
                    SizedBox(height: 20.h),
                    _buildBestRecords(cs),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            BannerAdWidget(
              adUnitId: AdHelper.bannerAdUnitId,
              type: AdHelper.banner,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(ColorScheme cs) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 620),
          curve: Curves.elasticOut,
          builder: (ctx, v, child) => Transform.scale(scale: v, child: child),
          child: Container(
            width: 110.r,
            height: 110.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  cs.primaryContainer,
                  cs.primaryContainer.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: Center(
              child: Icon(LucideIcons.bomb, size: 60.r, color: cs.primary),
            ),
          ),
        ),
        SizedBox(height: 14.h),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          builder: (ctx, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(offset: Offset(0, (1 - v) * 8), child: child),
          ),
          child: Text(
            'home_subtitle'.tr,
            style: TextStyle(
              fontSize: 13.sp,
              color: cs.onSurfaceVariant,
              height: 1.35,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(ColorScheme cs, IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: cs.primary),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: cs.onSurfaceVariant,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyCards() {
    final diffs = Difficulty.values.where((d) => d != Difficulty.custom).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...List.generate(diffs.length, (index) {
          final diff = diffs[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 380 + index * 90),
              curve: Curves.easeOut,
              builder: (ctx, v, child) => Transform.translate(
                offset: Offset(0, (1 - v) * 24),
                child: Opacity(opacity: v, child: child),
              ),
              child: _DifficultyCard(difficulty: diff),
            ),
          );
        }),
        const _CustomCard(),
      ],
    );
  }

  Widget _buildBestRecords(ColorScheme cs) {
    final gameCtrl = GameController.to;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primaryContainer,
            cs.secondaryContainer.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events_rounded, color: const Color(0xFFFFD600), size: 20.r),
              SizedBox(width: 8.w),
              Text(
                'best_records'.tr,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...Difficulty.values
              .where((d) => d != Difficulty.custom)
              .map((diff) {
            final best = gameCtrl.getBestRecord(diff);
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: BoxDecoration(
                          color: _difficultyColor(diff),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        diff.labelKey.tr,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (best != null) ...[
                        Icon(
                          Icons.timer_outlined,
                          size: 14.r,
                          color: cs.primary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${best}s',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: cs.primary,
                          ),
                        ),
                      ] else
                        Text(
                          'no_record'.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _difficultyColor(Difficulty diff) {
    switch (diff) {
      case Difficulty.beginner:
        return const Color(0xFF43A047);
      case Difficulty.intermediate:
        return const Color(0xFFF57C00);
      case Difficulty.expert:
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF6A1B9A);
    }
  }
}

class _DifficultyCard extends StatefulWidget {
  final Difficulty difficulty;
  const _DifficultyCard({required this.difficulty});

  @override
  State<_DifficultyCard> createState() => _DifficultyCardState();
}

class _DifficultyCardState extends State<_DifficultyCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0,
      upperBound: 1,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color _color() {
    switch (widget.difficulty) {
      case Difficulty.beginner:
        return const Color(0xFF43A047);
      case Difficulty.intermediate:
        return const Color(0xFFF57C00);
      case Difficulty.expert:
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF6A1B9A);
    }
  }

  IconData _icon() {
    switch (widget.difficulty) {
      case Difficulty.beginner:
        return LucideIcons.smile;
      case Difficulty.intermediate:
        return LucideIcons.zap;
      case Difficulty.expert:
        return LucideIcons.skull;
      default:
        return LucideIcons.settings2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();

    return GestureDetector(
      onTapDown: (_) {
        _ctrl.forward();
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        _ctrl.reverse();
        setState(() => _isPressed = false);
        final ctrl = GameController.to;
        ctrl.initGame(diff: widget.difficulty);
        Get.toNamed(Routes.GAME);
      },
      onTapCancel: () {
        _ctrl.reverse();
        setState(() => _isPressed = false);
      },
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.85),
                color.withValues(alpha: 0.58),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: color.withValues(alpha: 0.3)),
            boxShadow: _isPressed
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.45),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: color.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Icon(_icon(), color: Colors.white, size: 24.r),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.difficulty.labelKey.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '${widget.difficulty.rows}×${widget.difficulty.cols} · ${widget.difficulty.mines} mines',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, color: Colors.white.withValues(alpha: 0.9), size: 20.r),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomCard extends StatelessWidget {
  const _CustomCard();

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;
    final ctrl = GameController.to;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.slidersHorizontal, size: 18.r, color: cs.primary),
                  SizedBox(width: 8.w),
                  Text(
                    'diff_custom'.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
              _GradientButton(
                label: 'play'.tr,
                icon: LucideIcons.play,
                compact: true,
                onTap: () {
                  ctrl.initGame(diff: Difficulty.custom);
                  Get.toNamed(Routes.GAME);
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Obx(() => _buildSlider(
                cs: cs,
                label: '${'custom_rows'.tr}: ${ctrl.customRows.value}',
                value: ctrl.customRows.value.toDouble(),
                min: 5,
                max: 20,
                onChanged: (v) => ctrl.customRows.value = v.round(),
              )),
          Obx(() => _buildSlider(
                cs: cs,
                label: '${'custom_cols'.tr}: ${ctrl.customCols.value}',
                value: ctrl.customCols.value.toDouble(),
                min: 5,
                max: 30,
                onChanged: (v) => ctrl.customCols.value = v.round(),
              )),
          Obx(() {
            final maxMines = ((ctrl.customRows.value * ctrl.customCols.value) * 0.35)
                .floor()
                .toDouble()
                .clamp(1, 200);
            final curMines =
                ctrl.customMines.value.toDouble().clamp(1, maxMines);
            return _buildSlider(
              cs: cs,
              label: '${'custom_mines'.tr}: ${curMines.round()}',
              value: curMines.toDouble(),
              min: 1,
              max: maxMines.toDouble(),
              onChanged: (v) => ctrl.customMines.value = v.round(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required ColorScheme cs,
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 108.w,
          child: Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: cs.onSurfaceVariant),
          ),
        ),
        Expanded(
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max.clamp(min + 1, 200),
            divisions: (max.clamp(min + 1, 200) - min)
                .round()
                .clamp(1, 199),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool compact;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.tertiary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(compact ? 10.r : 16.r),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.35),
            blurRadius: compact ? 10 : 14,
            offset: Offset(0, compact ? 4 : 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(compact ? 10.r : 16.r),
          onTap: onTap,
          child: Padding(
            padding: compact
                ? EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h)
                : EdgeInsets.symmetric(vertical: 16.h),
            child: compact
                ? Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: cs.onPrimary,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: 22.r, color: cs.onPrimary),
                      SizedBox(width: 10.w),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: cs.onPrimary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
