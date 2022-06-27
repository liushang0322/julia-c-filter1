/*
 * File: julia_spline_initialize.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 17-May-2022 16:48:18
 */

/* Include Files */
#include "julia_spline_initialize.h"
#include "julia_spline_data.h"
#include "rt_nonfinite.h"
#include "omp.h"

/* Function Definitions */
/*
 * Arguments    : void
 * Return Type  : void
 */
void julia_spline_initialize(void)
{
  omp_init_nest_lock(&julia_spline_nestLockGlobal);
  isInitialized_julia_spline = true;
}

/*
 * File trailer for julia_spline_initialize.c
 *
 * [EOF]
 */
