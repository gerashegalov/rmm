#!/bin/bash

################################################################################
# SETUP - Check environment
################################################################################

gpuci_logger "Get env"
env

gpuci_logger "Activate conda env"
. /opt/conda/etc/profile.d/conda.sh
conda activate rapids

gpuci_logger "Check versions"
python --version
$CC --version
$CXX --version

gpuci_logger "Check conda environment"
conda info
conda config --show-sources
conda list --show-channel-urls

# FIX Added to deal with Anancoda SSL verification issues during conda builds
# conda config --set ssl_verify False


################################################################################
# BUILD - Conda package builds (LIBRMM)
################################################################################


export CONDA_BLD_DIR="$WORKSPACE/.conda-bld"
FILE_NAME="conda_build_${BRANCH_NAME}-arc-${ARC}.tar"

conda build conda/recipes/librmm --croot ${CONDA_BLD_DIR}
tar -cvf ${FILE_NAME} ${CONDA_BLD_DIR}
ls -la $CONDA_BLD_DIR
aws s3 cp ${FILE_NAME} "s3://rapids-downloads/blobs/"