from machinekoder/mycroft

# Configure & update apt
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get upgrade -y && \
    apt-get clean

# silence debconf warnings
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y \
    libfile-fcntllock-perl && \
    apt-get clean

# Install and configure sudo, passwordless for everyone
RUN apt-get install -y \
    sudo && \
    apt-get clean
RUN echo "ALL	ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

# Cookie variable for container environment
ENV ENV_COOKIE docker

###########################################
# Install packages
#
# Customize the following for building/running targeted software

# Install misc. packages
ARG EXTRA_PACKAGES
RUN apt-get install -y \
    ccache \
    ssh \
    gdb \
    wget \
    curl \
    lsb-release \
    gnupg2 \
    mesa-utils \
    libgl1-mesa-dri \
    ca-certificates \
    dirmngr \
    ${EXTRA_PACKAGES} \
    && apt-get clean

###########################################
# Graphics drivers
#
COPY include/glx.sh /tmp/install/
RUN bash /tmp/install/glx.sh

###########################################
# Install ROS
#
# set locale for ROS and tools such as "black" to work correctly
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

COPY include/ros2.sh /tmp/install/
RUN bash /tmp/install/ros2.sh

###########################################
# Install Tools
#
#COPY include/tools.sh /tmp/install/
#RUN bash /tmp/install/tools.sh

###########################################
# Setup environment
#


###########################################
# Set up user
#

# This shell script adds passwd and group entries for the user
COPY entrypoint.sh /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/entrypoint"]
# If no args to `docker run`, start an interactive shell
CMD ["/bin/bash", "--login", "-i"]
