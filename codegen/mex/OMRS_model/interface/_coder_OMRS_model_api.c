/*
 * _coder_OMRS_model_api.c
 *
 * Code generation for function '_coder_OMRS_model_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "OMRS_model.h"
#include "_coder_OMRS_model_api.h"
#include "OMRS_model_data.h"

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[3];
static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *beta0,
  const char_T *identifier);
static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static real_T (*e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[3];
static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  char_T *identifier))[3];
static const mxArray *emlrt_marshallOut(const real_T u[3]);
static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);

/* Function Definitions */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[3]
{
  real_T (*y)[3];
  y = e_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
  static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *beta0,
  const char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(sp, emlrtAlias(beta0), &thisId);
  emlrtDestroyArray(&beta0);
  return y;
}

static real_T d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = f_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T (*e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[3]
{
  real_T (*ret)[3];
  static const int32_T dims[1] = { 3 };

  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 1U, dims);
  ret = (real_T (*)[3])mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}
  static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  char_T *identifier))[3]
{
  real_T (*y)[3];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(u), &thisId);
  emlrtDestroyArray(&u);
  return y;
}

static const mxArray *emlrt_marshallOut(const real_T u[3])
{
  const mxArray *y;
  const mxArray *m1;
  static const int32_T iv4[1] = { 0 };

  static const int32_T iv5[1] = { 3 };

  y = NULL;
  m1 = emlrtCreateNumericArray(1, iv4, mxDOUBLE_CLASS, mxREAL);
  mxSetData((mxArray *)m1, (void *)u);
  emlrtSetDimensions((mxArray *)m1, iv5, 1);
  emlrtAssign(&y, m1);
  return y;
}

static real_T f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void OMRS_model_api(const mxArray * const prhs[9], const mxArray *plhs[1])
{
  real_T (*DDQ)[3];
  real_T (*u)[3];
  real_T (*q)[3];
  real_T (*dq)[3];
  real_T beta0;
  real_T beta1;
  real_T beta2;
  real_T m;
  real_T La;
  real_T Iv;
  emlrtStack st = { NULL, NULL, NULL };

  st.tls = emlrtRootTLSGlobal;
  DDQ = (real_T (*)[3])mxMalloc(sizeof(real_T [3]));

  /* Marshall function inputs */
  u = emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "u");
  q = emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "q");
  dq = emlrt_marshallIn(&st, emlrtAlias(prhs[2]), "dq");
  beta0 = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[3]), "beta0");
  beta1 = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[4]), "beta1");
  beta2 = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[5]), "beta2");
  m = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[6]), "m");
  La = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[7]), "La");
  Iv = c_emlrt_marshallIn(&st, emlrtAliasP(prhs[8]), "Iv");

  /* Invoke the target function */
  OMRS_model(&st, *u, *q, *dq, beta0, beta1, beta2, m, La, Iv, *DDQ);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(*DDQ);
}

/* End of code generation (_coder_OMRS_model_api.c) */
