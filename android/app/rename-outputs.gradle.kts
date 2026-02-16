import java.text.Normalizer
import com.android.build.api.variant.ApplicationAndroidComponentsExtension
import com.android.build.gradle.AppExtension
import com.android.build.api.variant.FilterConfiguration

// =========================================================
//  HELPER - Chuyển tên app thành tên file an toàn (ASCII)
//  VD: "ĐẶT SÂN 247" → "dat-san-247"
// =========================================================
fun String.toSafeFileName(): String {
    val normalized = Normalizer.normalize(this, Normalizer.Form.NFD)
    return normalized
        .replace(Regex("[\\p{InCombiningDiacriticalMarks}]"), "")
        .replace("Đ", "D").replace("đ", "d")
        .replace(Regex("[^a-zA-Z0-9\\s-]"), "")
        .trim()
        .replace(Regex("\\s+"), "-")
        .lowercase()
}

// =========================================================
//  Lấy extensions thủ công (apply from script không có
//  type-safe accessors)
// =========================================================
val androidExt = project.extensions.getByType<AppExtension>()
val androidComponentsExt = project.extensions.getByType<ApplicationAndroidComponentsExtension>()

// =========================================================
//  HELPER - Lấy app name theo thứ tự ưu tiên:
//  1. resValue (nếu AGP hỗ trợ)
//  2. extra["appName"]
//  3. flavorizr.yaml
//  4. Tên flavor (dev, stg, prod)
// =========================================================
fun getAppNameForFlavor(flavor: String): String {
    val flavorConfig = androidExt.productFlavors.findByName(flavor)

    // 1. Thử lấy từ resValue
    var rawAppName = flavorConfig?.resValues?.get("app_name")?.value
    if (rawAppName != null) {
        println("🟢 [$flavor] App name source: resValue → $rawAppName")
        return rawAppName.toSafeFileName()
    }

    // 2. Thử lấy từ extra["appName"]
    if (flavorConfig?.extra?.has("appName") == true) {
        rawAppName = flavorConfig.extra["appName"] as? String
        if (rawAppName != null) {
            println("🟢 [$flavor] App name source: extra → $rawAppName")
            return rawAppName.toSafeFileName()
        }
    }

    // 3. Đọc từ flavorizr.yaml
    val flavorizrFile = rootProject.file("../flavorizr.yaml")
    if (flavorizrFile.exists()) {
        val content = flavorizrFile.readText()
        val regex = Regex("$flavor:\\s*[\\s\\S]*?app:\\s*[\\s\\S]*?name:\\s*\"([^\"]+)\"")
        val match = regex.find(content)
        if (match != null && match.groupValues.size > 1) {
            val yamlName = match.groupValues[1]
            println("🟢 [$flavor] App name source: flavorizr.yaml → $yamlName")
            return yamlName.toSafeFileName()
        }
    }

    // 4. Fallback: tên flavor
    println("🟡 [$flavor] App name source: flavor name (fallback)")
    return flavor
}

// =========================================================
//  RENAME APK TRỰC TIẾP (tối ưu nhất - không cần copy)
// =========================================================
androidComponentsExt.onVariants { variant ->
    variant.outputs.forEach { output ->
        val flavor = variant.flavorName ?: "noflavor"
        val buildType = variant.buildType ?: "release"

        // Lấy app name (resValue → extra → yaml → flavor)
        val appName = getAppNameForFlavor(flavor)
        println("✅ Final App Name for renaming: $appName")

        // Lấy version info
        val versionName = variant.outputs.first().versionName.orNull ?: "1.0.0"
        val versionCode = variant.outputs.first().versionCode.orNull ?: 1

        // Lấy ABI (nếu có split)
        val abiFilter = output.filters.find {
            it.filterType == FilterConfiguration.FilterType.ABI
        }?.identifier
        val abi = if (abiFilter != null && abiFilter != "universal") "-${abiFilter}" else ""

        // Tên file mới
        val newName = "${appName}-${buildType}${abi}-v${versionName}(${versionCode}).apk"

        // Rename trực tiếp tại nguồn
        (output as com.android.build.api.variant.impl.VariantOutputImpl)
            .outputFileName.set(newName)
    }
}

// =========================================================
//  RENAME AAB with Version Info
// =========================================================
tasks.register("renameAab") {
    doLast {
        val bundleDir = file("${layout.buildDirectory.get()}/outputs/bundle")

        if (bundleDir.exists()) {
            bundleDir.walk().filter { it.extension == "aab" }.forEach { aabFile ->
                val parentName = aabFile.parentFile.name

                // Determine flavor from parent directory name
                val flavor = when {
                    parentName.contains("DevRelease", ignoreCase = true) -> "dev"
                    parentName.contains("StgRelease", ignoreCase = true) -> "stg"
                    parentName.contains("ProdRelease", ignoreCase = true) -> "prod"
                    else -> "unknown"
                }

                // Lấy app name (resValue → extra → yaml → flavor)
                val appName = getAppNameForFlavor(flavor)
                val flavorConfig = androidExt.productFlavors.findByName(flavor)

                // Get version info
                val versionName = androidExt.defaultConfig.versionName ?: "1.0.0"
                val versionCode = androidExt.defaultConfig.versionCode ?: 1

                // Tự động lấy versionNameSuffix từ flavor config
                val versionSuffix = flavorConfig?.versionNameSuffix ?: ""

                val newName = "${appName}-release-v${versionName}${versionSuffix}(${versionCode}).aab"
                val newFile = File(aabFile.parentFile, newName)

                if (aabFile.renameTo(newFile)) {
                    println("✅ AAB renamed → $newName")
                } else {
                    println("❌ Failed to rename AAB: ${aabFile.name}")
                }
            }
        }
    }
}

// Auto-run renameAab after bundle tasks
tasks.whenTaskAdded {
    if (name.contains("bundle") && name.contains("Release")) {
        finalizedBy("renameAab")
    }
}
