# Base image without CUDA
FROM ubuntu:20.04

# Set up non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# Configure apt and install initial dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    apt-utils \
    && rm -rf /var/lib/apt/lists/*

# Add ROS Noetic repository
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    lsb-release \
    ca-certificates \
    && sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
    && rm -rf /var/lib/apt/lists/*

# Install development tools and libraries
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    build-essential \
    cmake \
    git \
    nano \
    sudo \
    libeigen3-dev \
    libpoco-dev \
    libboost-all-dev \
    libgoogle-glog-dev \
    libhdf5-dev \
    python3-dev \
    python3-pip \
    python3-setuptools \
    && rm -rf /var/lib/apt/lists/*

# Install ROS Noetic
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-desktop-full \
    && rm -rf /var/lib/apt/lists/*

# Set up ROS environment
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

# Install ROS dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    python3-catkin-tools \
    && rosdep init \
    && rosdep update \
    && rm -rf /var/lib/apt/lists/*

# Install networkx first with a compatible version
RUN pip3 install --no-cache-dir networkx==2.8.8


# Install Franka-related dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-libfranka \
    ros-noetic-franka-ros \
    build-essential \
    bc \
    curl \
    debhelper \
    dpkg-dev \
    devscripts \
    fakeroot \
    libssl-dev \
    libelf-dev \
    bison \
    flex \
    cpio \
    kmod \
    rsync \
    libncurses-dev \
    && rm -rf /var/lib/apt/lists/*

# Set up Franka ROS workspace
WORKDIR /workspace
RUN mkdir -p catkin_ws/src && cd catkin_ws \
    && source /opt/ros/noetic/setup.sh \
    && catkin_init_workspace src \
    && cd src \
    && git clone --recursive https://github.com/frankaemika/franka_ros \
    && cd /workspace/catkin_ws \
    && rosdep install --from-paths src --ignore-src --rosdistro noetic -y --skip-keys libfranka \
    && catkin_make -DCMAKE_BUILD_TYPE=Release -DFranka_DIR:PATH=/opt/ros/noetic/share/libfranka/cmake \
    && source devel/setup.sh

# Set up environment for running GUI applications
ENV QT_X11_NO_MITSHM=1
ENV DISPLAY=:0

# Install X11 apps and create docker group
RUN apt-get update && apt-get install -y --no-install-recommends \
    x11-apps \
    && groupadd -r docker \
    && usermod -aG docker root \
    && rm -rf /var/lib/apt/lists/*

# Set up entrypoint to automatically source ROS and Franka environment
RUN echo "source /workspace/catkin_ws/devel/setup.bash" >> ~/.bashrc

CMD ["/bin/bash"]

