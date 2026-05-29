# Use an official NVIDIA CUDA base image with development tools
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies, C++ compilers, and Python tools
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
    && rm -rf /var/list/apt/lists/*

# Set up the working directory
WORKDIR /workspace

# Upgrade pip and install fundamental ML packages matching FastGS requirements
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel
RUN pip3 install --no-cache-dir torch==2.1.2 torchvision==0.16.2 --index-url https://pytorch.org

# Copy the rest of the application code (including submodules)
COPY . /workspace

# Install the standard python requirements
RUN if [ -f requirements.txt ]; then pip3 install --no-cache-dir -r requirements.txt; fi

# Compile and install custom FastGS CUDA submodules
# Ensure you cloned recursively: git clone https://github.com/fastgs/FastGS.git --recursive
RUN pip3 install submodules/diff-gaussian-rasterization_fastgs/
RUN pip3 install submodules/simple-knn/

# Default command to verify installation or start training
CMD ["python3", "train.py", "-h"]
