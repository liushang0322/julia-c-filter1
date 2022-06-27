/*
 * File: ppval.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 17-May-2022 16:48:18
 */

/* Include Files */
#include "ppval.h"
#include "bsearch.h"
#include "julia_spline_emxutil.h"
#include "julia_spline_types.h"
#include "rt_nonfinite.h"
#include "omp.h"
#include "rt_nonfinite.h"

/* Function Definitions */
/*
 * Arguments    : const struct_T pp
 *                const emxArray_real_T *x
 *                emxArray_real_T *v
 * Return Type  : void
 */
void ppval(const struct_T pp, const emxArray_real_T *x, emxArray_real_T *v)
{
  const double *x_data;
  double b_v;
  double b_xloc;
  double *v_data;
  int b_ic;
  int b_ip;
  int b_ix;
  int coefStride;
  int elementsPerPage;
  int ic;
  int ip;
  int ix;
  int j;
  int numTerms;
  int nx;
  x_data = x->data;
  numTerms = pp.coefs->size[2];
  elementsPerPage = pp.coefs->size[0];
  coefStride = pp.coefs->size[0] * (pp.breaks->size[1] - 1);
  ip = v->size[0] * v->size[1] * v->size[2];
  v->size[0] = pp.coefs->size[0];
  v->size[1] = x->size[0];
  v->size[2] = x->size[1];
  emxEnsureCapacity_real_T(v, ip);
  v_data = v->data;
  nx = x->size[0] * x->size[1] - 1;
  if (pp.coefs->size[0] == 1) {
#pragma omp parallel for num_threads(omp_get_max_threads()) private(           \
    b_ip, b_v, b_xloc, b_ic)

    for (b_ix = 0; b_ix <= nx; b_ix++) {
      if (rtIsNaN(x_data[b_ix])) {
        b_v = x_data[b_ix];
      } else {
        b_ip = b_bsearch(pp.breaks, x_data[b_ix]) - 1;
        b_xloc = x_data[b_ix] - pp.breaks->data[b_ip];
        b_v = pp.coefs->data[b_ip];
        for (b_ic = 2; b_ic <= numTerms; b_ic++) {
          b_v = b_xloc * b_v + pp.coefs->data[b_ip + (b_ic - 1) * coefStride];
        }
      }
      v_data[b_ix] = b_v;
    }
  } else {
    for (ix = 0; ix <= nx; ix++) {
      int iv0;
      iv0 = ix * elementsPerPage;
      if (rtIsNaN(x_data[ix])) {
        for (j = 0; j < elementsPerPage; j++) {
          v_data[iv0 + j] = x_data[ix];
        }
      } else {
        double xloc;
        int icp;
        ip = b_bsearch(pp.breaks, x_data[ix]) - 1;
        icp = ip * elementsPerPage;
        xloc = x_data[ix] - pp.breaks->data[ip];
        for (j = 0; j < elementsPerPage; j++) {
          v_data[iv0 + j] = pp.coefs->data[icp + j];
        }
        for (ic = 2; ic <= numTerms; ic++) {
          int ic0;
          ic0 = icp + (ic - 1) * coefStride;
          for (j = 0; j < elementsPerPage; j++) {
            ip = iv0 + j;
            v_data[ip] = xloc * v_data[ip] + pp.coefs->data[ic0 + j];
          }
        }
      }
    }
  }
}

/*
 * File trailer for ppval.c
 *
 * [EOF]
 */
