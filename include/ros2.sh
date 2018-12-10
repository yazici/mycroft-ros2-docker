###########################
# Install ROS2
set -e
CLEANUP=${CLEANUP:-true}

${SUDO} apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116
${SUDO} sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
${SUDO} sh -c 'echo "deb http://repo.ros2.org/ubuntu/main $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros2-latest.list'

export ROS_DISTRO=bouncy  # or ardent
${SUDO} apt-get update
${SUDO} apt-get install -y \
        ros-$ROS_DISTRO-ros-base \
        python3-argcomplete

# ROS 1 bridge
${SUDO} apt-get install -y \
        ros-$ROS_DISTRO-ros1-bridge

###########################
# Clean up
###########################
if $CLEANUP; then
    ${SUDO} apt-get clean
fi
