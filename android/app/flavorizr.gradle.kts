import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor")

    productFlavors {
        create("dev") {
            dimension = "flavor"
            applicationId = "com.example.flutter_base_template.dev"
            // applicationId = "com.wifi.manage.speed.network.tool"
            resValue(type = "string", name = "app_name", value = "MyApp Dev 1111")
        }
        create("stg") {
            dimension = "flavor"
            applicationId = "com.example.flutter_base_template.stg"
            resValue(type = "string", name = "app_name", value = "MyApp Stg 1111")
        }
        create("prod") {
            dimension = "flavor"
            applicationId = "com.example.flutter_base_template"
            resValue(type = "string", name = "app_name", value = "MyApp")
        }
    }
}
