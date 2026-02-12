import java.text.Normalizer
import com.android.build.api.variant.ApplicationAndroidComponentsExtension
import com.android.build.api.dsl.ApplicationExtension
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
val androidExt = project.extensions.getByType<ApplicationExtension>()
val androidComponentsExt = project.extensions.getByType<ApplicationAndroidComponentsExtension>()

// =========================================================
//  RENAME APK TRỰC TIẾP (tối ưu nhất - không cần copy)
// =========================================================
androidComponentsExt.onVariants { variant ->
    variant.outputs.forEach { output ->
        val flavor = variant.flavorName ?: "noflavor"
        val buildType = variant.buildType ?: "release"

        // Lấy app name từ extra property
        val flavorConfig = androidExt.productFlavors.findByName(flavor)
        val appName = (flavorConfig?.extra?.get("appName") as? String)
            ?.toSafeFileName()
            ?: "app"

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

                // Tự động lấy app_name từ extra property của productFlavor
                val flavorConfig = androidExt.productFlavors.findByName(flavor)
                val appName = (flavorConfig?.extra?.get("appName") as? String)
                    ?.toSafeFileName()
                    ?: "app"

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
