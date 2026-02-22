import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 36.h),
                    _buildHeader(cs),
                    SizedBox(height: 32.h),
                    _buildDifficultyCards(),
                    SizedBox(height: 24.h),
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

  Widget _buildHeader(ColorScheme cs) {
    return Column(
      children: [
        Text('💣', style: TextStyle(fontSize: 56.sp)),
        SizedBox(height: 8.h),
        Text(
          'app_name'.tr,
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w900,
            color: cs.onSurface,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'home_subtitle'.tr,
          style: TextStyle(fontSize: 13.sp, color: cs.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDifficultyCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...Difficulty.values.where((d) => d != Difficulty.custom).map((diff) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _DifficultyCard(difficulty: diff),
          );
        }),
        const _CustomCard(),
      ],
    );
  }

  Widget _buildBestRecords(ColorScheme cs) {
    final gameCtrl = Get.find<GameController>();
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'best_records'.tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: cs.onSurfaceVariant,
            ),
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
                  Text(
                    best != null ? '${best}s' : 'no_record'.tr,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: best != null ? cs.primary : cs.onSurfaceVariant,
                    ),
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

class _DifficultyCard extends StatelessWidget {
  final Difficulty difficulty;
  const _DifficultyCard({required this.difficulty});

  Color _color() {
    switch (difficulty) {
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
      onTap: () {
        final ctrl = Get.find<GameController>();
        ctrl.initGame(diff: difficulty);
        Get.toNamed(Routes.GAME);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.85),
              color.withValues(alpha: 0.55),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  difficulty.labelKey.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${difficulty.rows}×${difficulty.cols}  💣 ${difficulty.mines}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
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
    final ctrl = Get.find<GameController>();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: cs.outlineVariant),
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
          width: 100.w,
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
            divisions: (max.clamp(min + 1, 200) - min).round().clamp(1, 199),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
