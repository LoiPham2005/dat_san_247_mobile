import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("environment")

    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationId = "com.datsan247.mobile.dev"
            resValue(type = "string", name = "app_name", value = "Dặt Sân 247 Dev")
        }
        create("stg") {
            dimension = "environment"
            applicationId = "com.datsan247.mobile.stg"
            resValue(type = "string", name = "app_name", value = "Dặt Sân 247 Stg")
        }
        create("prod") {
            dimension = "environment"
            applicationId = "com.datsan247.mobile"
            resValue(type = "string", name = "app_name", value = "Dặt Sân 247")
        }
    }
}