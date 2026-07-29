# Usman Portfolio — Flutter Web

## Run locally
```
flutter pub get
flutter run -d chrome
```

## Build for GitHub Pages
```
flutter build web --base-href "/usmanbhatti0822-ops.github.io/"
```
(If this repo IS your root `username.github.io` repo, use `--base-href "/"` instead.)

Then upload everything inside `build/web/` to your GitHub repo root and enable
GitHub Pages (Settings → Pages → branch: main → folder: /root).
