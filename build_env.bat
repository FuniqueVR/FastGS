@echo off
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
set DISTUTILS_USE_SDK=1
call C:\ProgramData\anaconda3\Scripts\activate.bat
call conda activate fastgs
echo Installing additional dependencies...
python -m pip install plyfile tqdm websockets
echo Installing submodules...
python -m pip install -e C:\dev\FastGS\submodules\diff-gaussian-rasterization_fastgs --no-build-isolation
python -m pip install -e C:\dev\FastGS\submodules\simple-knn --no-build-isolation
python -m pip install -e C:\dev\FastGS\submodules\fused-ssim --no-build-isolation
echo Done!
