###########################
# Machinekit
###########################
set -e
CLEANUP=${CLEANUP:-true}

git clone https://github.com/MycroftAI/mycroft-core.git --depth=1
cd mycroft-core
bash dev_setup.sh --allow-root

###########################
# Clean up
###########################
if $CLEANUP; then
    ${SUDO} apt-get clean
fi
