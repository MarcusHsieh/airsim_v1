# Base Dockerfile for AirSim with CUDA and GPU support
ARG DEBIAN_FRONTEND=noninteractive
ARG BASE_DIST=ubuntu20.04
ARG CUDA_VERSION=11.4.3
FROM nvidia/cuda:${CUDA_VERSION}-base-${BASE_DIST}

# NVIDIA env vars for GPU support
ENV NVIDIA_DRIVER_CAPABILITIES=compute,graphics,utility
ENV NVIDIA_VISIBLE_DEVICES=all

# installations (airsim)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    dos2unix \
    unzip \
    libglu1-mesa-dev \
    git \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

# installations (vulkan)
RUN apt-get update && \
    apt-get install -y vulkan-tools mesa-utils pciutils && \
    rm -rf /var/lib/apt/lists/*

# Create virtual environment and install necessary Python packages
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/python -m pip install --upgrade pip setuptools wheel && \
    /opt/venv/bin/pip install pycuda numpy

# Set up the AirSim repository
WORKDIR /airsim_v1
RUN git clone https://github.com/MarcusHsieh/airsim_v1.git .

# Run environment setup scripts
WORKDIR /airsim_v1/Environment
RUN chmod +x download_envs.sh && ./download_envs.sh

# Convert scripts to Unix format and run them
WORKDIR /airsim_v1/EnvSetup
RUN dos2unix unreal_engine_setup.sh airsim_setup.sh airsim_ros_setup.sh && \
    chmod +x unreal_engine_setup.sh airsim_setup.sh airsim_ros_setup.sh && \
    bash ./unreal_engine_setup.sh && \
    bash ./airsim_setup.sh && \
    bash ./airsim_ros_setup.sh

# Create a startup script to launch Xvfb and AirSim
RUN echo '#!/bin/bash\nXvfb :1 -screen 0 1024x768x24 &\nDISPLAY=:1 ./Environment/AirSimNH/LinuxNoEditor/AirSimNH.sh -Resx=1080 -Resy=720 -windowed' > /airsim_v1/start_airsim.sh && \
    chmod +x /airsim_v1/start_airsim.sh

# Create a startup script to launch AirSim without Xvfb
RUN echo '#!/bin/bash\n./Environment/AirSimNH/LinuxNoEditor/AirSimNH.sh -Resx=1080 -Resy=720 -windowed' > /airsim_v1/start_airsim_noxvfb.sh && \
    chmod +x /airsim_v1/start_airsim_noxvfb.sh

# Grant airsim_user sudo privileges without a password
RUN useradd -m airsim_user && echo "airsim_user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chown -R airsim_user:airsim_user /airsim_v1

# Switch to non-root user
USER airsim_user

# Set default work directory
WORKDIR /airsim_v1

# Set the default command to launch AirSim
CMD ["bash", "/airsim_v1/start_airsim.sh"]
