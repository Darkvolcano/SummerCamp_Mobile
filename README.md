# Summer Camp Mobile 🏕️

A Flutter-based mobile application for managing summer camp activities,
registrations, and real-time communication between parents and staff.
Features live streaming, AI-powered chat assistant, facial recognition
attendance, and photo management.

## 👥 User Roles

### Parent (Phụ Huynh)

Primary user managing their children's camp participation and monitoring activities

### Staff (Nhân Viên)

Camp staff responsible for activity management, camper supervision, and parent communication

---

## 📱 Parent Features

### 👶 Camper Management

- **Register Camper Profile**:
  - Full name, date of birth, gender
  - Health records and medical information
  - Emergency contact details
  - Dietary restrictions and allergies
- **Manage Multiple Campers**: Handle multiple children profiles
- **Update Information**: Edit camper details anytime

### 🏕️ Camp Registration

- **Browse Available Camps**:
  - View camp details (name, description, location, dates)
  - Check age requirements and capacity
  - See pricing and discount information
- **Register for Camps**: Enroll campers in selected programs
- **Track Registration Status**: Monitor approval status (Pending/Approved/Rejected)
- **Registration History**: Access past and current enrollments

### 📺 Live Streaming & Activity Monitoring

- **Watch Live Activities**:
  - Real-time video streams of camp activities
  - Join as viewer (RECV_ONLY mode)
  - Automatic host camera detection
  - Responsive layout adapts to host camera status
- **Activity Tracking**: See which activity camper is currently in
- **Multiple Streams**: Switch between different activity livestreams

### 📸 Photo Gallery

- **View Camp Photos**:
  - Browse photos uploaded by staff
  - Organized by camp and activity
  - Filter by date and event
- **Photo Albums**: Access dedicated albums for each camp
- **Download & Share**: Save photos of their camper
- **Real-time Updates**: Get notified when new photos are added

### 📰 Information & Communication

- **Blog Posts**: Read camp-related articles, news, and updates
- **Feedback System**:
  - Rate camp experience
  - Comment on specific aspects
  - View other parent reviews
- **AI Chat Assistant**:
  - Ask questions about camp schedules
  - Get real-time camper location/activity info
  - Learn about policies and procedures
  - Receive general camp information
- **Direct Messaging**:
  - Chat with assigned staff members
  - Receive incident notifications
  - Ask questions about their camper
  - Get daily updates

### 🔔 Notifications

Push notifications for:

- Camp registration approval/rejection
- Activity start reminders
- Incident reports
- New photos uploaded
- Staff messages
- Important announcements

---

## 📱 Staff Features

### 📅 Schedule Management

- **Work Schedule**:
  - View assigned camps and shifts
  - Daily/weekly/monthly calendar view
  - Activity timeline for each camp
- **Camp Overview**: Access camp details and participant lists
- **Activity Planning**: See upcoming activities

### ✅ Attendance System

- **Manual Check-in**:
  - Camper list with photos
  - Mark present/absent/late
  - Add notes for each camper
- **Facial Recognition**:
  - Scan camper faces for automated attendance
  - Automatic matching with stored facial data
  - Fallback to manual if recognition fails
- **Attendance Reports**:
  - Daily attendance summaries
  - Individual camper history
  - Export capabilities

### 📺 Live Streaming (Host Mode)

- **Create & Host Streams**:
  - Real-time video/audio broadcasting
  - Camera controls (enable/disable, flip front/back)
  - Microphone controls (mute/unmute)
  - See connected parent viewers
- **Stream Management**:
  - Start/stop streaming
  - Monitor viewer count
  - Stable connection handling

### 📸 Photo Management

- **Upload Photos**:
  - Take photos directly in app
  - Select from device gallery
  - Bulk upload multiple photos
- **Organize Albums**:
  - Tag photos with camp and activity
  - Add descriptions
  - Preview before publishing

### 🚨 Incident Reporting

- **Report Incidents**:
  - Injury reports
  - Behavioral concerns
  - Equipment problems
  - Medical emergencies
  - Safety violations
- **Incident Details**:
  - Date/time stamp
  - Associated camp and activity
  - Involved camper(s)
  - Severity level (Low/Medium/High/Critical)
  - Description and actions taken
  - Photo/video evidence
- **Parent Notification**: Automatically alert parents
- **Incident History**: Track all reports

### 💬 Communication

- **Parent Messaging**:
  - Discuss incident reports
  - Provide daily updates
  - Answer parent questions
  - Share camper achievements
- **Staff Chat**: Internal communication with other staff
- **Broadcast Messages**: Send announcements to all camp parents

### 🔔 Notifications

Receive alerts for:

- Shift reminders
- Activity start times
- Parent messages
- Urgent incidents
- System updates

---

## 🏗️ Mobile App Architecture

Clean Architecture with feature-based modularization:

```bash
lib/
├── core/
│   ├── config/              # App routes, themes, constants
│   ├── error/               # Exception & error handling
│   ├── network/             # API client, interceptors, socket
│   ├── utils/               # Formatters, validators, helpers
│   └── widgets/             # Shared UI components
│
└── features/
    ├── activity/            # Activities management
    ├── ai_chat/             # AI chat assistant
    ├── album/               # Photo albums
    ├── attendance/          # Attendance tracking (manual & facial)
    ├── auth/                # Authentication
    ├── blog/                # Blog posts
    ├── camp/                # Camp management
    ├── camper/              # Camper profiles
    ├── chat/                # Parent-Staff messaging
    ├── home/                # Home screens
    ├── livestream/          # Live streaming (VideoSDK)
    ├── notification/        # Push notifications
    ├── payment/             # Payment handling
    ├── profile/             # User profiles
    ├── promotion/           # Promotions & discounts
    ├── registration/        # Camp registration
    └── report/              # Staff incident reports
```

Feature Structure
Each feature follows Clean Architecture pattern:

```bash
feature_name/
├── data/                    # Data sources, models, repositories impl
├── domain/                  # Entities, repository interfaces
└── presentation/            # Screens, widgets, state management
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: `>=3.0.0`
- **Dart SDK**: `>=3.0.0`
- **Android Studio** or **Xcode** (for iOS)
- **VideoSDK Account**: [Sign up here](https://www.videosdk.live/)

### Installation Steps

1. **Clone the repository**:

   ```bash
   git clone https://github.com/Darkvolcano/SummerCamp_Mobile
   cd SummerCamp_Mobile
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Configure VideoSDK Token**:

   Update token in livestream files:

   - `lib/features/livestream/presentation/state/livestream_provider.dart`
   - `lib/features/camp/presentation/screens/camp_schedule_detail_screen.dart`
   - `lib/features/registration/presentation/screens/registration_detail_screen.dart`

4. **Setup Firebase** (for notifications):

   - Add `google-services.json` to `android/app/`
   - Add `GoogleService-Info.plist` to `ios/Runner/`

5. **Configure Permissions**:

   **Android** (`android/app/src/main/AndroidManifest.xml`):

   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.RECORD_AUDIO" />
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   ```

   **iOS** (`ios/Runner/Info.plist`):

   ```xml
   <key>NSCameraUsageDescription</key>
   <string>Camera access for live streaming and attendance</string>
   <key>NSMicrophoneUsageDescription</key>
   <string>Microphone access for live streaming</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>Photo library access to upload photos</string>
   ```

6. **Run the app**:

   ```bash
   flutter run
   ```

---

## 🎥 Live Streaming Implementation

### VideoSDK Integration

Uses [VideoSDK](https://www.videosdk.live/) for WebRTC streaming:

**Two Modes**:

- `Mode.SEND_AND_RECV`: Staff broadcasts video/audio
- `Mode.RECV_ONLY`: Parents watch only

**Dynamic Layout**:

- Host camera OFF → Grid layout
- Host camera ON → Large host view + thumbnails below

**How It Works**:

```dart
// ParticipantGrid checks all participants
1. Loop through visible participants
2. Find first participant with:
   - mode == SEND_AND_RECV
   - active video stream
3. Display host layout or grid layout accordingly
```

**Real-time Updates**:

- Listen to `Events.streamEnabled` on all participants
- Automatic layout adjustment when camera status changes
- Works seamlessly for both host and viewers

### Key Components

**ILSScreen**: Room initialization  
**ILSView**: Main livestream interface  
**ParticipantGrid**: Adaptive layout manager  
**ParticipantTile**: Individual video renderer  
**LivestreamControls**: Role-based controls

---

## 👤 Facial Recognition Attendance

### Mobile Flow

1. **Face Scan Screen**: Staff opens camera
2. **Capture**: Takes photo of camper's face
3. **Processing**: Sends to recognition service
4. **Result**: Auto-marks attendance if matched
5. **Fallback**: Manual attendance if fails

### Requirements

- Good lighting conditions
- Clear face visibility
- Stable camera

---

## 🤖 AI Chat Assistant

### What It Does

- Answers camp-related questions
- Provides real-time camper location
- Explains schedules and activities
- General information queries

### Sample Questions

- "Where is my child right now?"
- "What activities today?"
- "When does camp end?"
- "What to pack?"

---

## 📦 Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  flutter_localizations:
    sdk: flutter

  # State Management
  provider: ^6.1.5+1

  # Networking
  dio: ^5.9.0 # API requests
  http: ^1.5.0 # HTTP client
  socket_io_client: ^3.1.2 # Real-time socket connection

  # Local Storage
  shared_preferences: ^2.5.3

  # Video & Streaming
  videosdk: ^3.0.0 # Live streaming (VideoSDK)
  flutter_vlc_player: ^7.4.4 # Video player

  # Image Handling
  image_picker: ^1.1.2 # Pick images from device
  wechat_assets_picker: ^9.0.2 # Multi-image picker

  # Firebase
  firebase_core: ^2.24.0
  firebase_messaging: ^14.7.6 # Push notifications
  firebase_storage: ^13.0.2 # Cloud storage

  # UI Components
  table_calendar: ^3.0.8 # Calendar widget
  flutter_rating_bar: ^4.0.1 # Star ratings
  lottie: ^3.0.0 # Animations

  # Utilities
  intl: ^0.20.2 # Date/time formatting
  jwt_decoder: ^2.0.1 # JWT token handling
  url_launcher: ^6.3.1 # Open URLs
  permission_handler: ^12.0.0 # Device permissions
  device_info_plus: ^11.3.0 # Device information
  cupertino_icons: ^1.0.8 # iOS icons
  connectivity_plus: ^6.0.3 # Check connect internet
```

---

## 🎨 App Themes

### Parent Theme (`AppTheme`)

**Light Theme**:

```dart
Primary: #FFA726 (Orange Sun)
Accent: #FF7043 (Orange Bold)
Background: #FFF8E7 (Light Yellow)
Secondary: #4FC3F7 (Light Blue)
Yellow: #FFEB3B (Vibrant Yellow)
Surface: White
```

**Dark Theme**:

```dart
Primary: #FF7043 (Orange Accent)
Secondary: #4FC3F7 (Light Blue)
Background: #1B1B2F (Dark Blue)
Surface: #222244 (Dark Purple)
AppBar: #2C2C54 (Medium Purple)
```

**Features**:

- Material 3 design
- Rounded corners (12-16px)
- Card elevation: 4 (light), 2 (dark)
- Summer-themed warm colors

### Staff Theme (`StaffTheme`)

**Light Theme Only**:

```dart
Primary: #1565C0 (Dark Blue)
Accent: #42A5F5 (Light Blue)
Background: #F5F9FF (Very Light Blue)
Surface: White
```

**Features**:

- Professional blue palette
- Material 3 design
- Rounded corners (12-16px)
- Card elevation: 4
- Clean, business-oriented appearance

---

## 📱 Navigation Flow

### Parent Flow

```bash
Login → Home
  ├── Camper List → Form/Detail
  ├── Camp List → Camp Detail → Register
  ├── My Registrations → Detail → Livestream
  ├── Photo Gallery → Albums
  ├── Blog List → Detail
  ├── Feedback Form
  ├── Messages → Chat
  ├── AI Assistant
  └── Notifications
```

### Staff Flow

```bash
Login → Work Schedule
  ├── Camp Schedule
  │   ├── Attendance (Manual/Face)
  │   ├── Livestream Host
  │   ├── Upload Photos
  │   └── Report Incident
  ├── Messages → Parent Chat
  └── Notifications
```

---

## 📱 Build Commands

### Development

```bash
flutter run
```

### Android Release

```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS Release

```bash
flutter build ios --release
```

---

## 🐛 Troubleshooting

### Livestream Issues

✓ Check VideoSDK token validity

✓ Verify camera/mic permissions

✓ Test internet connection

### Face Recognition Issues

✓ Ensure good lighting

✓ Check camera permissions

✓ Use manual fallback

### Photo Upload Issues

✓ Verify storage permissions

✓ Check file size limits

✓ Confirm network connectivity

---

## 🚀 Future Mobile Features

- [ ] Offline mode with local sync
- [ ] Multi-language (VI/EN)
- [ ] QR code attendance
- [ ] Video call feature
- [ ] Dark mode
- [ ] Tablet optimization
- [ ] Widget support

---

## 📄 License

MIT License

## 👥 Team

Mobile Development Team

## 📞 Support

- Email: <khangphamchuchi@gmail.com>
- Issues: GitHub Issues

---

**Version**: 1.0.0  
**Platform**: iOS & Android  
**Flutter Version**: 3.0.0+
