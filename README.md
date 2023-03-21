# ChatSolution-Sample-iOS
챗 솔루션 샘플입니다.
# Coinlive Chat Solution

### 시작하기

1. 프로젝트에서 사용되는 Customer 정보를 얻기위해 Customer API KEY를 **Coinlive에 문의 후** 발급 받으세요.
2. 권한 추가를 위해 **Bundle Identifier를 Coinlive측에 제공**해주세요. (Xcode → Targets → (application) → General → Identity → **Bundle Identifier**)

<aside>
💡 위 과정을 거치지 않으면 서비스를 이용할 수 없습니다.

</aside>

## CoinliveChatSDK

### 요구사항 및 스펙

- Supported platform : iPhone, iPad
- iOS target minimum version : 13.0
- Swift version : 5.0
- Support Quick help
- Dependencies
    - GoogleUtilities : 7.10.0
    - FirebaseAuth : 10.3.0
    - FirebaseCore : 10.3.0
    - FirebaseFirestore : 10.3.0
    - FirebaseDatabase : 10.3.0
    - FirebaseDynamicLinks : 10.3.0
    - Moya : 15.0
    - Logging : 1.4.0

### 설치 (예정)

Cocoa pod

1. Cocoa Pod를 초기화 후 Podfile안에 아래 라인을 추가해주세요.
    1. UIKit을 사용할 경우 아래 CoinliveChatSDK 설치는 skip합니다.
    
    ```ruby
    pod ‘CoinliveChatSDK’
    ```
    
2. 의존성을 추가해주세요
    
    ```bash
    pod install
    ```
    

### 초기화

1. AppDelegate파일에 해당 코드를 추가해주세요
    
    ```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions 
    launchOptions: [UIApplication.LaunchOptionsKey: **Any**]?) -> Bool {
    
    // Coinlive 초기화
    // isDebug(bool) : true - Development Server / false - Product Server
    // isShowHttpLog(bool) : true - console에 http관련 로그를 표시 / false - http 관련 로그를 미표시
    // locale(Locale) : 
    _ = Coinlive(isDebug: **true**, isShowHttpLog: **false, locale: Locale.current**)
    }
    ```
    

### 인증과정

1. **API Key로 등록된 고객의 정보를 받아오세요.**
    
    ```swift
    CoinliveRestApi().getCustomerInfo(name: String, 
    onSuccess: callback(customer), 
    onFailed: callback(error))
    ```
    
2. **사용자 인증** 
    
    **익명 사용자**의 경우 CoinliveAuthentication를  통해 익명 sign-In을 진행합니다.
    
    ```swift
    CoinliveAuthentication.shared.signInWithUnknownUser(signInCallback:
    			 {(firebaseId, error) in
                if let _ = error {
                } else {
    								/// 성공
                }
            })
    ```
    
    **회원 사용자**의 경우 인증 과정을 거쳐야 합니다. 과정은 다음과 같습니다.
    
    1. CoinliveRestApi를 통해 uuid로 Custom token 발급 받습니다.
    2. CoinliveAuthentication를 통해 1번에서 발급받은 Custom token으로 Signing후 Firebase id 발급받습니다.
3. **인증 사용자 회원가입**
    1. 인증 과정에서 얻은 Firebase id로 CoinliveRestApi에서 멤버를 확인합니다. 멤버를 확인 후 상태 값에 따라 적절한 대응을 합니다. (*상태 값이 NONE일 경우 가입 진행이 가능합니다.)
    2. 이후 CoinliveRestApi를 통해 닉네임을 중복체크합니다. 
    3. (Optional) 프로필 사진을 추가할 경우 CoinliveRestApi를 통해 이미지를 업로드합니다.
    4. 2번, 3번과정을 거치고 받은 정보로 회원가입을 위해 CoinliveRestApi를 통해 회원가입을 진행합니다.
4. **로그인** 
    1. (2)번의 회원 사용자 인증 과정을 진행합니다.
    2. Firebase id로 CoinliveRestApi에서 멤버를 확인합니다. 멤버를 확인 후에 상태 값에 따라 적절한 대응을 합니다. (*상태 값이 ACTIVE일 경우 로그인이 가능합니다.)

Sample 확인하기 >

## CoinliveChatUIKit

### 요구사항 및 스펙

- Supported platform : iPhone
- iOS target minimum version : iOS 13.0
- Swift version : 5.0
- Support anonymous user, signed user
- Dependencies
    - CoinliveChatSDK

### 설치

Cocoa pod

1. Cocoa Pod를 초기화 후 Podfile안에 아래 라인을 추가해주세요.
    
    ```ruby
    pod ‘CoinliveChatUIKit’ 
    ```
    
2. 의존성을 추가해주세요
    
    ```bash
    pod install
    ```
    

### 채팅 표시하기

1. 보여줄 Channel 선택
    
    CoinliveChatSDK에서 얻은 Customer 정보로 아래 api를 통해 채널리스트를 조회합니다.
    
    ```swift
    CoinliveRestApi().getChannelList(name: String,
    															 onSuccess: callback(channelList), 
    															 onFailed: callback(error))
    ```
    
2. Coinlive Auth를 통해 Signing User인지 확인합니다.
    
    ```swift
    if CoinliveAuthentication.shared.isAnonymousUser() { 
    // 익명 사용자 
    	return
    } 
    
    // 회원 사용자 
    ```
    
3. 익명사용자가 아닐경우 Member 정보를 호출합니다. 
    
    ```swift
    // 회원 사용자 
    CoinliveRestApi().getCustomerMemberInfo(
                    onSuccess: { customerUser in
                    },
                    onFailed: { error in
                    })
    ```
    
4. CoinliveChatUIKit의 CoinliveChatViewController를 보여줍니다.
    
    ```swift
    // channel은 (1)에서 얻은 channel list에서 선택합니다.
    // customerName은 SDK를 통해 얻은 Customer 정보를 이용합니다.
    // user는 익명사용자의 경우 nil, 회원 사용자일경우 (3)에서 얻은 customerUser값을 이용합니다.
    
    let coinliveChatViewController = CoinliveChatViewController()
    coinliveChatViewController.channel = channel
    coinliveChatViewController.customerName = self.customerName
    coinliveChatViewController.customerUser = user
    self.navigationController?.pushViewController(coinliveChatViewController, animated: true)
    ```
    

## 알려진 이슈 

1. Runtime중 Coinlive sdk 관련 symbol 문제가 발생할 시 Podfile에 아래 코드를 추가해주세요. 

```ruby
post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
		end
	end
end
```

1. Firebase 관련 Permission denied 
    1. 해당 이슈는 확인 중입니다.
