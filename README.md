# Qixer Buyer App - Flutter Project

هذا المستودع يحتوي على تطبيق Flutter كامل لتطبيق Qixer Buyer مع دعم جميع المنصات.

## الملفات المرفوعة

### منصة iOS
- **ios/Runner.xcodeproj**: ملف مشروع Xcode الرئيسي
- **ios/Runner.xcworkspace**: مساحة عمل Xcode
- **ios/Runner/**: مجلد التطبيق الرئيسي
  - `AppDelegate.swift`: نقطة دخول التطبيق
  - `Info.plist`: إعدادات التطبيق
  - `GoogleService-Info.plist`: إعدادات Firebase
  - `Runner.entitlements`: صلاحيات التطبيق
- **ios/Flutter/**: ملفات Flutter المطلوبة
- **ios/Pods/**: مكتبات CocoaPods
- **ios/Podfile**: قائمة المكتبات المطلوبة

### منصة Android
- **android/**: مجلد مشروع Android
- **android/app/**: ملفات التطبيق الرئيسية
- **android/app/src/**: ملفات المصدر
- **android/app/build.gradle.kts**: إعدادات البناء

### منصات أخرى
- **web/**: ملفات تطبيق الويب
- **windows/**: ملفات تطبيق Windows
- **linux/**: ملفات تطبيق Linux
- **macos/**: ملفات تطبيق macOS

### ملفات Flutter
- **lib/**: كود Flutter الرئيسي
- **assets/**: الصور والأيقونات
- **pubspec.yaml**: إعدادات المشروع والمكتبات

## كيفية فتح المشروع في Xcode (iOS)

1. قم بفتح Xcode
2. اختر "Open a project or file"
3. انتقل إلى مجلد المشروع وافتح ملف `ios/Runner.xcworkspace`
4. تأكد من تثبيت CocoaPods قبل فتح المشروع

## كيفية فتح المشروع في Android Studio

1. قم بفتح Android Studio
2. اختر "Open an existing project"
3. انتقل إلى مجلد المشروع وافتح مجلد `android/`

## متطلبات النظام

### iOS
- Xcode 14.0 أو أحدث
- iOS 12.0 أو أحدث
- CocoaPods

### Android
- Android Studio
- Android SDK
- Flutter SDK

### Flutter
- Flutter SDK 3.0 أو أحدث
- Dart SDK

## تثبيت المكتبات

### iOS
```bash
cd ios
pod install
```

### Flutter
```bash
flutter pub get
```

## بناء التطبيق

### iOS
1. افتح `ios/Runner.xcworkspace` في Xcode
2. اختر الجهاز المستهدف (iOS Simulator أو جهاز حقيقي)
3. اضغط على زر Build (⌘+B)
4. اضغط على زر Run (⌘+R) لتشغيل التطبيق

### Android
1. افتح المشروع في Android Studio
2. اختر الجهاز المستهدف
3. اضغط على زر Run لتشغيل التطبيق

### Flutter
```bash
# تشغيل التطبيق
flutter run

# بناء التطبيق للـ release
flutter build ios
flutter build apk
flutter build web
```

## ملاحظات مهمة

- تأكد من تحديث Bundle Identifier في إعدادات المشروع
- تأكد من إضافة شهادات التوقيع المناسبة
- تأكد من تحديث إعدادات Firebase إذا لزم الأمر
- تأكد من تحديث مفاتيح API في ملفات الإعدادات

## هيكل المشروع

```
qixer_buyer/
├── ios/                    # ملفات iOS
├── android/                # ملفات Android
├── lib/                    # كود Flutter
├── assets/                 # الصور والأيقونات
├── web/                    # ملفات الويب
├── windows/                # ملفات Windows
├── linux/                  # ملفات Linux
├── macos/                  # ملفات macOS
└── pubspec.yaml           # إعدادات المشروع
```

## الدعم

للمساعدة أو الاستفسارات، يرجى التواصل مع فريق التطوير.

## الترخيص

هذا المشروع محمي بموجب حقوق النشر.
