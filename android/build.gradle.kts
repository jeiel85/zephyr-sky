allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")

    project.plugins.whenPluginAdded {
        if (this is com.android.build.gradle.BasePlugin) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension
            if (android.namespace == null) {
                android.namespace = "com.example.${project.name.replace("-", "_")}"
            }
            
            // 모든 하위 프로젝트의 SDK 버전을 36으로 강제 고정
            android.compileSdkVersion(36)
            android.defaultConfig.targetSdkVersion(36)
        }
    }

    // preBuild 태스크 시점에 Manifest 파일 수정 (afterEvaluate 없이 구현)
    tasks.withType<com.android.build.gradle.tasks.GenerateResValues>().configureEach {
        val manifestFile = file("src/main/AndroidManifest.xml")
        if (manifestFile.exists()) {
            val content = manifestFile.readText()
            if (content.contains("package=")) {
                val updatedContent = content.replace(Regex("package=\"[^\"]*\""), "")
                manifestFile.writeText(updatedContent)
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
