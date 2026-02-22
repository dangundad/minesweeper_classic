import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';

import 'package:minesweeper_classic/app/data/enums/difficulty.dart';
import 'package:minesweeper_classic/app/data/enums/game_status.dart';
import 'package:minesweeper_classic/app/services/hive_service.dart';
import 'package:minesweeper_classic/app/admob/ads_interstitial.dart';
import 'package:minesweeper_classic/app/admob/ads_rewarded.dart';

class Cell {
  bool isMine;
  bool isRevealed;
  bool isFlagged;
  bool isExploded;
  int adjacentMines;

  Cell({
    this.isMine = false,
    this.isRevealed = false,
    this.isFlagged = false,
    this.isExploded = false,
    this.adjacentMines = 0,
  });
}

class GameController extends GetxController {
  static GameController get to => Get.find();

  // ─── Game Config ───────────────────────────────────────────────
  final Rx<Difficulty> difficulty = Difficulty.beginner.obs;
  final RxInt customRows = 10.obs;
  final RxInt customCols = 10.obs;
  final RxInt customMines = 15.obs;

  // ─── Game State ────────────────────────────────────────────────
  final Rx<GameStatus> status = GameStatus.initial.obs;
  final RxList<List<Cell>> grid = <List<Cell>>[].obs;
  final RxInt remainingMines = 0.obs;
  final RxInt flagCount = 0.obs;
  final RxBool hasExtraLife = false.obs;
  bool _firstClick = true;

  // ─── Timer ─────────────────────────────────────────────────────
  final RxInt elapsed = 0.obs;
  Timer? _timer;

  // ─── Computed dims ─────────────────────────────────────────────
  int get rows =>
      difficulty.value == Difficulty.custom ? customRows.value : difficulty.value.rows;
  int get cols =>
      difficulty.value == Difficulty.custom ? customCols.value : difficulty.value.cols;
  int get totalMines =>
      difficulty.value == Difficulty.custom
          ? customMines.value
          : difficulty.value.mines;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // ─── Init ──────────────────────────────────────────────────────

  void initGame({Difficulty? diff}) {
    if (diff != null) difficulty.value = diff;
    _timer?.cancel();
    elapsed.value = 0;
    flagCount.value = 0;
    hasExtraLife.value = false;
    _firstClick = true;
    status.value = GameStatus.initial;
    remainingMines.value = totalMines;

    grid.value = List.generate(
      rows,
      (_) => List.generate(cols, (_) => Cell()),
    );
    grid.refresh();
  }

  void _generateMines(int safeRow, int safeCol) {
    // Safe zone: clicked cell + 8 neighbors
    final safe = <int>{};
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        final r = safeRow + dr;
        final c = safeCol + dc;
        if (r >= 0 && r < rows && c >= 0 && c < cols) {
          safe.add(r * cols + c);
        }
      }
    }

    final rng = Random();
    int placed = 0;
    while (placed < totalMines) {
      final idx = rng.nextInt(rows * cols);
      if (!safe.contains(idx)) {
        final r = idx ~/ cols;
        final c = idx % cols;
        if (!grid[r][c].isMine) {
          grid[r][c].isMine = true;
          placed++;
        }
      }
    }

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!grid[r][c].isMine) {
          grid[r][c].adjacentMines = _countAdjacentMines(r, c);
        }
      }
    }

    grid.refresh();
  }

  int _countAdjacentMines(int row, int col) {
    int count = 0;
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        final r = row + dr;
        final c = col + dc;
        if (r >= 0 && r < rows && c >= 0 && c < cols && grid[r][c].isMine) {
          count++;
        }
      }
    }
    return count;
  }

  // ─── Reveal ────────────────────────────────────────────────────

  void reveal(int row, int col) {
    if (status.value == GameStatus.won || status.value == GameStatus.lost) return;
    final cell = grid[row][col];
    if (cell.isRevealed || cell.isFlagged) return;

    if (_firstClick) {
      _firstClick = false;
      _generateMines(row, col);
      _startTimer();
      status.value = GameStatus.playing;
    }

    final c = grid[row][col];

    if (c.isMine) {
      if (hasExtraLife.value) {
        // Use extra life: remove mine, continue
        hasExtraLife.value = false;
        grid[row][col].isMine = false;
        _recomputeAdjacent(row, col);
        grid[row][col].adjacentMines = _countAdjacentMines(row, col);
        _floodReveal(row, col);
        grid.refresh();
        _checkWin();
        return;
      }

      // Game over
      grid[row][col].isExploded = true;
      grid[row][col].isRevealed = true;
      _revealAllMines();
      status.value = GameStatus.lost;
      _stopTimer();
      grid.refresh();
      return;
    }

    _floodReveal(row, col);
    grid.refresh();
    _checkWin();
  }

  void _floodReveal(int row, int col) {
    final queue = <(int, int)>[];
    queue.add((row, col));
    final visited = <int>{};

    while (queue.isNotEmpty) {
      final (r, c) = queue.removeAt(0);
      final key = r * cols + c;
      if (visited.contains(key)) continue;
      visited.add(key);

      if (r < 0 || r >= rows || c < 0 || c >= cols) continue;
      final cell = grid[r][c];
      if (cell.isRevealed || cell.isFlagged || cell.isMine) continue;

      grid[r][c].isRevealed = true;

      if (cell.adjacentMines == 0) {
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            if (dr == 0 && dc == 0) continue;
            queue.add((r + dr, c + dc));
          }
        }
      }
    }
  }

  void _recomputeAdjacent(int mineRow, int mineCol) {
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        final r = mineRow + dr;
        final c = mineCol + dc;
        if (r >= 0 && r < rows && c >= 0 && c < cols && !grid[r][c].isMine) {
          grid[r][c].adjacentMines = _countAdjacentMines(r, c);
        }
      }
    }
  }

  void _revealAllMines() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c].isMine && !grid[r][c].isExploded) {
          grid[r][c].isRevealed = true;
        }
      }
    }
  }

  // ─── Flag ──────────────────────────────────────────────────────

  void toggleFlag(int row, int col) {
    if (status.value == GameStatus.won || status.value == GameStatus.lost) return;
    if (status.value == GameStatus.initial) return;
    final cell = grid[row][col];
    if (cell.isRevealed) return;

    grid[row][col].isFlagged = !grid[row][col].isFlagged;
    flagCount.value += grid[row][col].isFlagged ? 1 : -1;
    remainingMines.value = totalMines - flagCount.value;
    grid.refresh();
  }

  // ─── Win Check ─────────────────────────────────────────────────

  void _checkWin() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (!grid[r][c].isMine && !grid[r][c].isRevealed) return;
      }
    }

    status.value = GameStatus.won;
    _stopTimer();
    _saveBestRecord();

    // Auto-flag all mines
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c].isMine) grid[r][c].isFlagged = true;
      }
    }
    grid.refresh();

    InterstitialAdManager.to.showAdIfAvailable();
  }

  // ─── Timer ─────────────────────────────────────────────────────

  void _startTimer() {
    _timer?.cancel();
    elapsed.value = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (elapsed.value < 999) elapsed.value++;
    });
  }

  void _stopTimer() => _timer?.cancel();

  // ─── Best Record ───────────────────────────────────────────────

  void _saveBestRecord() {
    if (difficulty.value == Difficulty.custom) return;
    final key = difficulty.value.hiveKey;
    final current = HiveService.to.getAppData<int>(key);
    if (current == null || elapsed.value < current) {
      HiveService.to.setAppData(key, elapsed.value);
    }
  }

  int? getBestRecord(Difficulty diff) {
    if (diff == Difficulty.custom) return null;
    return HiveService.to.getAppData<int>(diff.hiveKey);
  }

  // ─── Extra Life (Rewarded Ad) ──────────────────────────────────

  void requestExtraLife() {
    RewardedAdManager.to.showAdIfAvailable(
      onUserEarnedReward: (_) {
        hasExtraLife.value = true;
        Get.back(); // close lost dialog if open
      },
    );
  }
}
