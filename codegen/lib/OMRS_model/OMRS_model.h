/*
 * File: OMRS_model.h
 *
 * MATLAB Coder version            : 3.1
 * C/C++ source code generated on  : 20-Dec-2017 23:31:18
 */

#ifndef OMRS_MODEL_H
#define OMRS_MODEL_H

/* Include Files */
#include <math.h>
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "OMRS_model_types.h"

/* Function Declarations */
extern void OMRS_model(const double u[3], const double q[3], const double dq[3],
  double beta0, double beta1, double beta2, double m, double La, double Iv,
  double DDQ[3]);

#endif

/*
 * File trailer for OMRS_model.h
 *
 * [EOF]
 */
