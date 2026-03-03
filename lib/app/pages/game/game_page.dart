import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:minesweeper_classic/app/controllers/game_controller.dart';
import 'package:minesweeper_classic/app/data/enums/game_status.dart';
import 'package:minesweeper_classic/app/pages/game/widgets/cell_widget.dart';
import 'package:minesweeper_classic/app/pages/game/widgets/result_dialog.dart';
import 'package:minesweeper_classic/app/widgets/confetti_overlay.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final GameController _controller;
  late final Worker _statusWorker;

  @override
  void initState() {
    super.initState();
    _controller = GameController.to;
    _statusWorker = ever(_controller.status, (status) {
      if (status == GameStatus.won) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (Get.isDialogOpen != true) {
            Get.dialog(const WonDialog(), barrierDismissible: false);
          }
        });
      } else if (status == GameStatus.lost) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (Get.isDialogOpen != true) {
            Get.dialog(const LostDialog(), barrierDismissible: false);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _statusWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr, style: TextStyle(fontSize: 18.sp)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ─── Top Bar ─────────────────────────────────────
                _TopBar(controller: controller),

                // ─── Grid ────────────────────────────────────────
                Expanded(
                  child: Obx(() {
                    if (controller.grid.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _GameGrid(controller: controller);
                  }),
                ),
              ],
            ),

            // ─── Confetti ────────────────────────────────────────
            Obx(() => controller.showConfetti.value
                ? IgnorePointer(
                    child: ConfettiOverlay(
                      onComplete: () => controller.showConfetti.value = false,
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final GameController controller;
  const _TopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      color: cs.surfaceContainerLow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Mine counter
          Obx(() => _CounterBadge(
            icon: '🚩',
            value: controller.remainingMines.value.clamp(-99, 999),
            color: cs.error,
          )),

          // Restart face button
          GestureDetector(
            onTap: () => controller.initGame(),
            child: Obx(() {
              String face;
              switch (controller.status.value) {
                case GameStatus.won:
                  face = '😎';
                case GameStatus.lost:
                  face = '😵';
                default:
                  face = '🙂';
              }
              return Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Center(child: Text(face, style: TextStyle(fontSize: 24.sp))),
              );
            }),
          ),

          // Timer
          Obx(() => _CounterBadge(
            icon: '⏱',
            value: controller.elapsed.value,
            color: cs.primary,
          )),
        ],
      ),
    );
  }
}

class _CounterBadge extends StatelessWidget {
  final String icon;
  final int value;
  final Color color;
  const _CounterBadge({required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: TextStyle(fontSize: 16.sp)),
          SizedBox(width: 6.w),
          Text(
            value < 0
                ? '-${value.abs().toString().padLeft(2, '0')}'
                : value.toString().padLeft(3, '0'),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: color,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _GameGrid extends StatelessWidget {
  final GameController controller;
  const _GameGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Compute cell size based on screen width
    final screenW = MediaQuery.of(context).size.width;
    final cols = controller.cols;
    final rows = controller.rows;

    // For expert (30 cols), need to allow horizontal scrolling
    const minCellSize = 26.0;
    const maxCellSize = 44.0;
    final cellSize = ((screenW - 8) / cols).clamp(minCellSize, maxCellSize);

    return InteractiveViewer(
      constrained: false,
      minScale: 0.5,
      maxScale: 3.0,
      child: Obx(() {
        // Trigger rebuild on grid changes
        final _ = controller.grid.length;
        return Padding(
          padding: EdgeInsets.all(4.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(rows, (r) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(cols, (c) {
                  final cell = r < controller.grid.length &&
                          c < controller.grid[r].length
                      ? controller.grid[r][c]
                      : Cell();
                  return CellWidget(
                    key: ValueKey('${r}_$c'),
                    row: r,
                    col: c,
                    cell: cell,
                    size: cellSize,
                    controller: controller,
                  );
                }),
              );
            }),
          ),
        );
      }),
    );
  }
}
