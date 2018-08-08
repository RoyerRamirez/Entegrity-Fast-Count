# Entegrity-Fast-Count
Energy Audit App

## Building and Running
Dependencies are required for compiling this app.

1. Clone or Pull from remote. Make sure Xcode is closed.
2. Download and install the GUI version of [CocoaPods](https://cocoapods.org/app).
3. Launch CocoaPods, and go to File -> New Podfile from Xcode Project.
4. Browse to `Fast Count.xcodeproj` and click open.
5. In the resulting Podfile, after line 10, `# Pods for Fast Count`, insert the following lines:

```
  pod 'SSZipArchive'
  pod 'MBProgressHUD'
```

6. Click Install.
7. Open `Fast Count.xcworkspace`. **DO NOT USE FAST COUNT.XCODEPROJ ANYMORE FOR DEVELOPMENT.**
8. Click Run.

## Authors

* [Jasper Reddin](https://github.com/DrOverbuild)
* [Royer Ramirez Ruiz](https://github.com/RoyerRamirez)
