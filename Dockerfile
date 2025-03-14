ARG GAMECI_IMAGE=unityci/editor:ubuntu-2022.3.21f1-android-3.1.0
FROM $GAMECI_IMAGE
# reference: https://docs.unity3d.com/Manual/android-sdksetup.html

# Install Gradle
RUN curl -fsSL https://services.gradle.org/distributions/gradle-8.12-all.zip -o gradle-8.12-all.zip && \
    unzip gradle-8.12-all.zip -d /opt && \
    ln -s /opt/gradle-8.12/bin/gradle /usr/local/bin/gradle && \
    rm gradle-8.12-all.zip

# Download Firebase Unity SDK
RUN curl -L -o /opt/firebase_unity_sdk.zip "https://firebase.google.com/download/unity" && \
    unzip /opt/firebase_unity_sdk.zip -d /opt/firebase_sdk && \
    rm /opt/firebase_unity_sdk.zip

RUN ls /opt/firebase_sdk

RUN mkdir -p /tmp/.X11-unix && chown root:root /tmp/.X11-unix &&  chmod 1777 /tmp/.X11-unix

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
