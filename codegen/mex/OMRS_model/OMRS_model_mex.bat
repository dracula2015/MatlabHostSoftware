@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2016a
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2016a\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=OMRS_model_mex
set MEX_NAME=OMRS_model_mex
set MEX_EXT=.mexw64
call setEnv.bat
echo # Make settings for OMRS_model > OMRS_model_mex.mki
echo COMPILER=%COMPILER%>> OMRS_model_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> OMRS_model_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> OMRS_model_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> OMRS_model_mex.mki
echo LINKER=%LINKER%>> OMRS_model_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> OMRS_model_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> OMRS_model_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> OMRS_model_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> OMRS_model_mex.mki
echo BORLAND=%BORLAND%>> OMRS_model_mex.mki
echo OMPFLAGS= >> OMRS_model_mex.mki
echo OMPLINKFLAGS= >> OMRS_model_mex.mki
echo EMC_COMPILER=msvc140>> OMRS_model_mex.mki
echo EMC_CONFIG=optim>> OMRS_model_mex.mki
"C:\Program Files\MATLAB\R2016a\bin\win64\gmake" -B -f OMRS_model_mex.mk
