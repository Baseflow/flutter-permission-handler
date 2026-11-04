plugins {
    java
}

// Run independently of Flutter/AGP:
// ANDROID_JAR=/path/to/android.jar gradle -p permission_handler_android/android/jvm-tests test
// Only the production selector is compiled; Android constants are inlined by javac.
repositories {
    mavenCentral()
}

val androidJar = providers.environmentVariable("ANDROID_JAR")
    .getOrElse("${System.getenv("ANDROID_HOME")}/platforms/android-37.0/android.jar")
check(file(androidJar).isFile) {
    "Set ANDROID_JAR to an installed Android SDK platform's android.jar."
}

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

sourceSets {
    main {
        java.setSrcDirs(listOf("../src/main/java"))
        java.include("com/baseflow/permissionhandler/BluetoothPermissionSelector.java")
    }
}

dependencies {
    compileOnly(files(androidJar))
    testCompileOnly(files(androidJar))
    testImplementation("org.junit.jupiter:junit-jupiter:5.10.2")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher:1.10.2")
}

tasks.test {
    useJUnitPlatform()
    testLogging {
        events("passed", "skipped", "failed")
    }
}
