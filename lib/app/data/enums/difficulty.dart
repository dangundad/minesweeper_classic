enum Difficulty {
  beginner,
  intermediate,
  expert,
  custom;

  int get rows {
    switch (this) {
      case Difficulty.beginner:
        return 9;
      case Difficulty.intermediate:
        return 16;
      case Difficulty.expert:
        return 16;
      case Difficulty.custom:
        return 10;
    }
  }

  int get cols {
    switch (this) {
      case Difficulty.beginner:
        return 9;
      case Difficulty.intermediate:
        return 16;
      case Difficulty.expert:
        return 30;
      case Difficulty.custom:
        return 10;
    }
  }

  int get mines {
    switch (this) {
      case Difficulty.beginner:
        return 10;
      case Difficulty.intermediate:
        return 40;
      case Difficulty.expert:
        return 99;
      case Difficulty.custom:
        return 15;
    }
  }

  String get hiveKey {
    switch (this) {
      case Difficulty.beginner:
        return 'best_beginner';
      case Difficulty.intermediate:
        return 'best_intermediate';
      case Difficulty.expert:
        return 'best_expert';
      case Difficulty.custom:
        return 'best_custom';
    }
  }

  String get labelKey {
    switch (this) {
      case Difficulty.beginner:
        return 'diff_beginner';
      case Difficulty.intermediate:
        return 'diff_intermediate';
      case Difficulty.expert:
        return 'diff_expert';
      case Difficulty.custom:
        return 'diff_custom';
    }
  }
}
