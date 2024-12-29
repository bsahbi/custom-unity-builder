ARG GAMECI_IMAGE=unityci/editor:ubuntu-2022.3.21f1-android-3.1.0
FROM $GAMECI_IMAGE

# Install OpenJDK 17
RUN apt-get update && apt-get install -y openjdk-17-jdk

# Set JAVA_HOME and update PATH
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"


# Update alternatives to set Java 17 as default
RUN update-alternatives --install /usr/bin/java /usr/lib/jvm/java-17-openjdk-amd64/bin/java 1 \
    && update-alternatives --config java \
    && update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java


RUN rm -rf /opt/unity/Editor/Data/PlaybackEngines/AndroidPlayer/OpenJDK/bin/java

# Verify Java 17 installation
RUN java -version && javac -version



# Install Android SDK manager
RUN apt-get update && apt-get install -y wget unzip && \
    echo "Downloading Android SDK Command Line Tools (Version 35)..." && \
    wget "https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip" -O cmdline-tools.zip && \
    echo "Unzipping Android SDK Command Line Tools..." && \
    mkdir -p /opt/unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK/cmdline-tools/latest && \
    mkdir -p /tmp/cmdline-tools && \
    unzip cmdline-tools.zip -d /tmp && \
    mv /tmp/cmdline-tools/* /opt/unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK/cmdline-tools/latest/ 

# Ensure sdkmanager is executable
RUN chmod +x /opt/unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK/cmdline-tools/latest/bin/sdkmanager

# Verify SDK Manager works properly
RUN /opt/unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK/cmdline-tools/latest/bin/sdkmanager --version


ENV ANDROID_HOME=/opt/unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"



# Accept licenses and install platform 33
RUN yes | sdkmanager --licenses && \
    sdkmanager "platforms;android-35" "build-tools;35.0.0"


# Fix permissions to allow Unity to write to the SDK directory
RUN chmod -R 777 /opt/unity/Editor/Data/PlaybackEngines/AndroidPlayer/SDK


# Install Gradle
RUN curl -fsSL https://services.gradle.org/distributions/gradle-8.12-all.zip -o gradle-8.12-all.zip && \
    unzip gradle-8.12-all.zip -d /opt && \
    ln -s /opt/gradle-8.12/bin/gradle /usr/local/bin/gradle && \
    rm gradle-8.12-all.zip


