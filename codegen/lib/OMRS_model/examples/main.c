/*
 * File: main.c
 *
 * MATLAB Coder version            : 3.1
 * C/C++ source code generated on  : 20-Dec-2017 23:31:18
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include Files */
#include "rt_nonfinite.h"
#include "OMRS_model.h"
#include "main.h"
#include "OMRS_model_terminate.h"
#include "OMRS_model_initialize.h"

/* Function Declarations */
static void argInit_3x1_real_T(double result[3]);
static double argInit_real_T(void);
static void main_OMRS_model(void);

/* Function Definitions */

/*
 * Arguments    : double result[3]
 * Return Type  : void
 */
static void argInit_3x1_real_T(double result[3])
{
  int idx0;

  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 3; idx0++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result[idx0] = argInit_real_T();
  }
}

/*
 * Arguments    : void
 * Return Type  : double
 */
static double argInit_real_T(void)
{
  return 0.0;
}

/*
 * Arguments    : void
 * Return Type  : void
 */
static void main_OMRS_model(void)
{
  double dv6[3];
  double dv7[3];
  double dv8[3];
  double DDQ[3];

  /* Initialize function 'OMRS_model' input arguments. */
  /* Initialize function input argument 'u'. */
  /* Initialize function input argument 'q'. */
  /* Initialize function input argument 'dq'. */
  /* Call the entry-point 'OMRS_model'. */
  argInit_3x1_real_T(dv6);
  argInit_3x1_real_T(dv7);
  argInit_3x1_real_T(dv8);
  OMRS_model(dv6, dv7, dv8, argInit_real_T(), argInit_real_T(), argInit_real_T(),
             argInit_real_T(), argInit_real_T(), argInit_real_T(), DDQ);
}

/*
 * Arguments    : int argc
 *                const char * const argv[]
 * Return Type  : int
 */
int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  OMRS_model_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_OMRS_model();

  /* Terminate the application.
     You do not need to do this more than one time. */
  OMRS_model_terminate();
  return 0;
}

/*
 * File trailer for main.c
 *
 * [EOF]
 */
