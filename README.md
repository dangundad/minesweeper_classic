# Minesweeper Classic

클래식 지뢰찾기 게임 앱. 3가지 난이도와 커스텀 모드를 지원합니다.

## 주요 기능

- **난이도**: Beginner(9x9, 10개), Intermediate(16x16, 40개), Expert(16x30, 99개)
- **커스텀 모드**: 행/열/지뢰 수 직접 설정
- **첫 클릭 안전**: 첫 탭 위치에 지뢰가 없도록 보장
- **깃발 표시**: 롱프레스로 깃발 토글
- **자동 열기**: 인접 지뢰가 0인 셀 자동 확장
- **타이머**: 첫 클릭부터 경과 시간 측정
- **최고 기록**: 난이도별 최단 시간 기록
- **추가 목숨**: 보상형 광고 시청으로 추가 목숨 획득
- **통계**: 난이도별 게임 통계
- **진동 피드백**: 지뢰 폭발, 깃발 설치 시 햅틱 피드백
- **광고**: 배너, 전면, 보상형 광고
- **프리미엄**: 인앱 구매를 통한 광고 제거

## 기술 스택

- **Flutter** (Android + iOS)
- **GetX** (상태 관리, 라우팅, 다국어)
- **Hive_CE** (로컬 저장소)
- **flutter_screenutil** (반응형 UI)
- **flex_color_scheme** (FlexScheme.indigo 테마)
- **google_mobile_ads** (AdMob 광고)
- **Firebase** (Analytics, Crashlytics)

## 프로젝트 구조

```
lib/
├── main.dart
├── hive_registrar.g.dart
└── app/
    ├── admob/           # 광고 (배너, 전면, 보상형)
    ├── bindings/        # GetX 바인딩
    ├── controllers/     # 게임(Cell/보드/탐색), 홈, 설정, 통계, 히스토리
    ├── data/            # enum (Difficulty, GameStatus)
    ├── pages/           # 홈, 게임(셀위젯/결과), 히스토리, 통계, 설정, 프리미엄
    ├── routes/          # 라우팅
    ├── services/        # HiveService, PurchaseService, AppRatingService
    ├── theme/           # FlexScheme.indigo 테마
    ├── translate/       # 다국어 (한국어 기본)
    ├── utils/           # 상수 (HiveKeys, AppUrls, PurchaseConstants)
    └── widgets/         # 컨페티 오버레이
```

## 설치 및 실행

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## 라이선스

Proprietary - DangunDad (com.dangundad)
