import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import 'package:minesweeper_classic/app/controllers/setting_controller.dart';
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
  bool isWrongFlag;
  int adjacentMines;

  Cell({
    this.isMine = false,
    this.isRevealed = false,
    this.isFlagged = false,
    this.isExploded = false,
    this.isWrongFlag = false,
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

  // ─── Confetti ──────────────────────────────────────────────────
  late final confettiController = ConfettiController(duration: const Duration(seconds: 2));

  bool _hasVibrator = false;

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
  void onInit() {
    super.onInit();
    Vibration.hasVibrator().then((v) => _hasVibrator = v);
  }

  @override
  void onClose() {
    _timer?.cancel();
    confettiController.dispose();
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
    _explodedRow = null;
    _explodedCol = null;
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

    if (cell.isMine) {
      // Game over
      if (SettingController.to.hapticEnabled.value && _hasVibrator) Vibration.vibrate(duration: 200);
      _explodedRow = row;
      _explodedCol = col;
      grid[row][col].isExploded = true;
      grid[row][col].isRevealed = true;
      _revealAllMines();
      status.value = GameStatus.lost;
      _stopTimer();
      grid.refresh();
      return;
    }

    final revealedBefore = _countRevealed();
    _floodReveal(row, col);
    final revealedAfter = _countRevealed();

    if (SettingController.to.hapticEnabled.value && _hasVibrator) {
      if (revealedAfter - revealedBefore > 1) {
        Vibration.vibrate(duration: 50);
      } else {
        Vibration.vibrate(duration: 30);
      }
    }

    grid.refresh();
    _checkWin();
  }

  void _floodReveal(int row, int col) {
    final queue = <(int, int)>[];
    queue.add((row, col));
    final visited = <int>{};

    while (queue.isNotEmpty) {
      final (r, c) = queue.removeAt(0);

      // Bounds check BEFORE computing key to avoid hash collisions
      // with valid cells from out-of-bounds coordinates
      if (r < 0 || r >= rows || c < 0 || c >= cols) continue;

      final key = r * cols + c;
      if (visited.contains(key)) continue;
      visited.add(key);

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

  int _countRevealed() {
    int count = 0;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (grid[r][c].isRevealed) count++;
      }
    }
    return count;
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
        // 지뢰인데 아직 공개되지 않은 경우 공개
        if (grid[r][c].isMine && !grid[r][c].isExploded) {
          grid[r][c].isRevealed = true;
        }
        // 깃발이 꽂혀 있는데 지뢰가 없는 경우 오표시 처리
        if (grid[r][c].isFlagged && !grid[r][c].isMine) {
          grid[r][c].isWrongFlag = true;
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

    if (SettingController.to.hapticEnabled.value && _hasVibrator) Vibration.vibrate(duration: 50);
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

    if (SettingController.to.hapticEnabled.value && _hasVibrator) Vibration.vibrate(duration: 100);
    status.value = GameStatus.won;
    _stopTimer();
    _saveBestRecord();
    confettiController.play();

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
      elapsed.value++;
    });
  }

  void _startTimerFromCurrent() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsed.value++;
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

  // Track which cell exploded so we can undo it
  int? _explodedRow;
  int? _explodedCol;

  void requestExtraLife() {
    RewardedAdManager.to.showAdIfAvailable(
      onUserEarnedReward: (_) {
        _applyExtraLife();
      },
    );
  }

  void _applyExtraLife() {
    if (status.value != GameStatus.lost) return;
    if (_explodedRow == null || _explodedCol == null) return;

    // Mark extra life as used so the ad offer is not shown again
    hasExtraLife.value = true;

    final r = _explodedRow!;
    final c = _explodedCol!;

    // Remove the mine from the exploded cell
    grid[r][c].isMine = false;
    grid[r][c].isExploded = false;
    grid[r][c].isRevealed = false;

    // Hide all mines that were revealed on game over
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (grid[row][col].isMine && !grid[row][col].isFlagged) {
          grid[row][col].isRevealed = false;
        }
        // Reset wrong-flag markers
        grid[row][col].isWrongFlag = false;
      }
    }

    // Recompute adjacent counts around the removed mine
    _recomputeAdjacent(r, c);
    grid[r][c].adjacentMines = _countAdjacentMines(r, c);

    // Reveal the previously-exploded cell (flood fill if 0)
    _floodReveal(r, c);

    // Restore game state
    status.value = GameStatus.playing;
    _explodedRow = null;
    _explodedCol = null;
    _startTimerFromCurrent();

    grid.refresh();
    _checkWin();
  }
}
