# Boardy - iOS

개발 환경
- Xcode 16.4
- Swift 6.1.2
- iOS 18.5

```bash
Boardy/
│
├─ Configs/                     // 앱 전역 설정
│   └─ AppConfig.swift          // 환경 변수, API Base URL 등
│
├─ Models/
│   ├─ Auth/                   // 인증 관련 모델
│   │   ├─ LoginRequest.swift
│   │   ├─ LoginResponse.swift
│   │   ├─ SignUpRequest.swift
│   │   ├─ SignUpResponse.swift
│   │   ├─ RefreshTokenRequest.swift
│   │   └─ RefreshTokenResponse.swift
│   │
│   └─ Common/                 // 공통 모델
│       └─ ErrorResponse.swift
│
├─ Services/
│   ├─ auth/                    // 인증 관련 API 호출 및 DTO
│   │   ├─ AuthService.swift    // 토큰 재발급, 검증, 로그아웃 로직
│   │   ├─ LoginService.swift   // 로그인/회원가입 API 호출
│   │   ├─ SignUp.swift         // 회원가입 API DTO/서비스
│   │   └─ TokenManager.swift    // Refresh Token 재발급 로직 + Keychain 호출 + 결과 처리
│   │
│   └─ common/                   // 인증과 상관없이 공통으로 사용하는 서비스
│       └─ APIService.swift      // GET/POST 공통 요청, Authorization 헤더 처리
│
├─ Utilities/                   // 공통 유틸리티
│   └─ KeychainHelper.swift     // Keychain 저장, 읽기, 삭제 기능
│
├─ Views/                       // 화면 단위 SwiftUI View
│   ├─ Auth/                    // 인증 관련 화면
│   │   ├─ LoginView.swift
│   │   └─ SignUpView.swift
│   │
│   ├─ RootView.swift           // 앱 시작 시 Splash → 로그인/메인 판단
│   ├─ SplashView.swift         // 스플래시 화면
│   ├─ MainView.swift           // 메인 화면
│   └─ OnboardingView.swift     // 온보딩 화면
...
```
