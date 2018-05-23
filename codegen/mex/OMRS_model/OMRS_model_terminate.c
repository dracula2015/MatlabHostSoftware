/*
 * OMRS_model_terminate.c
 *
 * Code generation for function 'OMRS_model_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "OMRS_model.h"
#include "OMRS_model_terminate.h"
#include "_coder_OMRS_model_mex.h"
#include "OMRS_model_data.h"

/* Function Definitions */
void OMRS_model_atexit(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);

  /* Free instance data */
  covrtFreeInstanceData(&emlrtCoverageInstance);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void OMRS_model_terminate(void)
{
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (OMRS_model_terminate.c) */
