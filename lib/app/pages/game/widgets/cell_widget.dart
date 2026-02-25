import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:minesweeper_classic/app/controllers/game_controller.dart';

class CellWidget extends StatelessWidget {
  final int row;
  final int col;
  final Cell cell;
  final double size;
  final GameController controller;

  const CellWidget({
    super.key,
    required this.row,
    required this.col,
    required this.cell,
    required this.size,
    required this.controller,
  });

  static const List<Color> _numberColors = [
    Colors.transparent, // 0
    Color(0xFF1565C0), // 1 blue
    Color(0xFF2E7D32), // 2 green
    Color(0xFFC62828), // 3 red
    Color(0xFF1A237E), // 4 dark blue
    Color(0xFF6A1B1B), // 5 maroon
    Color(0xFF00838F), // 6 teal
    Color(0xFF000000), // 7 black
    Color(0xFF757575), // 8 gray
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => controller.reveal(row, col),
      onLongPress: () => controller.toggleFlag(row, col),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _bgColor(cs),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.4),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(2.r),
          boxShadow: cell.isRevealed
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 1,
                    offset: const Offset(1, 1),
                  ),
                ],
        ),
        child: Center(child: _buildContent(cs)),
      ),
    );
  }

  Color _bgColor(ColorScheme cs) {
    if (cell.isExploded) return const Color(0xFFC62828);
    if (cell.isRevealed && cell.isMine) return cs.errorContainer;
    if (cell.isRevealed) return cs.surfaceContainerHighest;
    return cs.surfaceContainerHigh;
  }

  Widget _buildContent(ColorScheme cs) {
    // 오표시 깃발: 깃발이 꽂혀 있으나 지뢰가 없는 셀 (게임 오버 후 표시)
    if (cell.isWrongFlag) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Text('🚩', style: TextStyle(fontSize: size * 0.5)),
          Text(
            '✕',
            style: TextStyle(
              fontSize: size * 0.65,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFC62828),
              height: 1,
            ),
          ),
        ],
      );
    }

    if (cell.isFlagged && !cell.isRevealed) {
      return Text('🚩', style: TextStyle(fontSize: size * 0.5));
    }

    if (!cell.isRevealed) return const SizedBox.shrink();

    if (cell.isMine) {
      return Text(
        '💣',
        style: TextStyle(fontSize: size * 0.5),
      );
    }

    if (cell.adjacentMines == 0) return const SizedBox.shrink();

    return Text(
      '${cell.adjacentMines}',
      style: TextStyle(
        fontSize: size * 0.55,
        fontWeight: FontWeight.w900,
        color: _numberColors[cell.adjacentMines.clamp(0, 8)],
        height: 1,
      ),
    );
  }
}
