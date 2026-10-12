# Talorys — Android app

Native Android wrapper for Yishai's Talorys instance (https://talorys-lxl5w9o0-web.pages.dev).
A full-screen WebView shell: one login, the session cookie persists, back button navigates
inside the app, file picker + keyboard behave normally, SSE chat streaming works, external
links open in the system browser, dark mode follows the phone.

- Package: `bot.tab.talorys.yishai` · minSdk 24 (Android 7) · targetSdk 35
- Source: `src/`, resources + launcher icon: `res/`, manifest: `AndroidManifest.xml`

## Build (no Gradle / no Android Studio)

`build.sh` builds a signed release APK with the plain SDK build-tools:
aapt2 → javac → d8 → zipalign → apksigner.

Requirements:
- JDK 17 (`apt install openjdk-17-jdk-headless`)
- Android command-line SDK at `~/android-sdk` with `build-tools;35.0.0` and `platforms;android-35`
  (`sdkmanager "build-tools;35.0.0" "platforms;android-35"`)
- A release keystore. `build.sh` expects `talorys.jks` (alias `talorys`) and a `keystore.json`
  with `{"store_password": "..."}` in the directory named by `KS` (default
  `/home/user/tab/state/talorys-android-keystore`). The keystore is NOT in this repo —
  updates must be signed with the same key or Android refuses to install over the old version.

```bash
# bump versionCode / versionName on every release
VC=2 VN=1.1 ./build.sh      # → build/Talorys.apk
```

## Limitations
- No push notifications (Talorys has an in-app bell list only; same as the website).
- Not run on an emulator during development (the build box has no KVM); verified with
  `aapt dump badging` + `apksigner verify` and a scripted login against the live site.
