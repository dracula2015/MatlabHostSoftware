/*
 * File: OMRS_model.c
 *
 * MATLAB Coder version            : 3.1
 * C/C++ source code generated on  : 20-Dec-2017 23:31:18
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "OMRS_model.h"

/* Function Definitions */

/*
 * OMRS_model Summary of this function goes here
 * Detailed explanation goes here
 *  tic
 *  t5=clock;
 *  global T
 * global P;
 * Arguments    : const double u[3]
 *                const double q[3]
 *                const double dq[3]
 *                double beta0
 *                double beta1
 *                double beta2
 *                double m
 *                double La
 *                double Iv
 *                double DDQ[3]
 * Return Type  : void
 */
void OMRS_model(const double u[3], const double q[3], const double dq[3], double
                beta0, double beta1, double beta2, double m, double La, double
                Iv, double DDQ[3])
{
  double Rav[9];
  int r1;
  double M2av[9];
  static const signed char iv0[3] = { 0, 0, 1 };

  double dv0[9];
  double dv1[9];
  double b_M2av[9];
  double dv2[9];
  double b_beta2[9];
  static const double dv3[3] = { -0.5, -0.5, 1.0 };

  static const double dv4[3] = { 0.866, -0.866, 0.0 };

  double c_M2av[9];
  int r2;
  double Mav[9];
  double c_beta2[3];
  double dv5[3];
  int r3;
  double B[3];
  double maxval;
  double a21;
  int rtemp;
  Rav[0] = cos(q[2]);
  Rav[3] = -sin(q[2]);
  Rav[6] = 0.0;
  Rav[1] = sin(q[2]);
  Rav[4] = cos(q[2]);
  Rav[7] = 0.0;
  for (r1 = 0; r1 < 3; r1++) {
    Rav[2 + 3 * r1] = iv0[r1];
  }

  M2av[0] = 1.5 * beta0 + m;
  M2av[3] = 0.0;
  M2av[6] = 0.0;
  M2av[1] = 0.0;
  M2av[4] = 1.5 * beta0 + m;
  M2av[7] = 0.0;
  M2av[2] = 0.0;
  M2av[5] = 0.0;
  M2av[8] = 3.0 * beta0 * (La * La) + Iv;
  dv0[2] = La;
  dv0[5] = La;
  dv0[8] = La;
  dv1[0] = 1.5 * beta1;
  dv1[3] = -m * dq[2];
  dv1[6] = 0.0;
  dv1[1] = m * dq[2];
  dv1[4] = 1.5 * beta1;
  dv1[7] = 0.0;
  dv1[2] = 0.0;
  dv1[5] = 0.0;
  dv1[8] = 3.0 * beta1 * (La * La);
  dv2[0] = -sin(q[2]) * dq[2];
  dv2[3] = -cos(q[2]) * dq[2];
  dv2[6] = 0.0;
  dv2[1] = cos(q[2]) * dq[2];
  dv2[4] = -sin(q[2]) * dq[2];
  dv2[7] = 0.0;
  for (r1 = 0; r1 < 3; r1++) {
    dv0[3 * r1] = dv3[r1];
    dv0[1 + 3 * r1] = dv4[r1];
    for (r2 = 0; r2 < 3; r2++) {
      Mav[r1 + 3 * r2] = 0.0;
      b_beta2[r2 + 3 * r1] = beta2 * dv0[r2 + 3 * r1];
      b_M2av[r1 + 3 * r2] = 0.0;
      for (r3 = 0; r3 < 3; r3++) {
        Mav[r1 + 3 * r2] += M2av[r1 + 3 * r3] * Rav[r2 + 3 * r3];
        b_M2av[r1 + 3 * r2] += M2av[r1 + 3 * r3] * Rav[r2 + 3 * r3];
      }
    }

    dv2[2 + 3 * r1] = 0.0;
  }

  for (r1 = 0; r1 < 3; r1++) {
    for (r2 = 0; r2 < 3; r2++) {
      M2av[r1 + 3 * r2] = 0.0;
      dv0[r1 + 3 * r2] = 0.0;
      for (r3 = 0; r3 < 3; r3++) {
        M2av[r1 + 3 * r2] += b_M2av[r1 + 3 * r3] * dv2[r3 + 3 * r2];
        dv0[r1 + 3 * r2] += dv1[r1 + 3 * r3] * Rav[r2 + 3 * r3];
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
      dv1[r2 + 3 * r1] = dv0[r2 + 3 * r1] - c_M2av[r2 + 3 * r1];
      c_beta2[r1] += b_beta2[r1 + 3 * r2] * u[r2];
    }
  }

  for (r1 = 0; r1 < 3; r1++) {
    dv5[r1] = 0.0;
    for (r2 = 0; r2 < 3; r2++) {
      dv5[r1] += dv1[r1 + 3 * r2] * dq[r2];
    }

    B[r1] = c_beta2[r1] - dv5[r1];
  }

  r1 = 0;
  r2 = 1;
  r3 = 2;
  maxval = fabs(Mav[0]);
  a21 = fabs(Mav[1]);
  if (a21 > maxval) {
    maxval = a21;
    r1 = 1;
    r2 = 0;
  }

  if (fabs(Mav[2]) > maxval) {
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
  if (fabs(Mav[3 + r3]) > fabs(Mav[3 + r2])) {
    rtemp = r2;
    r2 = r3;
    r3 = rtemp;
  }

  Mav[3 + r3] /= Mav[3 + r2];
  Mav[6 + r3] -= Mav[3 + r3] * Mav[6 + r2];
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

/*
 * File trailer for OMRS_model.c
 *
 * [EOF]
 */
