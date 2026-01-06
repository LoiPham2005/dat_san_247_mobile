import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Add these lines to read key.properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.flutter_base_template"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.flutter_base_template"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

 //  signingConfigs {
 //      create("release") {
 //          keyAlias = keystoreProperties["keyAlias"] as String
 //          keyPassword = keystoreProperties["keyPassword"] as String
 //         storeFile = file(keystoreProperties["storeFile"] as String)
 //         storePassword = keystoreProperties["storePassword"] as String
 //      }
 //  }

    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Base App Dev")
        }
        create("stg") {
            dimension = "environment"
            applicationIdSuffix = ".stg"
            versionNameSuffix = "-stg"
            resValue("string", "app_name", "Base App Stg")
        }
        create("prod") {
            dimension = "environment"
            resValue("string", "app_name", "Base App")
        }
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
        release {
            isMinifyEnabled = true      // ✅ Minify enabled
            isShrinkResources = true    // ✅ Shrink resources enabled
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                file("proguard-rules.pro")
            )
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // ✅ FIX: Correct Kotlin DSL syntax for splits
    splits {
        abi {
            isEnable = true             // ✅ Changed from 'enable' to 'isEnable'
            reset()
            include("arm64-v8a", "armeabi-v7a")  // ✅ Changed from include to include()
            isUniversalApk = true       // ✅ Changed from 'universalApk' to 'isUniversalApk'
        }
    }

    // ✅ FIX: Correct Kotlin DSL syntax for bundle
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
