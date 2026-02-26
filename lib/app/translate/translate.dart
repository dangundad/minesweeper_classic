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
      'open_history': 'History',
      'open_stats': 'Stats',
      'clear_all': 'Clear All',
      'refresh': 'Refresh',
      'no_history': 'No history',
      'unknown_event': 'Unknown Event',
      'history_subtitle': 'Screen: @screen / Route: @route',
      'total_events': 'Total Events',
      'today_events': 'Today',
      'week_events': 'This Week',
      'unique_routes': 'Routes',
      'unique_screens': 'Screens',
      'top_events': 'Top Events',

      // App
      'app_name': 'Minesweeper',
      'home_subtitle': 'Find all mines without detonating one!',
      'select_difficulty': 'SELECT DIFFICULTY',

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
      'best_record': '?룇 Best: @{t}s',

      // Extra life
      'extra_life': 'Extra Life!',
      'extra_life_desc': 'Your next mine click is safe.',
      'extra_life_offer': 'Watch an ad to get a second chance!',
      'watch_ad': 'Watch',
      'premium_title': 'Premium',
      'premium_subtitle': 'Unlock all content, remove ads, and use all premium features.',
      'premium_benefits': 'Premium Benefits',
      'premium_benefit_remove_ads': 'No Ads',
      'premium_benefit_unlimited': 'Unlock all features',
      'premium_benefit_statistics': 'Detailed statistics',
      'premium_plan_title': 'Choose a plan',
      'premium_plan_weekly': 'Weekly',
      'premium_plan_weekly_desc': '7 days',
      'premium_plan_monthly': 'Monthly',
      'premium_plan_monthly_desc': '30 days',
      'premium_plan_yearly': 'Yearly',
      'premium_plan_yearly_desc': '365 days',
      'premium_purchase': 'Purchase Premium',
      'premium_restore': 'Restore Purchase',
      'premium_owned': 'Premium is active',
      'premium_purchase_note': 'The purchase will be restored automatically when you restart the app.',
      'purchase_error': 'Purchase Error',
      'purchase_unavailable': 'In-app purchases are unavailable',
      'purchase_failed': 'Purchase failed. Please try again.',
      'restore_error': 'Restore failed. Please try again.',
      'purchase_success': 'Purchase Completed',
      'premium_ready': 'Premium is now active.',
      'go_premium': 'Go Premium',
      'go_premium_subtitle': 'Unlock all paid features',
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
      'play': '시작',
      'play_again': '다시 하기',
      'dark_mode': '다크 모드',
      'rate_app': '앱 평가',
      'more_apps': '더 많은 앱',
      'open_history': '히스토리',
      'open_stats': '통계',
      'clear_all': '전체 삭제',
      'refresh': '새로고침',
      'no_history': '기록이 없습니다',
      'unknown_event': '알 수 없는 이벤트',
      'history_subtitle': '화면: @screen / 경로: @route',
      'total_events': '총 이벤트',
      'today_events': '오늘',
      'week_events': '이번 주',
      'unique_routes': '고유 경로',
      'unique_screens': '고유 화면',
      'top_events': '상위 이벤트',
      // App
      'app_name': '지뢰 찾기',
      'home_subtitle': '지뢰를 건드리지 않고 모두 찾으세요!',
      'select_difficulty': '난이도 선택',
      // Difficulty
      'diff_beginner': '초급',
      'diff_intermediate': '중급',
      'diff_expert': '고급',
      'diff_custom': '커스텀',
      // Custom sliders
      'custom_rows': '행',
      'custom_cols': '열',
      'custom_mines': '지뢰',
      // Game
      'best_records': '최고 기록',
      'no_record': '--',
      'result_win': '승리!',
      'result_lose': '펑!',
      'result_lose_sub': '지뢰를 밟았어요. 다시 시도해요!',
      'result_time': '시간: @{t}초',
      'best_record': '🏆 최고: @{t}초',
      // Extra life
      'extra_life': '추가 생명!',
      'extra_life_desc': '다음 지뢰 클릭이 안전해져요.',
      'extra_life_offer': '광고를 시청하고 한 번 더 기회를 받으세요!',
      'watch_ad': '시청',
    },
  };
}

    



