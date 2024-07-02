FROM centos:latest

# Change to /etc/yum.repos.d/ directory
WORKDIR /etc/yum.repos.d/

# Update repository URLs
RUN sed -i 's/mirrorlist/#mirrorlist/g' CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' CentOS-*

# Install necessary packages
RUN dnf install -y curl unzip libXcursor openssl openssl-libs libXinerama libXrandr-devel libXi alsa-lib pulseaudio-libs mesa-libGL && \
    dnf clean all

# Set Godot version as an environment variable
ENV GODOT_VERSION="4.2.2"

# Download Godot from GitHub
RUN curl -LO https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip

# Unzip the downloaded file
RUN unzip Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip

# Move the Godot binary to the appropriate directory
RUN mv Godot_v${GODOT_VERSION}-stable_linux.x86_64 /usr/local/bin/godot

# Make the Godot binary executable
RUN chmod +x /usr/local/bin/godot

# Clean up the zip file
RUN rm Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip

# Update system and install ca-certificates
RUN dnf -y update && \
    dnf -y install ca-certificates && \
    update-ca-trust && \
    dnf clean all

# Expose port 8910
EXPOSE 8910

# Copy the game server pack
COPY game.pck .

# Define default command
CMD ["/usr/local/bin/godot", "--headless", "--main-pack", "./game.pck", "--server"]

# docker run --rm -it -p 8910:8910/udp godotagonesmultiplayer:latest
# docker image push docker.io/andresromerodev/godotagonesmultiplayer:latest 