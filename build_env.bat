@echo off
:: 1. Activate Anaconda base first
call C:\ProgramData\anaconda3\Scripts\activate.bat

:: 2. Activate your target environment
call conda activate fastgs

:: 3. Now load Visual Studio compiler paths directly INTO the active environment
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
set DISTUTILS_USE_SDK=1

:: 4. (Recommended) Force install Ninja right here to speed things up
python -m pip install ninja

echo Installing additional dependencies...
python -m pip install plyfile tqdm websockets

echo Installing submodules...
python -m pip install -e C:\dev\FastGS\submodules\diff-gaussian-rasterization_fastgs --no-build-isolation
python -m pip install -e C:\dev\FastGS\submodules\simple-knn --no-build-isolation
python -m pip install -e C:\dev\FastGS\submodules\fused-ssim --no-build-isolation

echo Done!