buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.3.10") // Cập nhật phiên bản mới nhất nếu cần
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Định nghĩa thư mục build mới
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Đảm bảo rằng tất cả subprojects phụ thuộc vào `:app`
subprojects {
    project.evaluationDependsOn(":app")
}

// Định nghĩa task clean để xóa thư mục build khi cần
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
