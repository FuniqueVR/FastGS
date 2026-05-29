# Use an official NVIDIA CUDA base image with development tools
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# FIX 1: Explicitly define target GPU architectures for headless compilation.
# This bypasses the need for a physical GPU during 'docker build'
# (Covers Volta, Turing, Ampere, Ada Lovelace, and Hopper architectures)
ENV TORCH_CUDA_ARCH_LIST="7.0;7.5;8.0;8.6;8.9;9.0"

# Install system dependencies, C++ compilers, and Python tools
# Added ninja-build (FIX 3) to dramatically speed up CUDA compilation
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    curl \
    ca-certificates \
    python3-pip \
    python3-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Set up the working directory
WORKDIR /workspace

# Upgrade pip and install fundamental ML packages matching FastGS requirements
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel

# Install PyTorch matching your CUDA runtime environment
RUN pip3 install --no-cache-dir torch==2.1.2 torchvision==0.16.2 --index-url https://download.pytorch.org/whl/cu118

# FIX 2: Force downgrade to NumPy 1.x to match PyTorch 2.1.2 architecture limits
RUN pip3 install --no-cache-dir "numpy<2"

# Copy the rest of the application code (including submodules)
COPY . /workspace

# Compile and install custom FastGS CUDA submodules
RUN pip3 install --no-build-isolation submodules/diff-gaussian-rasterization_fastgs/
RUN pip3 install --no-build-isolation submodules/diff-plane-rasterization/
RUN pip3 install --no-build-isolation submodules/simple-knn/
RUN pip3 install --no-build-isolation submodules/fused-ssim/

RUN pip3 install plyfile
RUN pip3 install websockets
RUN pip3 install tqdm
RUN pip3 install "numpy<2"

# Default command to verify installation or start training
CMD ["python3", "train.py", "-h"]