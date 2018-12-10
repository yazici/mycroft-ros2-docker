###########################
# Tools
###########################
set -e
CLEANUP=${CLEANUP:-true}
# Ensure apt cache is up to date
${SUDO} apt-get update

${SUDO} apt-get install -y \
        zlib1g-dev \
        libssl-dev \
        python3-pip

${SUDO} pip3 install black

# install CLion dependency
${SUDO} apt-get install -y \
        libxslt1.1 \
        openjdk-8-jdk

###########################
# Clean up
###########################
if $CLEANUP; then
    ${SUDO} apt-get clean
fi
