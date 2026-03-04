import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:minesweeper_classic/app/controllers/game_controller.dart';

class WonDialog extends GetView<GameController> {
  const WonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gradient header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primaryContainer, cs.primary.withValues(alpha: 0.3)],
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.primary.withValues(alpha: 0.15),
                  ),
                  child: Icon(LucideIcons.trophy, size: 30.r, color: cs.primary),
                ),
                SizedBox(height: 8.h),
                Text(
                  'result_win'.tr,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 8.h),
            child: Column(
              children: [
                Obx(() => Text(
                  'result_time'.trParams({'t': '${controller.elapsed.value}'}),
                  style: TextStyle(fontSize: 14.sp, color: cs.onSurfaceVariant),
                )),
                SizedBox(height: 16.h),
                _BestRecordDisplay(controller: controller),
              ],
            ),
          ),
          // Actions
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: Text('home'.tr),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [cs.primary, cs.tertiary]),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () {
                          Get.back();
                          controller.initGame();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Center(
                            child: Text(
                              'play_again'.tr,
                              style: TextStyle(
                                color: cs.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.2, end: 0),
    );
  }
}

class LostDialog extends GetView<GameController> {
  const LostDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gradient header (error colors for lost)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.errorContainer, cs.error.withValues(alpha: 0.3)],
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cs.error.withValues(alpha: 0.15),
                  ),
                  child: Icon(LucideIcons.bomb, size: 30.r, color: cs.error),
                ),
                SizedBox(height: 8.h),
                Text(
                  'result_lose'.tr,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: cs.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 8.h),
            child: Column(
              children: [
                Text(
                  'result_lose_sub'.tr,
                  style: TextStyle(fontSize: 13.sp, color: cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                // Rewarded ad: second chance
                Obx(() {
                  if (controller.hasExtraLife.value) return const SizedBox.shrink();
                  return Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.play, color: cs.primary, size: 24.r),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'extra_life_offer'.tr,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: cs.onPrimaryContainer,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            controller.requestExtraLife();
                          },
                          child: Text('watch_ad'.tr),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          // Actions
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: Text('home'.tr),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [cs.primary, cs.tertiary]),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.r),
                        onTap: () {
                          Get.back();
                          controller.initGame();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Center(
                            child: Text(
                              'play_again'.tr,
                              style: TextStyle(
                                color: cs.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.2, end: 0),
    );
  }
}

class _BestRecordDisplay extends StatelessWidget {
  final GameController controller;
  const _BestRecordDisplay({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Get.theme.colorScheme;
    final best = controller.getBestRecord(controller.difficulty.value);

    if (best == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.trophy, color: cs.primary, size: 20.r),
          SizedBox(width: 8.w),
          Text(
            'best_record'.trParams({'t': '$best'}),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: cs.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
