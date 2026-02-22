import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Languages extends Translations {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ko'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'settings': 'Settings',
      'save': 'Save',
      'cancel': 'Cancel',
      'ok': 'OK',
      'share': 'Share',
      'reset': 'Reset',
      'done': 'Done',
      'home': 'Home',
      'play': 'Play',
      'play_again': 'Play Again',
      'dark_mode': 'Dark Mode',
      'rate_app': 'Rate App',
      'more_apps': 'More Apps',

      // App
      'app_name': 'Minesweeper',
      'home_subtitle': 'Find all mines without detonating one!',

      // Difficulty
      'diff_beginner': 'Beginner',
      'diff_intermediate': 'Intermediate',
      'diff_expert': 'Expert',
      'diff_custom': 'Custom',

      // Custom sliders
      'custom_rows': 'Rows',
      'custom_cols': 'Cols',
      'custom_mines': 'Mines',

      // Game
      'best_records': 'Best Records',
      'no_record': '--',
      'result_win': 'You Win!',
      'result_lose': 'Boom!',
      'result_lose_sub': 'You hit a mine. Try again!',
      'result_time': 'Time: @{t}s',
      'best_record': '🏆 Best: @{t}s',

      // Extra life
      'extra_life': 'Extra Life!',
      'extra_life_desc': 'Your next mine click is safe.',
      'extra_life_offer': 'Watch an ad to get a second chance!',
      'watch_ad': 'Watch',
    },
    'ko': {
      'settings': '설정',
      'save': '저장',
      'cancel': '취소',
      'ok': '확인',
      'share': '공유',
      'reset': '초기화',
      'done': '완료',
      'home': '홈',
      'play': '플레이',
      'play_again': '다시 하기',
      'dark_mode': '다크 모드',
      'rate_app': '앱 평가',
      'more_apps': '더 많은 앱',

      // 앱
      'app_name': '지뢰 찾기',
      'home_subtitle': '지뢰를 밟지 말고 모두 찾아보세요!',

      // 난이도
      'diff_beginner': '초급',
      'diff_intermediate': '중급',
      'diff_expert': '고급',
      'diff_custom': '커스텀',

      // 커스텀 슬라이더
      'custom_rows': '행',
      'custom_cols': '열',
      'custom_mines': '지뢰',

      // 게임
      'best_records': '최고 기록',
      'no_record': '--',
      'result_win': '클리어!',
      'result_lose': '펑! 💥',
      'result_lose_sub': '지뢰를 밟았습니다. 다시 도전하세요!',
      'result_time': '시간: @{t}초',
      'best_record': '🏆 최고: @{t}초',

      // 부활
      'extra_life': '부활!',
      'extra_life_desc': '다음 지뢰 클릭은 안전합니다.',
      'extra_life_offer': '광고를 보고 한 번 더 기회를 받으세요!',
      'watch_ad': '보기',
    },
  };
}
