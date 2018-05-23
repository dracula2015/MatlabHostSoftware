/*
 * File: _coder_OMRS_model_api.h
 *
 * MATLAB Coder version            : 3.1
 * C/C++ source code generated on  : 20-Dec-2017 23:31:18
 */

#ifndef _CODER_OMRS_MODEL_API_H
#define _CODER_OMRS_MODEL_API_H

/* Include Files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_OMRS_model_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void OMRS_model(real_T u[3], real_T q[3], real_T dq[3], real_T beta0,
  real_T beta1, real_T beta2, real_T m, real_T La, real_T Iv, real_T DDQ[3]);
extern void OMRS_model_api(const mxArray *prhs[9], const mxArray *plhs[1]);
extern void OMRS_model_atexit(void);
extern void OMRS_model_initialize(void);
extern void OMRS_model_terminate(void);
extern void OMRS_model_xil_terminate(void);

#endif

/*
 * File trailer for _coder_OMRS_model_api.h
 *
 * [EOF]
 */
