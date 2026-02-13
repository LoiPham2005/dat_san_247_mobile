# ════════════════════════════════════════════════════════════════
# 📁 Makefile - Flutter Base Template Automation
# ════════════════════════════════════════════════════════════════

.PHONY: help get clean gen watch l10n full-gen analyze format fix test cov run-dev run-stg run-prod build-apk-dev build-apk-stg build-apk-prod build-aab-prod icons splash

# Default target
help:
	@echo "🚀 Flutter Base Template - Makefile Commands"
	@echo "════════════════════════════════════════════════════════════════"
	@echo "📦 DEPENDENCIES"
	@echo "  make get             - Cài đặt dependencies (pub get)"
	@echo "  make clean           - Dọn dẹp build files"
	@echo "  make upgrade         - Nâng cấp dependencies"
	@echo ""
	@echo "⚡ CODE GENERATION"
	@echo "  make gen             - Chạy build_runner build"
	@echo "  make watch           - Chạy build_runner watch"
	@echo "  make l10n            - Tạo files ngôn ngữ (l10n)"
	@echo "  make full-gen        - Clean + get + l10n + gen (Hard Reset)"
	@echo ""
	@echo "🔧 QUALITY & ANALYSIS"
	@echo "  make analyze         - Phân tích code (linter)"
	@echo "  make format          - Format code"
	@echo "  make fix             - Tự động sửa lỗi code"
	@echo ""
	@echo "🧪 TESTING"
	@echo "  make test            - Chạy unit tests"
	@echo "  make cov             - Chạy test và tạo báo cáo coverage"
	@echo ""
	@echo "🧑‍💻 RUN (DEBUG)"
	@echo "  make run-dev         - Chạy app môi trường DEV"
	@echo "  make run-stg         - Chạy app môi trường STAGING"
	@echo "  make run-prod        - Chạy app môi trường PRODUCTION"
	@echo ""
	@echo "📦 BUILD (RELEASE)"
	@echo "  make apk-dev         - Build APK (DEV)"
	@echo "  make apk-stg         - Build APK (STG)"
	@echo "  make apk-prod        - Build APK (PROD)"
	@echo "  make aab-prod        - Build AppBundle (PROD)"
	@echo ""
	@echo "🎨 ASSETS"
	@echo "  make icons           - Tạo App Icons"
	@echo "  make splash          - Tạo Native Splash"
	@echo ""
	@echo "🛠️ REFACTORING"
	@echo "  make rename-package name=\"new_name\" - Đổi tên package (pubspec & dart files)"
	@echo "  make rename-app name=\"New App\"      - Đổi tên hiển thị ứng dụng"
	@echo "════════════════════════════════════════════════════════════════"

# 📦 DEPENDENCIES
get:
	fvm flutter pub get

clean:
	fvm flutter clean

upgrade:
	fvm flutter pub upgrade --major-versions

# ⚡ CODE GENERATION
gen:
	fvm dart run build_runner build --delete-conflicting-outputs

watch:
	fvm dart run build_runner watch --delete-conflicting-outputs

l10n:
	fvm flutter gen-l10n

full-gen:
	fvm flutter clean
	fvm flutter pub get
	fvm flutter gen-l10n
	fvm dart run build_runner build --delete-conflicting-outputs

# 🔧 QUALITY & ANALYSIS
analyze:
	fvm flutter analyze

format:
	fvm dart format .

fix:
	fvm dart fix --apply

# 🧪 TESTING
test:
	fvm flutter test

cov:
	fvm flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html

# 🧑‍💻 RUN (DEBUG)
run-dev:
	fvm flutter run --flavor dev -t lib/main_dev.dart

run-stg:
	fvm flutter run --flavor stg -t lib/main_stg.dart

run-prod:
	fvm flutter run --flavor prod -t lib/main_prod.dart

# 📦 BUILD (RELEASE)
apk-dev:
	fvm flutter build apk --flavor dev -t lib/main_dev.dart --release

apk-stg:
	fvm flutter build apk --flavor stg -t lib/main_stg.dart --release

apk-prod:
	fvm flutter build apk --flavor prod -t lib/main_prod.dart --release

aab-prod:
	fvm flutter build appbundle --flavor prod -t lib/main_prod.dart --release --obfuscate --split-debug-info=build/debug-symbols

# 🎨 ASSETS
icons:
	fvm flutter pub run flutter_launcher_icons

splash:
	fvm flutter pub run flutter_native_splash:create


# 🛠️ REFACTORING
rename-package:
	@powershell -Command "$$oldName = (Get-Content pubspec.yaml | Select-String -Pattern '^name: ' | ForEach-Object { $$_.Line.Split(':')[1].Trim() }); Write-Host 'Renaming package from' $$oldName 'to $(name)...'; (Get-Content pubspec.yaml) -replace ('name: ' + $$oldName), ('name: ' + '$(name)') | Set-Content pubspec.yaml; Get-ChildItem -Recurse -Include *.dart | ForEach-Object { (Get-Content $$_.FullName) -replace ('package:' + $$oldName), ('package:' + '$(name)') | Set-Content $$_.FullName }; fvm flutter clean; fvm flutter pub get"

rename-app:
	fvm flutter pub run rename setAppName --value "$(name)"
