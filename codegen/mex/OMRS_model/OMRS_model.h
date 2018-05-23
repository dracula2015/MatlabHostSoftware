/*
 * OMRS_model.h
 *
 * Code generation for function 'OMRS_model'
 *
 */

#ifndef OMRS_MODEL_H
#define OMRS_MODEL_H

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mwmathutil.h"
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "covrt.h"
#include "rtwtypes.h"
#include "OMRS_model_types.h"

/* Function Declarations */
extern void OMRS_model(const emlrtStack *sp, const real_T u[3], const real_T q[3],
  const real_T dq[3], real_T beta0, real_T beta1, real_T beta2, real_T m, real_T
  La, real_T Iv, real_T DDQ[3]);

#endif

/* End of code generation (OMRS_model.h) */
