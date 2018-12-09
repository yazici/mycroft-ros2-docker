###########################
# Install nvidia container runtime

# From
# https://github.com/machinekoder/nvidia-opengl-docker

if test "$ENV_COOKIE" = docker; then
    NVIDIA_BUILD_DIR=${NVIDIA_BUILD_DIR:-${WS_DIR}/nvidia}

    apt-get install -y --no-install-recommends \
        libxau6 \
        libxdmcp6 \
        libxcb1 \
        libxext6 \
        libx11-6

    apt-get install -y --no-install-recommends \
        git \
        ca-certificates \
        make \
        automake \
        autoconf \
        libtool \
        pkg-config \
        libxext-dev \
        libx11-dev \
        x11proto-gl-dev \
        python

    mkdir -p ${NVIDIA_BUILD_DIR}
    cd ${NVIDIA_BUILD_DIR}
    git clone --branch=v1.1.0 https://github.com/NVIDIA/libglvnd.git .
    ./autogen.sh
    ./configure --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu
    make -j"$(nproc)" install-strip
    find /usr/lib/x86_64-linux-gnu -type f -name 'lib*.la' -delete

    mkdir -p /usr/share/glvnd/egl_vendor.d
    cat > /usr/share/glvnd/egl_vendor.d/10_nvidia.json <<EOF
{
    "file_format_version" : "1.0.0",
    "ICD" : {
        "library_path" : "libEGL_nvidia.so.0"
    }
}
EOF
    ldconfig
fi

###########################
# Clean up
###########################
if $CLEANUP; then
    ${SUDO} apt-get clean
    if test "$ENV_COOKIE" = docker; then
        rm -rf ${NVIDIA_BUILD_DIR}
    fi
fi
