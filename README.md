<div align="center">

<!-- TODO: 프로젝트 앱아이콘/로고 이미지 추가 -->
<!-- <img src="./docs/images/app_icon.png" width="120" /> -->

# 바로 보내 (SendNow)

**친구들과의 정산, 이제 복잡하지 않게 — 바로 정산하고, 바로 보내세요.**

![Swift](https://img.shields.io/badge/Swift-5.0-orange?logo=swift)
![iOS](https://img.shields.io/badge/iOS-17.0+-blue?logo=apple)
![UIKit](https://img.shields.io/badge/UI-UIKit-lightgrey)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-brightgreen)
![License](https://img.shields.io/badge/License-MIT-yellow)

<!-- TODO: App Store 출시 시 다운로드 배지/버튼 추가 -->
<!-- [![App Store](https://img.shields.io/badge/App_Store-Download-black?logo=app-store)](https://apps.apple.com/) -->

</div>

---

## 📑 목차

- [프로젝트 소개](#-프로젝트-소개)
- [주요 기능](#-주요-기능)
- [기술 스택](#-기술-스택)
- [아키텍처](#-아키텍처)
- [폴더 구조](#-폴더-구조)
- [기술적 고민 / 트러블 슈팅](#-기술적-고민--트러블-슈팅)
- [컨벤션](#-컨벤션)
- [라이브러리 의존성](#-라이브러리-의존성)

---

## 📖 프로젝트 소개

### 배경 및 동기
모임이 끝난 뒤 누가 얼마를 냈고, 누가 누구에게 얼마를 보내야 하는지 계산하는 일은 번거롭습니다.
메신저로 영수증을 공유하고, 계산기로 일일이 나누고, 다시 계좌번호를 물어보는 과정에서 **정산이 미뤄지고 관계가 어색해지는 경험**은 누구나 한 번쯤 겪어봤을 것입니다.

**바로 보내(SendNow)** 는 이러한 **정산 프로세스의 마찰을 최소화**하는 것을 목표로 시작된 프로젝트입니다.
모임 단위로 지출을 관리하고, 자동으로 1/N을 계산하고, 송금까지 한 번에 연결되는 흐름을 통해 "지금 바로 정산하고, 바로 보낼 수 있는" 경험을 제공합니다.

### 핵심 가치
- 💨 **Speed** — 모임 생성부터 송금까지 최소한의 탭으로
- 👥 **Social** — 친구 초대·그룹 관리·요청 기능으로 자연스러운 정산 흐름
- 📊 **Transparency** — 누가 얼마를 냈고, 누가 얼마를 받아야 하는지 한눈에

---

## ✨ 주요 기능

> <!-- TODO: 각 기능별 스크린샷 이미지 추가 필요 -->
> 📸 스크린샷은 추후 `docs/screenshots/` 경로에 추가 예정입니다.

| 기능 | 설명 |
| --- | --- |
| **🔐 로그인 / 회원가입** | 카카오 로그인, Apple 로그인, 이메일 가입 지원 |
| **🏠 홈** | 친구 목록, 받을/보낼 금액 요약, 친구 요청 확인 |
| **👥 정산모임** | 모임별 지출 등록, 자동 1/N 계산, 개별 송금 내역 확인 |
| **📋 모임 리스트** | 정산 모임 생성·초대·참여 관리 |
| **🔔 알림** | FCM 기반 실시간 푸시 알림 (모임 활동, 정산 요청 등) |
| **🙋 마이페이지** | 프로필·계좌 정보 관리, 앱 설정 |

<!-- TODO: 기능별 스크린샷 예시
<div align="center">
  <img src="./docs/screenshots/home.png" width="200" />
  <img src="./docs/screenshots/settle.png" width="200" />
  <img src="./docs/screenshots/notification.png" width="200" />
</div>
-->

---

## 🛠 기술 스택

| 카테고리 | 사용 기술 |
| --- | --- |
| **Language** | Swift 5.0 |
| **Minimum iOS** | iOS 17.0 |
| **UI** | UIKit (Code-based Auto Layout, No Storyboard 지향) |
| **Architecture** | MVVM |
| **Reactive** | RxSwift, RxCocoa, RxGesture, RxAlamofire |
| **Networking** | Alamofire, URLSession (`NetworkSessionManager` 래퍼) |
| **Dependency Manager** | Swift Package Manager (SPM) |
| **DI** | Initializer Injection (수동 DI) |
| **Push / BaaS** | Firebase Cloud Messaging, APNs |
| **3rd-party Auth** | Kakao SDK, Apple Sign In |
| **CI/CD** | <!-- TODO: 도입 예정 (GitHub Actions / Fastlane 등) --> 미도입 |

---

## 🏛 아키텍처

<!-- TODO: 아키텍처 다이어그램 이미지 추가 -->
<!-- <img src="./docs/architecture.png" width="700" /> -->

본 프로젝트는 **MVVM(Model-View-ViewModel)** 패턴을 기반으로, 기능(Feature) 단위로 모듈을 분리하여 구성되어 있습니다.

### 레이어별 역할

```
┌─────────────────────────────────────────────────────┐
│                    Presentation                     │
│    ViewController  ←→  View (UIKit, RxCocoa)        │
│            ↑↓ (Rx bindings)                         │
│                   ViewModel                         │
└────────────────────────┬────────────────────────────┘
                         │ Input / Output
┌────────────────────────▼────────────────────────────┐
│                      Domain                         │
│        Model / DTO / Business Use Case              │
└────────────────────────┬────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────┐
│                       Data                          │
│    Service (Alamofire)  ←→  RemoteAPI / UserDefaults│
└─────────────────────────────────────────────────────┘
```

- **Presentation**: `ViewController`는 UI 이벤트를 `ViewModel`로 전달하고, `ViewModel`에서 방출된 상태를 구독하여 `View`에 반영합니다.
- **Domain**: 기능별 `Domain/` 디렉터리에 위치한 모델·DTO·열거형이 비즈니스 표현을 담당합니다.
- **Data**: `Network/` 디렉터리의 `Service` 계층이 API 통신을 담당하고, 결과를 `ViewModel`에 `Observable`로 제공합니다.

### 의존성 흐름
`View → ViewController → ViewModel → Service(Network) → Domain Model`

- 상위 레이어만 하위 레이어를 알고, 하위 레이어는 상위를 모릅니다.
- `ViewModel`은 `UIKit`을 import하지 않으며, UI 프레임워크에 의존하지 않습니다.

### 선택 이유
- **UIKit + RxSwift + MVVM** 조합은 iOS 진영에서 검증된 조합으로, 비동기 이벤트 스트림 처리가 많은 **정산/네트워킹 중심 앱**에 적합합니다.
- Clean Architecture보다 가벼운 MVVM을 택해 **개인 프로젝트의 러닝 커브와 유지보수 비용의 균형**을 맞췄습니다.
- 기능 단위 폴더 구조(Feature-first)로, 화면 추가 시 수평 확장이 용이합니다.

---

## 📂 폴더 구조

```
SendNow/
├── AppDelegate.swift
├── SceneDelegate.swift
├── MainTabBarController.swift
├── BaseUIViewController.swift
├── Info.plist
├── environment.xcconfig
│
├── Signin/                  # 로그인 / 회원가입
│   ├── Domain/
│   ├── View/
│   ├── ViewController/
│   └── ViewModel/
│
├── Home/                    # 홈 (친구 목록, 요약)
│   ├── Domain/
│   ├── View/
│   ├── ViewController/
│   └── ViewModel/
│
├── GroupList/               # 모임 리스트
│   ├── Domain/
│   ├── View/
│   ├── ViewController/
│   └── ViewModel/
│
├── SettleGroup/             # 정산 모임 상세
│   ├── Domain/
│   ├── View/
│   ├── ViewController/
│   └── ViewModel/
│
├── Notificatiion/           # 알림
│   ├── Domain/
│   ├── Cell/
│   ├── ViewController/
│   └── ViewModel/
│
├── MyPage/                  # 마이페이지
│   ├── Domain/
│   ├── View/
│   ├── ViewController/
│   └── ViewModel/
│
├── Network/                 # API 통신 계층
│   ├── Friend/
│   ├── Group/
│   ├── Member/
│   └── Notification/
│
├── Util/                    # 공통 유틸
│   ├── Enum/
│   ├── Network/             # NetworkSessionManager
│   ├── Protocol/
│   └── UI/                  # 공통 UI 컴포넌트
│
├── Extension/               # Foundation / UIKit 확장
├── Font/                    # Pretendard Custom Font
├── Resource/                # 이미지 리소스
└── Assets.xcassets/
```

---

## 🔍 기술적 고민 / 트러블 슈팅

### 1. Pretendard 커스텀 폰트 nil 반환 이슈

#### 문제 상황
`UIFont(name: "Pretendard-Regular", size: 16)` 호출 시 **특정 빌드 환경에서 간헐적으로 `nil`이 반환**되어 런타임에 기본 시스템 폰트로 떨어지는 현상이 발생했습니다.
디자인 시스템의 타이포그래피가 일부 기기에서만 어긋나 보이는 QA 이슈로 이어졌습니다.

#### 원인 분석
- `Info.plist`의 `UIAppFonts`에는 폰트 **파일명**이 등록되어 있지만, `UIFont(name:)`이 요구하는 값은 **PostScript 이름**이기 때문에 두 값이 일치하지 않으면 `nil`이 반환됩니다.
- 또한 커스텀 폰트가 아직 등록되지 않은 이른 타이밍(`AppDelegate` 초기화 이전)에 접근할 경우에도 `nil`이 발생할 수 있습니다.

#### 해결 방법
1. `FontCategory` enum으로 폰트 이름을 **한 곳에서만 관리**하도록 단일 진입점을 만들었습니다.
2. 폰트 로드 시 `nil` 가드를 두어 누락이 발생해도 **시스템 폰트로 안전하게 폴백**되도록 처리했습니다.
3. 빌드 시 폰트 파일이 번들에 누락되지 않도록 프로젝트 세팅을 점검했습니다.

#### 결과
- 모든 기기에서 디자인 시스템 폰트가 **100% 일관되게 렌더링**되는 것을 확인했습니다.
- 이후 새로운 웨이트(FontWeight)를 추가해도 한 곳만 수정하면 되어, **폰트 관련 수정 비용이 단일 파일 수준으로 축소**되었습니다.

---

### 2. 홈 화면 데이터 로드 타이밍 문제

#### 문제 상황
앱 첫 진입 시, 홈 화면에 표시되어야 할 **친구 목록과 정산 요약이 간헐적으로 빈 상태로 노출**되고, 뒤늦게 한 번에 갱신되면서 화면이 깜빡이는 UX 이슈가 발생했습니다.

#### 원인 분석
- 로그인 직후 `TabBarController`가 올라오는 타이밍과, 네트워크 호출 결과가 도착하는 타이밍이 어긋나 있었습니다.
- 초기 데이터를 `viewDidLoad`가 아닌 `viewWillAppear`에서 매번 호출하면서, **불필요한 중복 요청**과 **레이스 컨디션**이 동시에 발생하고 있었습니다.

#### 해결 방법
1. 데이터 로드 트리거를 **명시적인 진입 시점**(탭 전환 / 앱 포그라운드 복귀)으로 재정의했습니다.
2. `ViewModel`에서 `Observable`을 `share(replay:)`로 감싸 **동일한 응답을 여러 뷰가 구독**하면서도 요청은 1회만 발생하도록 조정했습니다.
3. `NotificationCenter`를 통해 도메인 이벤트(정산 완료, 친구 수락 등) 발생 시에만 선택적으로 재요청하도록 전환했습니다.

#### 결과
- 홈 화면 진입 시 **중복 API 호출 제거**로 네트워크 요청 수 감소.
- 빈 화면 깜빡임이 제거되어 **첫 진입 UX가 체감상 훨씬 안정적**으로 개선되었습니다.

---

## 📐 컨벤션

### Git Flow / Branch 전략
단순화된 **GitHub Flow** 기반으로 운영합니다.

```
main         ← 배포 가능한 안정 버전
 └─ develop  ← 통합 개발 브랜치
     ├─ feature/{기능명}      # 신규 기능 개발
     ├─ refactor/{대상}       # 리팩토링
     ├─ fix/{이슈}            # 버그 수정
     └─ design/{대상}         # UI/디자인 작업
```

- 모든 작업은 `develop`에서 브랜치를 분기하여 PR로 병합합니다.
- `main`은 릴리스 태그와 동기화됩니다.

### Commit 메시지 규칙
Gitmoji와 타입 prefix를 함께 사용합니다.

```
<gitmoji> <type>/<간단한 설명>
```

| 이모지 | 용도 |
| --- | --- |
| ✨ | 신규 기능 추가 (feat) |
| ♻️ | 리팩토링 (refactor) |
| 🐛 | 버그 수정 (fix) |
| 🔧 | 설정/환경 수정 (chore) |
| 💄 | 디자인/스타일 변경 (design) |
| 📝 | 문서 수정 (docs) |

**예시**
```
✨ Feature delete user's bank information
♻️ Change Data Load Timing & Update Home View
🔧 Update Reselection-Remainder-User-View
```

### 코드 컨벤션
- **네이밍**: Swift API Design Guidelines 준수 (UpperCamelCase / lowerCamelCase)
- **파일 구조**: `MARK: -` 주석으로 Properties / Life Cycle / UI / Binding / Action 섹션 구분
- **View 작성**: Storyboard 지양, **코드 기반 Auto Layout** 우선 사용
- **ViewModel**: `UIKit`을 import하지 않으며, Input/Output 패턴으로 흐름 정리
- **RxSwift**: `DisposeBag`은 해당 객체 수명에 맞게 선언, 순환 참조 방지를 위해 `[weak self]` 기본 적용

---

## 📦 라이브러리 의존성

모든 의존성은 **Swift Package Manager (SPM)** 로 관리됩니다.

| 라이브러리 | 선택 이유 |
| --- | --- |
| **RxSwift / RxCocoa** | 비동기 이벤트 스트림·UI 바인딩을 일관된 방식으로 처리하기 위해 채택 |
| **RxGesture** | `UITapGestureRecognizer` 등 UIKit 제스처를 Rx 스트림으로 추상화 |
| **Alamofire** | `URLSession`을 더 선언적으로 다루기 위한 표준 네트워킹 라이브러리 |
| **RxAlamofire** | 네트워크 응답을 `Observable`로 변환해 ViewModel 레이어와 자연스럽게 연결 |
| **Firebase (Core / Messaging)** | FCM 기반 푸시 알림 구현 |
| **Kakao SDK (RxKakaoSDKAuth 등)** | 국내 사용자 대상 카카오 로그인/공유 기능 제공 |
| **IQKeyboardManagerSwift** | 키보드가 TextField를 가리는 문제를 전역적으로 해결 |
| **Tabman** | 커스텀 탭 페이지 UI 구현을 위해 사용 (UIKit 기반) |
| **Charts** | 정산 내역·지출 통계 시각화에 활용 |
| **Toast-Swift** | 경량 피드백(토스트) 메시지를 간결하게 노출 |

---

<div align="center">

Made with ❤️ by <a href="https://github.com/haansohee">haansohee</a>

</div>
