/*
 * OMRS_model.c
 *
 * Code generation for function 'OMRS_model'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "OMRS_model.h"
#include "mpower.h"
#include "warning.h"
#include "OMRS_model_data.h"

/* Variable Definitions */
static emlrtRSInfo emlrtRSI = { 16, "OMRS_model",
  "D:\\OMRS_Projection\\OMRS\\PID+NPID\\rectangle\\OMRS_model.m" };

static emlrtRSInfo b_emlrtRSI = { 19, "OMRS_model",
  "D:\\OMRS_Projection\\OMRS\\PID+NPID\\rectangle\\OMRS_model.m" };

static emlrtRSInfo c_emlrtRSI = { 25, "OMRS_model",
  "D:\\OMRS_Projection\\OMRS\\PID+NPID\\rectangle\\OMRS_model.m" };

static emlrtRSInfo f_emlrtRSI = { 1, "mldivide",
  "C:\\Program Files\\MATLAB\\R2016a\\toolbox\\eml\\lib\\matlab\\ops\\mldivide.p"
};

static emlrtRSInfo g_emlrtRSI = { 48, "lusolve",
  "C:\\Program Files\\MATLAB\\R2016a\\toolbox\\eml\\eml\\+coder\\+internal\\lusolve.m"
};

static emlrtRSInfo h_emlrtRSI = { 249, "lusolve",
  "C:\\Program Files\\MATLAB\\R2016a\\toolbox\\eml\\eml\\+coder\\+internal\\lusolve.m"
};

static emlrtRSInfo i_emlrtRSI = { 76, "lusolve",
  "C:\\Program Files\\MATLAB\\R2016a\\toolbox\\eml\\eml\\+coder\\+internal\\lusolve.m"
};

/* Function Definitions */
void OMRS_model(const emlrtStack *sp, const real_T u[3], const real_T q[3],
                const real_T dq[3], real_T beta0, real_T beta1, real_T beta2,
                real_T m, real_T La, real_T Iv, real_T DDQ[3])
{
  real_T Rav[9];
  int32_T r1;
  real_T maxval;
  static const int8_T iv0[3] = { 0, 0, 1 };

  real_T M2av[9];
  real_T C2av[9];
  int32_T r2;
  real_T b_C2av[9];
  real_T Mav[9];
  int32_T r3;
  real_T b_M2av[9];
  real_T dv0[9];
  real_T b_beta2[9];
  static const real_T dv1[3] = { -0.5, -0.5, 1.0 };

  static const real_T dv2[3] = { 0.866, -0.866, 0.0 };

  real_T c_M2av[9];
  real_T c_beta2[3];
  real_T c_C2av[3];
  real_T B[3];
  real_T a21;
  int32_T rtemp;
  emlrtStack st;
  emlrtStack b_st;
  emlrtStack c_st;
  emlrtStack d_st;
  emlrtStack e_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  c_st.prev = &b_st;
  c_st.tls = b_st.tls;
  d_st.prev = &c_st;
  d_st.tls = c_st.tls;
  e_st.prev = &d_st;
  e_st.tls = d_st.tls;
  covrtLogFcn(&emlrtCoverageInstance, 0U, 0);
  covrtLogBasicBlock(&emlrtCoverageInstance, 0U, 0);

  /* OMRS_model Summary of this function goes here */
  /* Detailed explanation goes here */
  /*  tic */
  /*  t5=clock; */
  /*  global T */
  /* global P; */
  Rav[0] = muDoubleScalarCos(q[2]);
  Rav[3] = -muDoubleScalarSin(q[2]);
  Rav[6] = 0.0;
  Rav[1] = muDoubleScalarSin(q[2]);
  Rav[4] = muDoubleScalarCos(q[2]);
  Rav[7] = 0.0;
  for (r1 = 0; r1 < 3; r1++) {
    Rav[2 + 3 * r1] = iv0[r1];
  }

  st.site = &emlrtRSI;
  maxval = mpower(La);
  M2av[0] = 1.5 * beta0 + m;
  M2av[3] = 0.0;
  M2av[6] = 0.0;
  M2av[1] = 0.0;
  M2av[4] = 1.5 * beta0 + m;
  M2av[7] = 0.0;
  M2av[2] = 0.0;
  M2av[5] = 0.0;
  M2av[8] = 3.0 * beta0 * maxval + Iv;
  st.site = &b_emlrtRSI;
  maxval = mpower(La);
  C2av[0] = 1.5 * beta1;
  C2av[3] = -m * dq[2];
  C2av[6] = 0.0;
  C2av[1] = m * dq[2];
  C2av[4] = 1.5 * beta1;
  C2av[7] = 0.0;
  C2av[2] = 0.0;
  C2av[5] = 0.0;
  C2av[8] = 3.0 * beta1 * maxval;
  for (r1 = 0; r1 < 3; r1++) {
    for (r2 = 0; r2 < 3; r2++) {
      Mav[r1 + 3 * r2] = 0.0;
      for (r3 = 0; r3 < 3; r3++) {
        Mav[r1 + 3 * r2] += M2av[r1 + 3 * r3] * Rav[r2 + 3 * r3];
      }
    }
  }

  st.site = &c_emlrtRSI;
  b_C2av[2] = La;
  b_C2av[5] = La;
  b_C2av[8] = La;
  dv0[0] = -muDoubleScalarSin(q[2]) * dq[2];
  dv0[3] = -muDoubleScalarCos(q[2]) * dq[2];
  dv0[6] = 0.0;
  dv0[1] = muDoubleScalarCos(q[2]) * dq[2];
  dv0[4] = -muDoubleScalarSin(q[2]) * dq[2];
  dv0[7] = 0.0;
  for (r1 = 0; r1 < 3; r1++) {
    b_C2av[3 * r1] = dv1[r1];
    b_C2av[1 + 3 * r1] = dv2[r1];
    for (r2 = 0; r2 < 3; r2++) {
      b_beta2[r2 + 3 * r1] = beta2 * b_C2av[r2 + 3 * r1];
      b_M2av[r1 + 3 * r2] = 0.0;
      for (r3 = 0; r3 < 3; r3++) {
        b_M2av[r1 + 3 * r2] += M2av[r1 + 3 * r3] * Rav[r2 + 3 * r3];
      }
    }

    dv0[2 + 3 * r1] = 0.0;
  }

  for (r1 = 0; r1 < 3; r1++) {
    for (r2 = 0; r2 < 3; r2++) {
      M2av[r1 + 3 * r2] = 0.0;
      b_C2av[r1 + 3 * r2] = 0.0;
      for (r3 = 0; r3 < 3; r3++) {
        M2av[r1 + 3 * r2] += b_M2av[r1 + 3 * r3] * dv0[r3 + 3 * r2];
        b_C2av[r1 + 3 * r2] += C2av[r1 + 3 * r3] * Rav[r2 + 3 * r3];
      }
    }

    for (r2 = 0; r2 < 3; r2++) {
      c_M2av[r1 + 3 * r2] = 0.0;
      for (r3 = 0; r3 < 3; r3++) {
        c_M2av[r1 + 3 * r2] += M2av[r1 + 3 * r3] * Rav[r2 + 3 * r3];
      }
    }
  }

  for (r1 = 0; r1 < 3; r1++) {
    c_beta2[r1] = 0.0;
    for (r2 = 0; r2 < 3; r2++) {
      C2av[r2 + 3 * r1] = b_C2av[r2 + 3 * r1] - c_M2av[r2 + 3 * r1];
      c_beta2[r1] += b_beta2[r1 + 3 * r2] * u[r2];
    }
  }

  for (r1 = 0; r1 < 3; r1++) {
    c_C2av[r1] = 0.0;
    for (r2 = 0; r2 < 3; r2++) {
      c_C2av[r1] += C2av[r1 + 3 * r2] * dq[r2];
    }

    B[r1] = c_beta2[r1] - c_C2av[r1];
  }

  b_st.site = &f_emlrtRSI;
  c_st.site = &g_emlrtRSI;
  r1 = 0;
  r2 = 1;
  r3 = 2;
  maxval = muDoubleScalarAbs(Mav[0]);
  a21 = muDoubleScalarAbs(Mav[1]);
  if (a21 > maxval) {
    maxval = a21;
    r1 = 1;
    r2 = 0;
  }

  if (muDoubleScalarAbs(Mav[2]) > maxval) {
    r1 = 2;
    r2 = 1;
    r3 = 0;
  }

  Mav[r2] /= Mav[r1];
  Mav[r3] /= Mav[r1];
  Mav[3 + r2] -= Mav[r2] * Mav[3 + r1];
  Mav[3 + r3] -= Mav[r3] * Mav[3 + r1];
  Mav[6 + r2] -= Mav[r2] * Mav[6 + r1];
  Mav[6 + r3] -= Mav[r3] * Mav[6 + r1];
  if (muDoubleScalarAbs(Mav[3 + r3]) > muDoubleScalarAbs(Mav[3 + r2])) {
    rtemp = r2;
    r2 = r3;
    r3 = rtemp;
  }

  Mav[3 + r3] /= Mav[3 + r2];
  Mav[6 + r3] -= Mav[3 + r3] * Mav[6 + r2];
  if ((Mav[r1] == 0.0) || (Mav[3 + r2] == 0.0) || (Mav[6 + r3] == 0.0)) {
    d_st.site = &h_emlrtRSI;
    e_st.site = &i_emlrtRSI;
    warning(&e_st);
  }

  DDQ[1] = B[r2] - B[r1] * Mav[r2];
  DDQ[2] = (B[r3] - B[r1] * Mav[r3]) - DDQ[1] * Mav[3 + r3];
  DDQ[2] /= Mav[6 + r3];
  DDQ[0] = B[r1] - DDQ[2] * Mav[6 + r1];
  DDQ[1] -= DDQ[2] * Mav[6 + r2];
  DDQ[1] /= Mav[3 + r2];
  DDQ[0] -= DDQ[1] * Mav[3 + r1];
  DDQ[0] /= Mav[r1];

  /*  t6=clock; */
  /*  T.modelTime=etime(t6,t5); */
  /*  P.modelTime=toc; */
}

/* End of code generation (OMRS_model.c) */
