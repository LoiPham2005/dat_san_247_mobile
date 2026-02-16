import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// Add these lines to read key.properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.datsan247.mobile"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.datsan247.mobile"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
     //   versionCode = 101
     //   versionName = "1.0.1"
        multiDexEnabled = true
    }

//    signingConfigs {
//        release {
//            keyAlias keystoreProperties['keyAlias']
//            keyPassword keystoreProperties['keyPassword']
//            storeFile file(keystoreProperties['storeFile'])
//            storePassword keystoreProperties['storePassword']
//        }
//    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                file("proguard-rules.pro")
            )
            signingConfig = signingConfigs.getByName("debug")
        }
    }

//    splits {
//        abi {
//            isEnable = true
//            reset()
//            include("arm64-v8a", "armeabi-v7a")
//            isUniversalApk = true
//        }
//    }

    bundle {
        language {
            enableSplit = true
        }
        abi {
            enableSplit = true
        }
        density {
            enableSplit = true
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}

// =========================================================
//  Tách các custom tasks ra file riêng cho dễ quản lý
// =========================================================
apply(from = "rename-outputs.gradle.kts")  // Rename APK + AAB
apply(from = "open-folder.gradle.kts")     // Auto open folder after build
apply(from = "flavorizr.gradle.kts")     // Flavorizr
