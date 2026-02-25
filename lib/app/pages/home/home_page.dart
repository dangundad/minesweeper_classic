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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: DecoratedBox(
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
                      SizedBox(height: 32.h),
                      _buildHeader(),
                      SizedBox(height: 28.h),
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
      ),
    );
  }

  Widget _buildHeader() {
    return const _AnimatedHeader();
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: cs.outline.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events_rounded, color: const Color(0xFFFFD600), size: 18.r),
              SizedBox(width: 6.w),
              Text(
                'best_records'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...Difficulty.values
              .where((d) => d != Difficulty.custom)
              .map((diff) {
            final best = gameCtrl.getBestRecord(diff);
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    diff.labelKey.tr,
                    style: TextStyle(fontSize: 13.sp, color: cs.onSurface),
                  ),
                  Row(
                    children: [
                      if (best != null)
                        Padding(
                          padding: EdgeInsets.only(right: 4.w),
                          child: Icon(
                            Icons.timer_outlined,
                            size: 14.r,
                            color: cs.primary,
                          ),
                        ),
                      Text(
                        best != null ? '${best}s' : 'no_record'.tr,
                        style: TextStyle(
                          fontSize: best != null ? 15.sp : 13.sp,
                          fontWeight: FontWeight.w700,
                          color: best != null ? cs.primary : cs.onSurfaceVariant,
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
}

class _AnimatedHeader extends StatelessWidget {
  const _AnimatedHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 620),
          curve: Curves.elasticOut,
          builder: (ctx, v, child) =>
              Transform.scale(scale: v, child: child),
          child: Icon(
            LucideIcons.bomb,
            color: cs.primary,
            size: 56.r,
          ),
        ),
        SizedBox(height: 8.h),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          builder: (ctx, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(offset: Offset(0, (1 - v) * 8), child: child),
          ),
          child: Text(
            'app_name'.tr,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w900,
              color: cs.onSurface,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'home_subtitle'.tr,
          style: TextStyle(
            fontSize: 13.sp,
            color: cs.onSurfaceVariant,
            height: 1.35,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    final color = _color();

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        final ctrl = GameController.to;
        ctrl.initGame(diff: widget.difficulty);
        Get.toNamed(Routes.GAME);
      },
      onTapCancel: () => _ctrl.reverse(),
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
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: color.withValues(alpha: 0.3)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.grid_on,
                color: Colors.white,
                size: 24.r,
              ),
              SizedBox(width: 12.w),
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
                    SizedBox(height: 2.h),
                    Text(
                      '${widget.difficulty.rows}x${widget.difficulty.cols} · ${widget.difficulty.mines}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '▶',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
    final cs = Theme.of(context).colorScheme;
    final ctrl = GameController.to;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: cs.outline.withValues(alpha: 0.45)),
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
              Text(
                'diff_custom'.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              FilledButton(
                onPressed: () {
                  ctrl.initGame(diff: Difficulty.custom);
                  Get.toNamed(Routes.GAME);
                },
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                child: Text('play'.tr),
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
