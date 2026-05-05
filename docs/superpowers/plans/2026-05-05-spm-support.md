# Swift Package Manager Support Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ajouter le support Swift Package Manager (SPM) au plugin `permission_handler_apple` tout en maintenant la rétrocompatibilité CocoaPods.

**Architecture:** Déplacer les sources ObjC de `ios/Classes/` vers `ios/Sources/permission_handler_apple/` (structure SPM standard), créer un `Package.swift` avec compilation conditionnelle basée sur des variables d'environnement, et mettre à jour le podspec pour pointer vers les nouveaux chemins. Les deux systèmes de build (CocoaPods + SPM) cohabiteront sans duplication de fichiers.

**Tech Stack:** Objective-C, Swift Package Manager 5.9, CocoaPods, Flutter plugin system

---

## Carte des fichiers

| Action | Chemin |
|---|---|
| Créer | `permission_handler_apple/ios/Package.swift` |
| Créer | `permission_handler_apple/ios/Sources/permission_handler_apple/` (tous les .h/.m) |
| Créer | `permission_handler_apple/ios/Sources/permission_handler_apple/include/permission_handler_apple/PermissionHandlerPlugin.h` |
| Créer | `permission_handler_apple/ios/Sources/permission_handler_apple/PrivacyInfo.xcprivacy` |
| Modifier | `permission_handler_apple/ios/permission_handler_apple.podspec` |
| Modifier | `permission_handler_apple/ios/.gitignore` |
| Modifier | `permission_handler_apple/README.md` |
| Supprimer | `permission_handler_apple/ios/Classes/` (après migration) |

---

## Task 1 : Créer la structure de répertoires SPM

**Files:**
- Create: `permission_handler_apple/ios/Sources/permission_handler_apple/`
- Create: `permission_handler_apple/ios/Sources/permission_handler_apple/include/permission_handler_apple/`
- Create: `permission_handler_apple/ios/Sources/permission_handler_apple/strategies/`
- Create: `permission_handler_apple/ios/Sources/permission_handler_apple/util/`

- [ ] **Step 1 : Créer les répertoires**

```bash
mkdir -p permission_handler_apple/ios/Sources/permission_handler_apple/include/permission_handler_apple
mkdir -p permission_handler_apple/ios/Sources/permission_handler_apple/strategies
mkdir -p permission_handler_apple/ios/Sources/permission_handler_apple/util
```

- [ ] **Step 2 : Vérifier la structure**

```bash
find permission_handler_apple/ios/Sources -type d
```

Résultat attendu :
```
permission_handler_apple/ios/Sources
permission_handler_apple/ios/Sources/permission_handler_apple
permission_handler_apple/ios/Sources/permission_handler_apple/include
permission_handler_apple/ios/Sources/permission_handler_apple/include/permission_handler_apple
permission_handler_apple/ios/Sources/permission_handler_apple/strategies
permission_handler_apple/ios/Sources/permission_handler_apple/util
```

- [ ] **Step 3 : Commit**

```bash
git add permission_handler_apple/ios/Sources/
git commit -m "feat(apple): create SPM source directory structure"
```

---

## Task 2 : Déplacer les fichiers sources vers la structure SPM

**Files:**
- Modify (move): `permission_handler_apple/ios/Classes/` → `permission_handler_apple/ios/Sources/permission_handler_apple/`

- [ ] **Step 1 : Déplacer les fichiers racine (plugin + manager)**

```bash
git mv permission_handler_apple/ios/Classes/PermissionHandlerPlugin.h \
        permission_handler_apple/ios/Sources/permission_handler_apple/PermissionHandlerPlugin.h

git mv permission_handler_apple/ios/Classes/PermissionHandlerPlugin.m \
        permission_handler_apple/ios/Sources/permission_handler_apple/PermissionHandlerPlugin.m

git mv permission_handler_apple/ios/Classes/PermissionManager.h \
        permission_handler_apple/ios/Sources/permission_handler_apple/PermissionManager.h

git mv permission_handler_apple/ios/Classes/PermissionManager.m \
        permission_handler_apple/ios/Sources/permission_handler_apple/PermissionManager.m

git mv permission_handler_apple/ios/Classes/PermissionHandlerEnums.h \
        permission_handler_apple/ios/Sources/permission_handler_apple/PermissionHandlerEnums.h
```

- [ ] **Step 2 : Déplacer les stratégies**

```bash
for f in permission_handler_apple/ios/Classes/strategies/*; do
  git mv "$f" "permission_handler_apple/ios/Sources/permission_handler_apple/strategies/$(basename $f)"
done
```

- [ ] **Step 3 : Déplacer les utilitaires**

```bash
git mv permission_handler_apple/ios/Classes/util/Codec.h \
        permission_handler_apple/ios/Sources/permission_handler_apple/util/Codec.h

git mv permission_handler_apple/ios/Classes/util/Codec.m \
        permission_handler_apple/ios/Sources/permission_handler_apple/util/Codec.m
```

- [ ] **Step 4 : Supprimer le répertoire Classes/ vide**

```bash
rmdir permission_handler_apple/ios/Classes/util
rmdir permission_handler_apple/ios/Classes/strategies
rmdir permission_handler_apple/ios/Classes
```

- [ ] **Step 5 : Vérifier que tous les fichiers sont bien déplacés**

```bash
find permission_handler_apple/ios/Sources -type f | sort
```

Résultat attendu (42 fichiers : 22 .h + 20 .m) :
```
permission_handler_apple/ios/Sources/permission_handler_apple/PermissionHandlerEnums.h
permission_handler_apple/ios/Sources/permission_handler_apple/PermissionHandlerPlugin.h
permission_handler_apple/ios/Sources/permission_handler_apple/PermissionHandlerPlugin.m
permission_handler_apple/ios/Sources/permission_handler_apple/PermissionManager.h
permission_handler_apple/ios/Sources/permission_handler_apple/PermissionManager.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/AppTrackingTransparencyPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/AppTrackingTransparencyPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/AssistantPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/AssistantPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/AudioVideoPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/AudioVideoPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/BackgroundRefreshStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/BackgroundRefreshStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/BluetoothPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/BluetoothPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/ContactPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/ContactPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/CriticalAlertsPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/CriticalAlertsPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/EventPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/EventPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/LocationPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/LocationPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/MediaLibraryPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/MediaLibraryPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/NotificationPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/NotificationPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/PermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/PhonePermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/PhonePermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/PhotoPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/PhotoPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/SensorPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/SensorPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/SpeechPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/SpeechPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/StoragePermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/StoragePermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/UnknownPermissionStrategy.h
permission_handler_apple/ios/Sources/permission_handler_apple/strategies/UnknownPermissionStrategy.m
permission_handler_apple/ios/Sources/permission_handler_apple/util/Codec.h
permission_handler_apple/ios/Sources/permission_handler_apple/util/Codec.m
```

- [ ] **Step 6 : Commit**

```bash
git add -A permission_handler_apple/ios/Classes permission_handler_apple/ios/Sources
git commit -m "feat(apple): move ObjC sources to SPM-compatible structure"
```

---

## Task 3 : Créer le header public pour Flutter/SPM

SPM a besoin d'un header public dans `include/<target>/` pour que Flutter génère le code d'enregistrement du plugin.

**Files:**
- Create: `permission_handler_apple/ios/Sources/permission_handler_apple/include/permission_handler_apple/PermissionHandlerPlugin.h`

- [ ] **Step 1 : Copier le header public**

```bash
cp permission_handler_apple/ios/Sources/permission_handler_apple/PermissionHandlerPlugin.h \
   permission_handler_apple/ios/Sources/permission_handler_apple/include/permission_handler_apple/PermissionHandlerPlugin.h
```

- [ ] **Step 2 : Vérifier le contenu**

```bash
cat permission_handler_apple/ios/Sources/permission_handler_apple/include/permission_handler_apple/PermissionHandlerPlugin.h
```

Résultat attendu :
```objc
#import <Flutter/Flutter.h>
#import "PermissionManager.h"

@interface PermissionHandlerPlugin : NSObject<FlutterPlugin>
- (instancetype)initWithPermissionManager:(PermissionManager *)permissionManager;
@end
```

- [ ] **Step 3 : Commit**

```bash
git add permission_handler_apple/ios/Sources/permission_handler_apple/include/
git commit -m "feat(apple): add public header for SPM plugin registration"
```

---

## Task 4 : Déplacer PrivacyInfo.xcprivacy

**Files:**
- Move: `permission_handler_apple/ios/Resources/PrivacyInfo.xcprivacy` → `permission_handler_apple/ios/Sources/permission_handler_apple/PrivacyInfo.xcprivacy`

- [ ] **Step 1 : Déplacer le fichier**

```bash
git mv permission_handler_apple/ios/Resources/PrivacyInfo.xcprivacy \
        permission_handler_apple/ios/Sources/permission_handler_apple/PrivacyInfo.xcprivacy
```

- [ ] **Step 2 : Supprimer le dossier Resources si vide**

```bash
ls permission_handler_apple/ios/Resources/
# Si seulement .gitkeep:
rm permission_handler_apple/ios/Resources/.gitkeep
rmdir permission_handler_apple/ios/Resources/
```

- [ ] **Step 3 : Commit**

```bash
git add -A permission_handler_apple/ios/Resources permission_handler_apple/ios/Sources/permission_handler_apple/PrivacyInfo.xcprivacy
git commit -m "feat(apple): move PrivacyInfo.xcprivacy to SPM sources"
```

---

## Task 5 : Créer Package.swift

**Files:**
- Create: `permission_handler_apple/ios/Package.swift`

- [ ] **Step 1 : Créer le fichier Package.swift**

Créer `permission_handler_apple/ios/Package.swift` avec ce contenu exact :

```swift
// swift-tools-version: 5.9

import PackageDescription
import Foundation

let environmentVariables = ProcessInfo.processInfo.environment

let permissionDefines: [CSetting] = [
    // dart: PermissionGroup.calendar (< iOS 17)
    .define("PERMISSION_EVENTS", to: environmentVariables["PERMISSION_EVENTS"] ?? "0"),
    // dart: PermissionGroup.calendarFullAccess (iOS 17+)
    .define("PERMISSION_EVENTS_FULL_ACCESS", to: environmentVariables["PERMISSION_EVENTS_FULL_ACCESS"] ?? "0"),
    // dart: PermissionGroup.reminders
    .define("PERMISSION_REMINDERS", to: environmentVariables["PERMISSION_REMINDERS"] ?? "0"),
    // dart: PermissionGroup.contacts
    .define("PERMISSION_CONTACTS", to: environmentVariables["PERMISSION_CONTACTS"] ?? "0"),
    // dart: PermissionGroup.camera
    .define("PERMISSION_CAMERA", to: environmentVariables["PERMISSION_CAMERA"] ?? "0"),
    // dart: PermissionGroup.microphone
    .define("PERMISSION_MICROPHONE", to: environmentVariables["PERMISSION_MICROPHONE"] ?? "0"),
    // dart: PermissionGroup.speech
    .define("PERMISSION_SPEECH_RECOGNIZER", to: environmentVariables["PERMISSION_SPEECH_RECOGNIZER"] ?? "0"),
    // dart: PermissionGroup.photos
    .define("PERMISSION_PHOTOS", to: environmentVariables["PERMISSION_PHOTOS"] ?? "0"),
    // dart: [PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse]
    .define("PERMISSION_LOCATION", to: environmentVariables["PERMISSION_LOCATION"] ?? "0"),
    // dart: PermissionGroup.locationWhenInUse (only when locationAlways is NOT needed)
    .define("PERMISSION_LOCATION_WHENINUSE", to: environmentVariables["PERMISSION_LOCATION_WHENINUSE"] ?? "0"),
    // dart: PermissionGroup.notification
    .define("PERMISSION_NOTIFICATIONS", to: environmentVariables["PERMISSION_NOTIFICATIONS"] ?? "0"),
    // dart: PermissionGroup.mediaLibrary
    .define("PERMISSION_MEDIA_LIBRARY", to: environmentVariables["PERMISSION_MEDIA_LIBRARY"] ?? "0"),
    // dart: PermissionGroup.sensors
    .define("PERMISSION_SENSORS", to: environmentVariables["PERMISSION_SENSORS"] ?? "0"),
    // dart: PermissionGroup.bluetooth
    .define("PERMISSION_BLUETOOTH", to: environmentVariables["PERMISSION_BLUETOOTH"] ?? "0"),
    // dart: PermissionGroup.appTrackingTransparency
    .define("PERMISSION_APP_TRACKING_TRANSPARENCY", to: environmentVariables["PERMISSION_APP_TRACKING_TRANSPARENCY"] ?? "0"),
    // dart: PermissionGroup.criticalAlerts
    .define("PERMISSION_CRITICAL_ALERTS", to: environmentVariables["PERMISSION_CRITICAL_ALERTS"] ?? "0"),
    // dart: PermissionGroup.assistant
    .define("PERMISSION_ASSISTANT", to: environmentVariables["PERMISSION_ASSISTANT"] ?? "0"),
]

let package = Package(
    name: "permission_handler_apple",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "permission-handler-apple", targets: ["permission_handler_apple"]),
    ],
    targets: [
        .target(
            name: "permission_handler_apple",
            path: "Sources/permission_handler_apple",
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include/permission_handler_apple"),
            ] + permissionDefines
        ),
    ]
)
```

- [ ] **Step 2 : Vérifier la syntaxe Swift**

```bash
cd permission_handler_apple/ios && swift package dump-package 2>&1
```

Résultat attendu : JSON décrivant le package sans erreur.

- [ ] **Step 3 : Commit**

```bash
cd -
git add permission_handler_apple/ios/Package.swift
git commit -m "feat(apple): add Package.swift for Swift Package Manager support"
```

---

## Task 6 : Mettre à jour le podspec

Le podspec doit maintenant pointer vers `Sources/permission_handler_apple/` au lieu de `Classes/`.

**Files:**
- Modify: `permission_handler_apple/ios/permission_handler_apple.podspec`

- [ ] **Step 1 : Mettre à jour le podspec**

Remplacer le contenu de `permission_handler_apple/ios/permission_handler_apple.podspec` :

```ruby
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'permission_handler_apple'
  s.version          = '9.3.0'
  s.summary          = 'Permission plugin for Flutter.'
  s.description      = <<-DESC
Permission plugin for Flutter. This plugin provides a cross-platform (iOS, Android) API to request and check permissions.
                       DESC
  s.homepage         = 'https://github.com/baseflowit/flutter-permission-handler'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Baseflow' => 'hello@baseflow.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Sources/permission_handler_apple/**/*.{h,m}'
  s.public_header_files = 'Sources/permission_handler_apple/include/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '12.0'
  s.static_framework = true
  s.resource_bundles = {'permission_handler_apple_privacy' => ['Sources/permission_handler_apple/PrivacyInfo.xcprivacy']}
end
```

- [ ] **Step 2 : Vérifier la validité du podspec**

```bash
cd permission_handler_apple/ios && pod spec lint permission_handler_apple.podspec --allow-warnings 2>&1 | tail -5
```

Résultat attendu : `permission_handler_apple.podspec passed validation.`

> Note : si `pod` n'est pas installé, passer cette étape et noter dans le commit message que la validation pod sera faite en CI.

- [ ] **Step 3 : Commit**

```bash
cd -
git add permission_handler_apple/ios/permission_handler_apple.podspec
git commit -m "feat(apple): update podspec to reference SPM source structure"
```

---

## Task 7 : Mettre à jour .gitignore

**Files:**
- Modify: `permission_handler_apple/ios/.gitignore`

- [ ] **Step 1 : Ajouter les artifacts SPM au .gitignore**

Ajouter à la fin de `permission_handler_apple/ios/.gitignore` :

```
# Swift Package Manager
.build/
*.resolved
```

- [ ] **Step 2 : Commit**

```bash
git add permission_handler_apple/ios/.gitignore
git commit -m "chore(apple): ignore SPM build artifacts"
```

---

## Task 8 : Mettre à jour le README avec les instructions SPM

**Files:**
- Modify: `permission_handler/README.md` (README principal du plugin)

- [ ] **Step 1 : Localiser la section Setup iOS**

```bash
grep -n "Podfile\|CocoaPods\|iOS setup\|Setup" permission_handler/README.md | head -10
```

- [ ] **Step 2 : Ajouter une section SPM après la section CocoaPods**

Trouver la ligne après le bloc `post_install do |installer|...end` et insérer la section suivante.

La section SPM à ajouter (après le `</details>` de la section CocoaPods) :

```markdown
<details>
<summary>Swift Package Manager (SPM)</summary>

> SPM support requires Flutter 3.24.0 or higher.

With SPM, you configure permissions via environment variables at build time. Add a pre-action script to your Xcode scheme:

1. Open your project in Xcode and select **Product > Scheme > Edit Scheme...**
2. Select **Build > Pre-actions** and click **+** to add a **New Run Script Action**
3. Set **Provide build settings from** to your app target
4. Add the following script, removing any permissions you do not need:

```bash
# Enable the permissions your app requires.
# Remove lines for permissions you don't use to minimize binary size.

## dart: PermissionGroup.calendar
export PERMISSION_EVENTS=1

## dart: PermissionGroup.calendarFullAccess (iOS 17+)
export PERMISSION_EVENTS_FULL_ACCESS=1

## dart: PermissionGroup.reminders
export PERMISSION_REMINDERS=1

## dart: PermissionGroup.contacts
export PERMISSION_CONTACTS=1

## dart: PermissionGroup.camera
export PERMISSION_CAMERA=1

## dart: PermissionGroup.microphone
export PERMISSION_MICROPHONE=1

## dart: PermissionGroup.speech
export PERMISSION_SPEECH_RECOGNIZER=1

## dart: PermissionGroup.photos
export PERMISSION_PHOTOS=1

## dart: [PermissionGroup.location, PermissionGroup.locationAlways, PermissionGroup.locationWhenInUse]
export PERMISSION_LOCATION=1

## dart: PermissionGroup.locationWhenInUse (only when locationAlways is NOT needed)
# export PERMISSION_LOCATION_WHENINUSE=1

## dart: PermissionGroup.notification
export PERMISSION_NOTIFICATIONS=1

## dart: PermissionGroup.mediaLibrary
export PERMISSION_MEDIA_LIBRARY=1

## dart: PermissionGroup.sensors
export PERMISSION_SENSORS=1

## dart: PermissionGroup.bluetooth
export PERMISSION_BLUETOOTH=1

## dart: PermissionGroup.appTrackingTransparency
export PERMISSION_APP_TRACKING_TRANSPARENCY=1

## dart: PermissionGroup.criticalAlerts
export PERMISSION_CRITICAL_ALERTS=1

## dart: PermissionGroup.assistant
export PERMISSION_ASSISTANT=1
```

5. Clean & Rebuild

</details>
```

- [ ] **Step 3 : Commit**

```bash
git add permission_handler/README.md
git commit -m "docs: add SPM setup instructions to README"
```

---

## Task 9 : Vérification du build iOS (CocoaPods)

Vérifier que CocoaPods fonctionne encore après la migration.

- [ ] **Step 1 : Nettoyer et reconstruire l'exemple CocoaPods**

```bash
cd permission_handler_apple/example/ios
rm -rf Pods Podfile.lock
pod install 2>&1 | tail -10
```

Résultat attendu : `Pod installation complete!` sans erreur.

- [ ] **Step 2 : Build Flutter via CocoaPods**

```bash
cd permission_handler_apple/example
flutter build ios --no-codesign 2>&1 | tail -20
```

Résultat attendu : `Build complete.`

---

## Task 10 : Vérification du build iOS (SPM)

- [ ] **Step 1 : Activer SPM dans le projet exemple**

Flutter détecte automatiquement `Package.swift` dans `ios/` depuis Flutter 3.24. Vérifier la version Flutter :

```bash
flutter --version | head -3
```

Si Flutter >= 3.24, SPM est utilisé automatiquement quand Xcode est configuré pour l'utiliser.

- [ ] **Step 2 : Build via SPM**

```bash
cd permission_handler_apple/example
flutter build ios --no-codesign 2>&1 | tail -20
```

Résultat attendu : `Build complete.`

- [ ] **Step 3 : Si erreur de build SPM**

Erreur fréquente — header non trouvé :
```
'PermissionManager.h' file not found
```
**Cause :** Les imports dans les `.m` utilisent des chemins relatifs qui ne fonctionnent pas avec le `headerSearchPath` configuré.

**Fix :** Vérifier que le `cSettings` dans `Package.swift` inclut bien `.headerSearchPath(".")` et `.headerSearchPath("strategies")` et `.headerSearchPath("util")` en plus de l'include path :

```swift
cSettings: [
    .headerSearchPath("."),
    .headerSearchPath("strategies"),
    .headerSearchPath("util"),
    .headerSearchPath("include/permission_handler_apple"),
] + permissionDefines
```

---

## Task 11 : Finalisation et PR

- [ ] **Step 1 : Vérifier l'état git final**

```bash
git log --oneline -10
git status
```

- [ ] **Step 2 : Pousser sur le fork**

```bash
git remote -v  # vérifier que origin pointe vers le fork personnel
git push origin main  # ou la branche feature
```

- [ ] **Step 3 : Ouvrir la PR**

```bash
gh pr create \
  --repo Baseflow/flutter-permission-handler \
  --title "feat(apple): add Swift Package Manager support" \
  --body "$(cat <<'EOF'
## Summary

- Adds `Package.swift` to `permission_handler_apple/ios/` for Swift Package Manager compatibility
- Moves ObjC sources from `ios/Classes/` to `ios/Sources/permission_handler_apple/` (SPM-standard layout)
- Updates podspec to reference new source paths — CocoaPods remains fully supported
- Permissions are enabled via environment variables (same 17 defines as CocoaPods approach)
- Updates README with SPM setup instructions

Supersedes / builds on the work started in #1440.
Closes #1439
Closes #1516

## Test plan

- [ ] `flutter build ios --no-codesign` passes with CocoaPods
- [ ] `flutter build ios --no-codesign` passes with SPM (Flutter >= 3.24)
- [ ] `pod spec lint` passes on updated podspec
- [ ] `swift package dump-package` validates Package.swift syntax

🤖 Generated with [Claude Code](https://claude.ai/claude-code)
EOF
)"
```

---

## Notes importantes

### Pourquoi les variables d'environnement pour SPM ?

Avec CocoaPods, les `GCC_PREPROCESSOR_DEFINITIONS` sont injectés via le Podfile. SPM ne supporte pas ce mécanisme — la seule façon de passer des flags de compilation à un package SPM depuis l'extérieur est via des variables d'environnement lues dans `Package.swift` à l'exécution de la résolution du package. C'est l'approche retenue par la PR #1440 et validée par la communauté.

### Compatibilité versions

| Système | Version minimale requise |
|---|---|
| Flutter | 3.24.0 (pour SPM auto-detection) |
| Xcode | 15.0 (pour swift-tools-version 5.9) |
| iOS deployment target | 12.0 |
| CocoaPods | Inchangé |

### Fichier `include/` — pourquoi ?

SPM traite les headers dans `include/<target-name>/` comme headers publics. Flutter génère un `FlutterGeneratedPluginSwiftPackage` qui importe `permission_handler_apple/PermissionHandlerPlugin.h`. Sans ce chemin, la compilation SPM échoue avec `module not found`.
