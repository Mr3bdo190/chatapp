#!/bin/bash
sed -i 's/flutter.compileSdkVersion/34/g' android/app/build.gradle 2>/dev/null || true
sed -i 's/flutter.targetSdkVersion/34/g' android/app/build.gradle 2>/dev/null || true
sed -i 's/compileSdkVersion 33/compileSdkVersion 34/g' android/app/build.gradle 2>/dev/null || true
sed -i 's/targetSdkVersion 33/targetSdkVersion 34/g' android/app/build.gradle 2>/dev/null || true
