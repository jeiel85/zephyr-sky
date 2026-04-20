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
            android.compileSdkVersion(36)
            android.defaultConfig.targetSdkVersion(36)
        }
    }

    // 1. AndroidManifest.xml에서 package 속성 제거 (AGP 8.0+ 대응)
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

    // 2. lStar 리소스 오류 강제 해결 (mergeResources 태스크 이후 실행)
    project.tasks.whenTaskAdded {
        if (name.startsWith("merge") && name.endsWith("Resources")) {
            doLast {
                val valuesFiles = fileTree(mapOf("dir" to "build/intermediates/merged_res", "include" to "**/values.xml"))
                valuesFiles.forEach { file ->
                    val content = file.readText()
                    if (content.contains("android:attr/lStar")) {
                        val updatedContent = content.replace(Regex("<item name=\"android:attr/lStar\">.*?</item>"), "")
                        file.writeText(updatedContent)
                    }
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
