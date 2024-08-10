# 채팅 앱 (Flutter) - 클린 아키텍처

이 프로젝트는 Flutter를 사용하여 클린 아키텍처를 적용한 채팅 앱입니다. STOMP 프로토콜을 통해 실시간 메시징을 구현하였으며, 클린 아키텍처의 원칙을 따릅니다.

## 프로젝트 구조

프로젝트는 다음과 같은 주요 레이어로 구성됩니다:

```

lib/
├── data/
│ ├── datasources/
│ │ └── stomp_client.dart
│ ├── models/
│ │ └── chat_message_model.dart
│ └── repositories/
│ └── chat_repository_impl.dart
├── domain/
│ ├── entities/
│ │ └── chat_message.dart
│ ├── repositories/
│ │ └── chat_repository.dart
│ └── usecases/
│ ├── send_message.dart
│ └── subscribe_to_chat.dart
├── presentation/
│ ├── pages/
│ │ └── chat_screen.dart
│ └── viewmodels/
│ └── chat_viewmodel.dart
└── main.dart

```

## 기능

- **메시지 전송**: 사용자가 채팅방에 메시지를 전송할 수 있습니다.
- **실시간 메시지 수신**: STOMP를 통해 실시간으로 메시지를 수신하고 UI에 반영합니다.

## 설치 및 실행

1. **Flutter 설치**: Flutter SDK가 설치되어 있어야 합니다. [Flutter 설치 가이드](https://flutter.dev/docs/get-started/install)를 참고해 주세요.

2. **프로젝트 클론**:

   ```sh
   git clone https://github.com/your-repo/chat-app.git
   cd chat-app
   ```

3. **의존성 설치**:

   ```sh
   flutter pub get
   ```

4. **STOMP 서버 설정**: `lib/data/datasources/stomp_client.dart` 파일에서 STOMP 서버의 URL을 설정합니다.

   ```dart
   // lib/data/datasources/stomp_client.dart
   class StompClientSetup {
     static StompClient setupClient() {
       return StompClient(
         config: StompConfig(
           url: 'ws://your-stomp-server-url',
           onConnect: (StompFrame frame) {
             print('Connected to STOMP server');
           },
           onDisconnect: (StompFrame frame) {
             print('Disconnected from STOMP server');
           },
         ),
       );
     }
   }
   ```

5. **앱 실행**:

   ```sh
   flutter run
   ```

## 코드 구조

### Domain Layer

- **Entities**: 비즈니스 도메인의 핵심 개념을 정의합니다. (`ChatMessage`)
- **Repositories**: 데이터 접근을 추상화하는 인터페이스를 정의합니다. (`ChatRepository`)
- **Use Cases**: 애플리케이션의 비즈니스 로직을 구현합니다. (`SendMessage`, `SubscribeToChat`)

### Data Layer

- **Models**: 외부 데이터 소스와의 데이터 변환을 처리합니다. (`ChatMessageModel`)
- **Repositories**: `ChatRepository` 인터페이스를 구현하고 STOMP 클라이언트를 사용하여 데이터 소스와 상호작용합니다. (`ChatRepositoryImpl`)

### Presentation Layer

- **ViewModels**: UI 상태를 관리하고 비즈니스 로직을 호출합니다. (`ChatViewModel`)
- **Pages**: 사용자 인터페이스를 정의합니다. (`ChatScreen`)

### 예시로 살펴보는 변경 대응

**가정**: 새로운 기능 추가, 예를 들어, 사용자가 메시지에 첨부파일을 추가할 수 있는 기능을 추가한다고 가정합니다.

1. **클린 아키텍처**:

   - **Domain Layer**: 새로운 기능에 따라 `ChatMessage` 엔티티에 `attachments` 필드를 추가하고, 관련 유스케이스를 추가합니다.
   - **Data Layer**: 첨부파일 처리와 관련된 데이터 소스 및 리포지토리 구현을 수정합니다. 도메인 레이어의 인터페이스는 변경되지 않으므로, 비즈니스 로직과 데이터 접근 로직은 명확히 분리되어 있습니다.
   - **Presentation Layer**: UI에서 첨부파일을 추가하고 표시하는 기능을 추가합니다. ViewModel에서 새로운 유스케이스를 사용하여 데이터를 처리합니다. 비즈니스 로직이나 데이터 접근 레이어의 변경에 영향을 받지 않습니다.

2. **비클린 아키텍처**:
   - **Business Logic and Data Access**: 비즈니스 로직과 데이터 접근 코드가 혼합되어 있는 경우, 메시지에 첨부파일을 추가하는 기능을 추가하기 위해 많은 부분을 수정해야 할 수 있습니다. 비즈니스 로직 수정과 데이터 처리 로직 수정을 동시에 해야 하므로, 코드 변경의 범위가 넓어지고 오류가 발생할 가능성이 높아집니다.
   - **UI**: UI 수정 시 비즈니스 로직 및 데이터 접근에 영향을 미치는 경우가 많아, UI 변경 작업이 복잡해집니다.
