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
        }
    }

    // AndroidManifest.xml에서 package 속성 제거 (AGP 8.0+ 대응)
    afterEvaluate {
        val removePackageAttribute = tasks.register("removePackageAttribute") {
            val manifestFile = file("src/main/AndroidManifest.xml")
            if (manifestFile.exists()) {
                doLast {
                    val content = manifestFile.readText()
                    val updatedContent = content.replace(Regex("package=\"[^\"]*\""), "")
                    manifestFile.writeText(updatedContent)
                }
            }
        }
        tasks.named("preBuild") {
            dependsOn(removePackageAttribute)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
