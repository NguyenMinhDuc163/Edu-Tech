---
name: flutter-android-fastlane-google-play
description: Configure, review, or debug Flutter Android Fastlane delivery to Google Play. Use when setting up android/fastlane/Appfile, android/fastlane/Fastfile, android/Gemfile, Play Store service account JSON upload credentials, Android release signing, app bundle builds, internal testing, closed testing, release_status, versionCode/build_number, or Google Play upload errors for a Flutter project.
---

# Flutter Android Fastlane Google Play

## Operating Rules

- Do not run `flutter build appbundle`, `fastlane android deploy*`, or any upload command unless the user explicitly asks to build or upload.
- Prefer minimal configuration. Do not add many environment variables. Use fixed local paths unless the user asks for a configurable setup.
- Never print secret values from `play-store-credentials.json`, keystores, passwords, or `key.properties`. Only report existence, path, readability, and missing keys.
- Treat `android/key.properties` and `android/fastlane/play-store-credentials*.json` as local secrets that must be ignored by Git.
- Use `ruby -c`, `bundle install`, `bundle exec fastlane lanes`, and `bundle exec fastlane android doctor` as non-uploading validation.
- Use FVM automatically when `.fvm/flutter_sdk/bin/flutter` exists; otherwise use `flutter` from PATH.

## User Inputs Needed

Ask for or discover these before finalizing setup:

- Android package name, for example `com.example.app`.
- Desired target track:
  `internal` for internal testing, `alpha` for closed testing, `beta` for open testing, `production` for production.
- Desired release behavior:
  `draft` to leave a draft in Play Console, or `completed` to submit/roll out to the selected track.
- Whether the user permits build/upload commands during the current turn.
- Android signing setup:
  release keystore plus `android/key.properties`.
- Google Play service account JSON file:
  place it at `android/fastlane/play-store-credentials.json`.
- Versioning policy:
  update `pubspec.yaml` `version: x.y.z+N`, or pass `build_number:N` to Fastlane.

For first-time Play Console setup, guide the user to create/link a Google Cloud project, enable Google Play Android Developer API, create a service account JSON key, then invite the service account email in Google Play Console with release/testing permissions.

## Files To Create Or Update

Create these files in the target Flutter project:

```text
android/Gemfile
android/fastlane/Appfile
android/fastlane/Fastfile
android/fastlane/README.md
```

Ensure these local-only files exist or are documented:

```text
android/key.properties
android/fastlane/play-store-credentials.json
```

Update `.gitignore`:

```gitignore
android/fastlane/play-store-credentials*.json
```

Most Flutter templates already ignore `android/key.properties`, `*.jks`, and `*.keystore` in `android/.gitignore`. Add those ignores if missing.

## Gemfile

Use a minimal Android Gemfile:

```ruby
source "https://rubygems.org"

gem "fastlane"
```

Run from `android/`:

```bash
bundle install
```

If Bundler complains about missing gems, run `bundle install`. If macOS system Ruby causes permission problems, suggest:

```bash
bundle config set path vendor/bundle
bundle install
```

## Appfile

Use a fixed JSON key path and package name:

```ruby
json_key_file("fastlane/play-store-credentials.json")
package_name("com.example.app")
```

Replace `com.example.app` with the real Android application id from `android/app/build.gradle*`.

## Fastfile

Use this lane structure unless the project already has a better local convention:

```ruby
require "shellwords"

default_platform(:android)

PROJECT_ROOT = File.expand_path("../..", __dir__)
AAB_PATH = File.join(PROJECT_ROOT, "build", "app", "outputs", "bundle", "release", "app-release.aab")
DEFAULT_TRACK = "internal"

def project_root_sh(command)
  sh("cd #{PROJECT_ROOT.shellescape} && #{command}")
end

def flutter_bin
  fvm_flutter = File.join(PROJECT_ROOT, ".fvm", "flutter_sdk", "bin", "flutter")
  return fvm_flutter.shellescape if File.executable?(fvm_flutter)

  "flutter"
end

def appfile_value(key)
  CredentialsManager::AppfileConfig.try_fetch_value(key)
end

def expanded_path_from_android(path)
  return nil if path.to_s.empty?

  File.expand_path(path, File.expand_path("..", __dir__))
end

def require_existing_file(path, label)
  UI.user_error!("#{label} is not configured.") if path.to_s.empty?

  expanded_path = expanded_path_from_android(path)
  UI.user_error!("#{label} not found at #{expanded_path}") unless File.file?(expanded_path)

  expanded_path
end

platform :android do
  desc "Check local Android release setup"
  lane :doctor do
    package_name = appfile_value(:package_name)
    json_key = appfile_value(:json_key_file)

    UI.user_error!("Android package name is not configured.") if package_name.to_s.empty?
    require_existing_file("key.properties", "Android signing file")
    require_existing_file(json_key, "Google Play service account JSON")

    UI.success("Android package: #{package_name}")
    UI.success("Signing file: #{File.join(File.expand_path('..', __dir__), 'key.properties')}")
    UI.success("Google Play JSON: #{expanded_path_from_android(json_key)}")
  end

  desc "Run Flutter tests"
  lane :test do
    project_root_sh("#{flutter_bin} test")
  end

  desc "Build signed Android App Bundle"
  lane :build do |options|
    build_args = []
    build_args << "--build-name #{options[:build_name].shellescape}" if options[:build_name]
    build_args << "--build-number #{options[:build_number].to_s.shellescape}" if options[:build_number]

    project_root_sh("#{flutter_bin} pub get")
    project_root_sh("#{flutter_bin} build appbundle --release #{build_args.join(' ')}".strip)

    UI.success("AAB generated at #{AAB_PATH}")
  end

  desc "Validate Google Play upload without publishing"
  lane :validate do |options|
    track = options[:track] || DEFAULT_TRACK

    doctor
    build(options)

    upload_to_play_store(
      track: track,
      aab: AAB_PATH,
      validate_only: true,
      skip_upload_metadata: true,
      skip_upload_changelogs: true,
      skip_upload_images: true,
      skip_upload_screenshots: true
    )
  end

  desc "Upload a new build to Google Play internal testing"
  lane :deploy_internal do |options|
    deploy(options.merge(track: "internal"))
  end

  desc "Upload a new build to Google Play closed testing"
  lane :deploy_closed do |options|
    deploy(options.merge(track: "alpha", release_status: "completed"))
  end

  desc "Upload a new build to Google Play"
  lane :deploy do |options|
    track = options[:track] || DEFAULT_TRACK
    release_status = options[:release_status] || "draft"

    doctor
    build(options)

    upload_to_play_store(
      track: track,
      aab: AAB_PATH,
      release_status: release_status,
      changes_not_sent_for_review: false,
      skip_upload_metadata: true,
      skip_upload_changelogs: true,
      skip_upload_images: true,
      skip_upload_screenshots: true
    )
  end
end
```

## Lane Commands

Run from `android/`:

```bash
bundle exec fastlane android doctor
bundle exec fastlane android build
bundle exec fastlane android validate
bundle exec fastlane android deploy_internal
bundle exec fastlane android deploy_closed
bundle exec fastlane android deploy
```

Common parameters:

```bash
bundle exec fastlane android build build_number:46
bundle exec fastlane android build build_name:1.0.1 build_number:46
bundle exec fastlane android deploy track:alpha release_status:draft
bundle exec fastlane android deploy track:alpha release_status:completed
bundle exec fastlane android deploy_closed build_name:1.0.1 build_number:46
```

Track map:

```text
internal   Internal testing
alpha      Closed testing
beta       Open testing / beta track
production Production
```

Release status:

```text
draft       Create a draft release in Play Console
completed   Submit/roll out to the selected track
```

## Google Play Setup Guidance

Use this track when the user does not know how to get `android/fastlane/play-store-credentials.json`, or asks what `play-store-credentials*.json` is.

Guide the user step by step. If they send a screenshot, identify the current screen and give only the next action or small set of actions. Avoid jumping ahead.

### Credential Track

1. Start in Google Play Console:

```text
https://play.google.com/console
```

2. Go to:

```text
Setup -> API access
```

If the user is instead on `Users and permissions`, explain that this screen is for granting access later; they still need to create the Google Cloud service account JSON first.

3. Create or link a Google Cloud project from `API access`. If the user has no Google Cloud project, tell them to create a new one from the Play Console API access flow. Use a simple project name such as:

```text
ed-tech-play-release
```

4. In Google Cloud, ensure the correct project is selected in the top project selector. Then enable:

```text
Google Play Android Developer API
androidpublisher.googleapis.com
```

If the API page shows `Status: Enabled` or a `Disable API` button, the API is already enabled.

5. On the Google Play Android Developer API page, open the `Credentials` tab and click:

```text
Create credentials
```

6. On the `Credential Type` screen:

```text
Which API are you using?
Google Play Android Developer API

What data will you be accessing?
Application data
```

Tell the user not to choose `User data`; Fastlane needs a service account, not OAuth user login.

7. On `Create service account`, use:

```text
Service account name: fastlane-google-play
Service account ID: fastlane-google-play
Service account description: Upload Android app bundle to Google Play using Fastlane
```

Then click:

```text
Create and continue
```

8. On `Permissions (optional)`, leave `Select a role` empty and click `Continue`.

9. On `Principals with access (optional)`, leave `Service account users role` and `Service account admins role` empty, then click `Done`.

10. After the service account is created, copy its email. It looks like:

```text
fastlane-google-play@PROJECT_ID.iam.gserviceaccount.com
```

11. Create the JSON key:

```text
Service account -> Keys -> Add key -> Create new key -> JSON -> Create
```

The browser downloads a `.json` file. Tell the user to rename it to:

```text
play-store-credentials.json
```

and place it at:

```text
android/fastlane/play-store-credentials.json
```

12. Return to Google Play Console:

```text
Users and permissions -> Invite new users
```

Use the service account email as the invited email.

13. Grant app-level access for the target app. For internal or closed testing, choose only:

```text
View app information (read-only)
View app quality information (read-only)
Release apps to testing tracks
Manage testing tracks and edit tester lists
```

Do not select `Admin (all permissions)` unless the user explicitly wants broad account administration. Do not select `Release to production` when the user only wants internal or closed testing.

14. Save or invite the user. Service accounts do not need to accept an email invitation like a human user.

15. Verify locally:

```bash
cd android
bundle exec fastlane android doctor
bundle exec fastlane run validate_play_store_json_key json_key:fastlane/play-store-credentials.json
```

Do not ask the user to paste JSON contents. Ask them to place the file at the expected path.

## Android Signing

Confirm `android/app/build.gradle*` has release signing wired to `android/key.properties`.

Typical `key.properties` shape:

```properties
storePassword=...
keyPassword=...
keyAlias=...
storeFile=...
```

Do not create a release keystore unless the user explicitly asks. If creating one, explain that the keystore must be backed up; losing it can block app updates unless Play App Signing recovery is available.

## Versioning

Flutter Android uses `pubspec.yaml`:

```yaml
version: 1.0.0+45
```

The value after `+` is Android `versionCode`. Google Play requires every uploaded build to use a new, higher `versionCode`.

If the user deploys build `47` and then build `48` to the same track while `47` is in review, `48` becomes the newer release candidate for that track. Build `47` is not deleted, but it can become superseded. Do not reuse old build numbers.

## README For Target Project

Keep `android/fastlane/README.md` short. Include commands and parameters only; avoid long setup prose unless the user asks.

Recommended contents:

````markdown
# Android Fastlane

Run from `android/`:

```bash
bundle exec fastlane android doctor
bundle exec fastlane android build
bundle exec fastlane android validate
bundle exec fastlane android deploy_internal
bundle exec fastlane android deploy_closed
bundle exec fastlane android deploy
```

Parameters:

```bash
bundle exec fastlane android build build_name:1.0.1 build_number:46
bundle exec fastlane android deploy track:alpha release_status:completed
bundle exec fastlane android deploy_closed build_number:46
```

Tracks:

```text
internal, alpha, beta, production
```
````

## Validation

Use these checks before any real build/upload:

```bash
ruby -c android/fastlane/Fastfile
ruby -c android/fastlane/Appfile
cd android && bundle exec fastlane lanes
cd android && bundle exec fastlane android doctor
```

If the user asks to verify the JSON key only:

```bash
cd android
bundle exec fastlane run validate_play_store_json_key json_key:fastlane/play-store-credentials.json
```

## Troubleshooting

- Missing gems: run `cd android && bundle install`.
- Bundler version mismatch: install the Bundler version named in `android/Gemfile.lock`, or regenerate the lock with the local Bundler if appropriate.
- `Google Play service account JSON not found`: place the file at `android/fastlane/play-store-credentials.json`.
- `403 permission denied`: grant the service account the required app permissions in Google Play Console.
- Package/app not found: confirm `package_name(...)` matches the Play Console app package and Android `applicationId`.
- Duplicate version code: increase `pubspec.yaml` build number after `+` or pass a higher `build_number`.
- Upload succeeds but still waits in Play Console: Google review and Managed publishing cannot be bypassed by Fastlane. Turn off Managed publishing if automatic publication after approval is desired.
