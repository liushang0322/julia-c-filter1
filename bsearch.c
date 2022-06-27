/*
 * File: bsearch.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 17-May-2022 16:48:18
 */

/* Include Files */
#include "bsearch.h"
#include "julia_spline_types.h"
#include "rt_nonfinite.h"

/* Function Definitions */
/*
 * Arguments    : const emxArray_real_T *x
 *                double xi
 * Return Type  : int
 */
int b_bsearch(const emxArray_real_T *x, double xi)
{
  const double *x_data;
  int high_i;
  int low_ip1;
  int n;
  x_data = x->data;
  high_i = x->size[1];
  n = 1;
  low_ip1 = 2;
  while (high_i > low_ip1) {
    int mid_i;
    mid_i = (n >> 1) + (high_i >> 1);
    if (((n & 1) == 1) && ((high_i & 1) == 1)) {
      mid_i++;
    }
    if (xi >= x_data[mid_i - 1]) {
      n = mid_i;
      low_ip1 = mid_i + 1;
    } else {
      high_i = mid_i;
    }
  }
  return n;
}

/*
 * File trailer for bsearch.c
 *
 * [EOF]
 */
