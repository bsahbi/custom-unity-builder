ARG GAMECI_IMAGE=unityci/editor:ubuntu-2022.3.21f1-android-3.1.0
FROM $GAMECI_IMAGE

# Install OpenJDK 11
RUN apt-get update && apt-get install -y openjdk-11-jdk

# Set JAVA_HOME and update PATH
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Install Android SDK manager
RUN apt-get update && apt-get install -y wget unzip && \
    echo "Downloading Android SDK Command Line Tools..." && \
    wget "https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip" -O cmdline-tools.zip && \
    echo "Unzipping Android SDK Command Line Tools..." && \
    mkdir -p /opt/unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK/cmdline-tools/latest && \
    mkdir -p /tmp/cmdline-tools && \
    unzip cmdline-tools.zip -d /tmp/cmdline-tools && \
    mv /tmp/cmdline-tools/cmdline-tools/* /opt/unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK/cmdline-tools/latest/ && \
    rm -rf /tmp/cmdline-tools && \
    rm cmdline-tools.zip

ENV ANDROID_HOME=/opt/unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"



# Accept licenses and install platform 33
RUN yes | sdkmanager --licenses && \
    sdkmanager "platforms;android-33" "build-tools;33.0.0"


# Fix permissions to allow Unity to write to the SDK directory
RUN chmod -R 777 /opt/unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK


# Install Gradle
RUN curl -fsSL https://services.gradle.org/distributions/gradle-7.3.3-all.zip -o gradle-7.3.3-all.zip && \
    unzip gradle-7.3.3-all.zip -d /opt && \
    ln -s /opt/gradle-7.3.3/bin/gradle /usr/local/bin/gradle && \
    rm gradle-7.3.3-all.zip


