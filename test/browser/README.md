# Browser regression tests

Install Flutter, Node.js 20 or newer, and Google Chrome. From the repository root, build the app and run the tests:

```sh
flutter build web --release --no-web-resources-cdn
npm ci --prefix test/browser
npm test --prefix test/browser
```

The suite serves `build/web` on an ephemeral loopback port. Each test starts in an isolated browser context with an empty portfolio. The build flag keeps the Flutter renderer resources local.

## Native backup smoke check

On Android and iOS, use an empty test portfolio. In Settings, export all portfolios and verify that the system share sheet offers a JSON file. Save it locally, then choose it under Restore backup. Verify that the system picker returns the file, Merge shows a preview, and the portfolio total stays the same after restoring.
