# Android Fastlane

Chay tu thu muc `android/`:

```bash
cd android
```

## Lenh chinh

```bash
bundle exec fastlane android doctor
```

Kiem tra cau hinh local.

```bash
bundle exec fastlane android build
```

Build file AAB release.

```bash
bundle exec fastlane android validate
```

Build va validate upload voi Google Play, khong publish.

```bash
bundle exec fastlane android deploy_internal
```

Build va day len Internal testing.

```bash
bundle exec fastlane android deploy_closed
```

Build va day len Closed testing.

```bash
bundle exec fastlane android deploy
```

Build va day len track tuy chon.

## Tham so co the doi

```bash
bundle exec fastlane android build build_number:46
bundle exec fastlane android build build_name:1.0.1 build_number:46
```

```bash
bundle exec fastlane android deploy track:internal
bundle exec fastlane android deploy track:alpha
bundle exec fastlane android deploy track:beta
bundle exec fastlane android deploy track:production
```

```bash
bundle exec fastlane android deploy track:alpha release_status:draft
bundle exec fastlane android deploy track:alpha release_status:completed
```

```bash
bundle exec fastlane android deploy_closed build_number:46
bundle exec fastlane android deploy_closed build_name:1.0.1 build_number:46
```

## Track

```text
internal   Internal testing
alpha      Closed testing
beta       Open testing / beta track
production Production
```

## Release status

```text
draft       Tao ban nhap tren Google Play
completed   Gui/phat hanh len track da chon
```

## File can co

```text
android/key.properties
android/fastlane/play-store-credentials.json
```
