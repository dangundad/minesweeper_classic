import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:minesweeper_classic/app/controllers/game_controller.dart';

class WonDialog extends GetView<GameController> {
  const WonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🎉', style: TextStyle(fontSize: 48.sp)),
            SizedBox(height: 8.h),
            Text(
              'result_win'.tr,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2E7D32),
              ),
            ),
            SizedBox(height: 4.h),
            Obx(() => Text(
              'result_time'.trParams({'t': '${controller.elapsed.value}'}),
              style: TextStyle(fontSize: 14.sp, color: cs.onSurfaceVariant),
            )),
            SizedBox(height: 20.h),
            _BestRecordDisplay(controller: controller),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text('home'.tr),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Get.back();
                      controller.initGame();
                    },
                    child: Text('play_again'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LostDialog extends GetView<GameController> {
  const LostDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('💣', style: TextStyle(fontSize: 48.sp)),
            SizedBox(height: 8.h),
            Text(
              'result_lose'.tr,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: cs.error,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'result_lose_sub'.tr,
              style: TextStyle(fontSize: 13.sp, color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),

            // Rewarded ad: second chance
            Obx(() {
              if (controller.hasExtraLife.value) return const SizedBox.shrink();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.play_circle, color: cs.primary, size: 24.r),
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
                  ),
                  SizedBox(height: 16.h),
                ],
              );
            }),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text('home'.tr),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Get.back();
                      controller.initGame();
                    },
                    child: Text('play_again'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BestRecordDisplay extends StatelessWidget {
  final GameController controller;
  const _BestRecordDisplay({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
          Icon(Icons.emoji_events, color: cs.primary, size: 20.r),
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
