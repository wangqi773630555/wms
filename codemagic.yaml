workflows:
  flutter-ios-unsigned:
    name: Flutter iOS unsigned IPA
    instance_type: mac_mini_m2
    max_build_duration: 60

    environment:
      flutter: stable
      xcode: latest
      cocoapods: default

    scripts:
      - name: Get Flutter packages
        script: flutter pub get

      - name: Install CocoaPods dependencies
        script: |
          find . -name "Podfile" -execdir pod install \;

      - name: Build iOS release without code signing
        script: flutter build ios --release --no-codesign

      - name: Pack unsigned IPA
        script: |
          set -e
          cd build/ios/iphoneos
          APP_NAME=$(find . -maxdepth 1 -name "*.app" -type d | head -n 1 | sed 's|^\./||')
          echo "APP_NAME=$APP_NAME"
          mkdir -p Payload
          cp -R "$APP_NAME" Payload/
          zip -qr myapp.ipa Payload
          ls -lh myapp.ipa

    artifacts:
      - build/ios/iphoneos/myapp.ipa
