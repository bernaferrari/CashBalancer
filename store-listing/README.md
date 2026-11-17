# Screenshot artwork

The Play Store artwork can be generated as eight images each in `en-US/phone/`, `en-US/tablet7/`, and `en-US/tablet10/`. It was rendered with [Screenshot Studio](https://github.com/bernaferrari/screenshot-studio) from real Android emulator captures using the app's built-in sample portfolio. The README uses unframed 7-inch tablet captures. Portfolio uses the `tablet7-landscape` profile and Rebalance uses `tablet7` in portrait.

To refresh the captures, use a disposable Android emulator. The tour clears the app's data on that emulator.

```sh
flutter build apk --profile
adb -s emulator-5554 install -r build/app/outputs/flutter-apk/app-profile.apk
npx screenshot-studio tour --profile phone,tablet7,tablet10,desktop --serial emulator-5554
npx screenshot-studio check
npx screenshot-studio export --locale en-US
```

Replace the serial with the capture emulator's serial. `gallery.json`, `en-US/copy.json`, `profiles.json`, and `theme.css` control the artwork. No assets are uploaded by these commands.

To refresh only the two README captures after installing the APK, run:

```sh
npx screenshot-studio tour --profile tablet7-landscape --only 01-portfolio --serial emulator-5554
npx screenshot-studio tour --profile tablet7 --only 02-rebalance --serial emulator-5554
```
