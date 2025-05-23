# K.S.R.V. Njord App
[![Static Analysis](https://github.com/ksrvnjord/app.main/actions/workflows/static-analysis.yml/badge.svg)](https://github.com/ksrvnjord/app.main/actions/workflows/static-analysis.yml)
[![iOS build](https://github.com/ksrvnjord/app.main/actions/workflows/build-ios.yml/badge.svg)](https://github.com/ksrvnjord/app.main/actions/workflows/build-ios.yml)
[![Codemagic build status](https://api.codemagic.io/apps/66d76a60e20a048bd162379d/66d76a60e20a048bd162379c/status_badge.svg)](https://codemagic.io/app/66d76a60e20a048bd162379d/66d76a60e20a048bd162379c/latest_build)

De Flut-ter versie.

## How do I?

- Follow [`https://docs.flutter.dev/get-started/install`](https://docs.flutter.dev/get-started/install)
- Clone the repository
- Start working in your own branch (`git checkout -b`)
- Download the dependencies: `flutter pub get`
- Start an emulator or connect your phone
- Run the app: `flutter run`

> For running the app on web, use `flutter run -d chrome --web-browser-flag "--disable-web-security"`


## Code Generation
Code generation for JSON serialization and deserialization provides an automated approach to converting objects to and from JSON. It not only saves valuable development time by avoiding manual code creation but also ensures consistent and error-free data processing. This technique is particularly useful when data models evolve, as changes in serialization and deserialization code can be automatically implemented, ensuring consistency between the schema and code. Furthermore, code generation can apply optimizations that outperform manual implementations, while also ensuring type safety in strongly typed programming languages. When dealing with multiple platforms or languages, it also guarantees uniform serialization/deserialization logic. In short, code generation for JSON interactions enhances efficiency, reduces errors, and facilitates maintenance and debugging.
We use [json_serializable](https://pub.dev/packages/json_serializable) for code generation. 
Run the code generation with:

```bash
dart run build_runner watch
```


### Automatically Running Static Analysis
When you open a Pull Request, a static analysis is automatically performed, which may take a few minutes. We recommend running this locally before opening a Pull Request.
- Run the following command in the root of this project to install this pre-push hook:
```bash
chmod +x run_static_analysis.sh; cp run_static_analysis.sh .git/hooks/pre-push; chmod 700 .git/hooks/pre-push
```
This runs all the static analysis tools we use.

## Architecture
You can navigate between different pages using ["named routes" (Navigator)](https://api.flutter.dev/flutter/widgets/Navigator-class.html).

### Project Structure
The folder structure is feature-based. This means that all code related to a feature is in a separate folder. This makes it easier to navigate the code and to know where to go to make changes. The code for features is further divided into folders each serving a specific role. The structure looks like this:


- **lib**
    -  **src**
        - **features**
            - **announcements**
                - **api**
                - **models**
                - **pages**
                - **widgets**
            - **events**
                - ...
            - ...


A feature thus has an `api`, `models`, `pages`, and `widgets` folder. The `api` folder contains the code the app uses to fetch data from the server. The `models` folder contains the models used to fetch and send data to the server. The `pages` folder contains the code for the various pages associated with the feature. The `widgets` folder contains the code for widgets used on the various pages.

---
## Continuous Integration / Continuous Deployment
### How do I release a new version in the App Store / Google Play Store?
Builds are automatically created by Codemagic based on git tags.
The tags are in turn automatically generated based on the version in `pubspec.yaml` on the `main` branch using Github Actions.

 > Suppose you have a branch with a new feature that you want to release. You have the branch `feature/new-feature` and you have increased the version in `pubspec.yaml` to `1.0.0+1`. You create a pull request to the `main` branch and wait until it is approved and merged. 
1. As soon as your branch is merged, a new git tag is automatically created based on the version in `pubspec.yaml`. The tag will be `1.0.0`.
2. Codemagic will then create a new build based on the tag. This build will then become available in the App Store / Google Play Store for the internal test group.

### Code Quality & Style
Code quality is checked by various tools. If there are errors, the pull request will fail and you will need to resolve the errors. You can also run the tools locally to detect errors.
There are various checks that are performed as part of the CI/CD pipeline. These checks are performed on every push and pull request to `main`.

#### Dart Code Linter
We use the Dart Code Linter to analyze the code for errors and to format the code.
You run the linter locally with:
```bash
$ flutter analyze
```

#### Dart Code Metrics
We use Dart Code Metrics to analyze the code for code smells.  
You run dart code metrics locally with:
```bash
$ dcm analyze lib
```
This will analyze the `lib` folder.

#### Flutter Format
We use Flutter Format to format the code. 
You can run the formatter locally with:
```bash
$ dart format .
```

### Delete local branches that are not on the remote
After merging a branch. The branch still stays on your computer.
To delete them, first allow the script to delete the files:
Open a Git Bash terminal (in app.main folder), then:
```bash
$ chmod +x clean_local_branches.sh
```
After that, run the script
```bash
$ bash clean_locol_branches.sh
```



## Setting up build in CodeMagic

### In Teams go to your team page

Go to team integrations and connect to Apple Developer Portal. Details are explained in [here (Signing iOS apps with code signing identities and codemagic.yaml)](https://www.youtube.com/watch?v=idRJZxVafY0). After this scroll down to Code signing identities and upload certificate under iOS certificates via the instructions in video mentioned above.

### In the Apps menu

- Click on Add application to connect to a new gitrepo
- Click on Finish build setup to go into build settings or press the gear
- In the top right under "Workflow settings" change workflow name to something adequate
- Under Build for platforms check the desired platforms (Android, iOS, Web)
- In Build triggers enable Trigger on push and Cancel outdated webhooks builds. Under branch patterns include source: main. And under tag patterns include: *.*.*
- In Pre-test script include ```
{
#!/bin/sh

commit_msg=$(git log -1 --pretty=format:"%b")

### Write latest commit message to release notes
echo "[{\"language\": \"nl-NL\", \"text\": \"$commit_msg\"}]" > release_notes.json

}
```
- In Tests enable to stop build when tests fails
- Scroll down to Build and change Android build format to android app bundle and APK
- - Switch Mode to Release
- In Post-build script include ```
{
# Deploy only if we built for web
# Directory to check
DIRECTORY="build/web"

# Check if the directory exists
if [ -d "$DIRECTORY" ]; then
    firebase deploy --only hosting --token $FIREBASE_TOKEN
fi
}
```
- Scroll to Distribution
- - Enable Android code signing, ask either Vincent or Alex for credentials
- - Enable Google Play publishing
- -
- - In iOS code signing set code signing method to automatic
- - - Choose your own API key (First set this up in Team -> "your team" -> Team integrations -> Developer Portal
- - - Set provisioning profile type to Ad hoc and bundle identifier to that of the app
- - Finally in App Store Connect enable it and choose your API



## Acknowledgments

### Dart Code Metrics

We are grateful to Dmitry Zhifarsky for generously providing us with a Dart Code Metrics Teams version free of charge. As a nonprofit, resources like these are invaluable in helping us achieve our mission.

Dmitry Zhifarsky's support plays a crucial role in our development process, enabling us to perform static analysis more effectively. His commitment to supporting nonprofit initiatives aligns closely with our organizational values and objectives.

For more information about Dmitry Zhifarsky and Dart Code Metrics, visit his website: https://dcm.dev/

---

