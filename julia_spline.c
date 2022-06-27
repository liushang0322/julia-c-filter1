/*
 * File: julia_spline.c
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 17-May-2022 16:48:18
 */

/* Include Files */
#include "julia_spline.h"
#include "julia_spline_data.h"
#include "julia_spline_emxutil.h"
#include "julia_spline_initialize.h"
#include "julia_spline_types.h"
#include "ppval.h"
#include "rt_nonfinite.h"

/* Function Definitions */
/*
 * Arguments    : const emxArray_real_T *x
 *                const emxArray_real_T *y
 *                const emxArray_real_T *xq
 *                emxArray_real_T *p
 * Return Type  : void
 */
void julia_spline(const emxArray_real_T *x, const emxArray_real_T *y,
                  const emxArray_real_T *xq, emxArray_real_T *p)
{
  emxArray_real_T *dvdf;
  emxArray_real_T *dx;
  emxArray_real_T *endslopes;
  emxArray_real_T *md;
  emxArray_real_T *pp1_coefs;
  emxArray_real_T *s;
  struct_T expl_temp;
  const double *x_data;
  const double *y_data;
  double *dvdf_data;
  double *dx_data;
  double *md_data;
  double *pp1_coefs_data;
  double *s_data;
  int i;
  int j;
  int k;
  int nx;
  boolean_T has_endslopes;
  if (!isInitialized_julia_spline) {
    julia_spline_initialize();
  }
  y_data = y->data;
  x_data = x->data;
  nx = x->size[0] - 1;
  has_endslopes = (y->size[1] == x->size[0] + 2);
  emxInit_real_T(&s, 2);
  emxInit_real_T(&dvdf, 2);
  emxInit_real_T(&dx, 1);
  emxInit_real_T(&md, 1);
  emxInit_real_T(&endslopes, 2);
  emxInit_real_T(&pp1_coefs, 3);
  emxInitStruct_struct_T(&expl_temp);
  if ((x->size[0] <= 2) || ((x->size[0] <= 3) && (!has_endslopes))) {
    int pglen;
    pglen = y->size[0];
    has_endslopes = (y->size[1] == x->size[0] + 2);
    i = expl_temp.coefs->size[0] * expl_temp.coefs->size[1] *
        expl_temp.coefs->size[2];
    expl_temp.coefs->size[0] = y->size[0];
    expl_temp.coefs->size[1] = 1;
    if (x->size[0] <= 2) {
      if (has_endslopes) {
        expl_temp.coefs->size[2] = 4;
      } else {
        expl_temp.coefs->size[2] = 2;
      }
    } else {
      expl_temp.coefs->size[2] = 3;
    }
    emxEnsureCapacity_real_T(expl_temp.coefs, i);
    if (x->size[0] <= 2) {
      int szdvdf_idx_1;
      if (has_endslopes) {
        int nxm1;
        int pg;
        int szs_idx_1;
        i = endslopes->size[0] * endslopes->size[1];
        endslopes->size[0] = y->size[0];
        endslopes->size[1] = 2;
        emxEnsureCapacity_real_T(endslopes, i);
        md_data = endslopes->data;
        szdvdf_idx_1 = (y->size[1] - 1) * y->size[0];
        for (j = 0; j < pglen; j++) {
          md_data[j] = y_data[j];
          md_data[pglen + j] = y_data[szdvdf_idx_1 + j];
        }
        nxm1 = x->size[0];
        pg = endslopes->size[0];
        nx = endslopes->size[0] * (x->size[0] - 1);
        i = pp1_coefs->size[0] * pp1_coefs->size[1] * pp1_coefs->size[2];
        pp1_coefs->size[0] = endslopes->size[0];
        pp1_coefs->size[1] = x->size[0] - 1;
        pp1_coefs->size[2] = 4;
        emxEnsureCapacity_real_T(pp1_coefs, i);
        pp1_coefs_data = pp1_coefs->data;
        for (j = 0; j <= nxm1 - 2; j++) {
          double dnnm2;
          dnnm2 = x_data[1] - x_data[0];
          for (k = 0; k < pg; k++) {
            double d1;
            double dzzdx;
            szs_idx_1 = pglen + k;
            d1 = (y_data[(pglen + pg) + k] - y_data[szs_idx_1]) / dnnm2;
            dzzdx = (d1 - md_data[k]) / dnnm2;
            d1 = (md_data[pg + k] - d1) / dnnm2;
            pp1_coefs_data[k] = (d1 - dzzdx) / dnnm2;
            pp1_coefs_data[nx + k] = 2.0 * dzzdx - d1;
            pp1_coefs_data[(nx << 1) + k] = md_data[k];
            pp1_coefs_data[3 * nx + k] = y_data[szs_idx_1];
          }
        }
        szdvdf_idx_1 = expl_temp.coefs->size[0];
        szs_idx_1 = expl_temp.coefs->size[2];
        i = expl_temp.coefs->size[0] * expl_temp.coefs->size[1] *
            expl_temp.coefs->size[2];
        expl_temp.coefs->size[1] = 1;
        emxEnsureCapacity_real_T(expl_temp.coefs, i);
        szdvdf_idx_1 *= szs_idx_1;
        for (i = 0; i < szdvdf_idx_1; i++) {
          expl_temp.coefs->data[i] = pp1_coefs_data[i];
        }
      } else {
        double d1;
        d1 = x_data[1] - x_data[0];
        for (j = 0; j < pglen; j++) {
          i = pglen + j;
          expl_temp.coefs->data[j] = (y_data[i] - y_data[j]) / d1;
          expl_temp.coefs->data[i] = y_data[j];
        }
      }
      i = expl_temp.breaks->size[0] * expl_temp.breaks->size[1];
      expl_temp.breaks->size[0] = 1;
      expl_temp.breaks->size[1] = x->size[0];
      emxEnsureCapacity_real_T(expl_temp.breaks, i);
      szdvdf_idx_1 = x->size[0];
      for (i = 0; i < szdvdf_idx_1; i++) {
        expl_temp.breaks->data[i] = x_data[i];
      }
    } else {
      double d1;
      double d31;
      double dnnm2;
      d31 = x_data[2] - x_data[0];
      d1 = x_data[1] - x_data[0];
      dnnm2 = x_data[2] - x_data[1];
      for (j = 0; j < pglen; j++) {
        double dzzdx;
        int szdvdf_idx_1;
        szdvdf_idx_1 = pglen + j;
        dzzdx = (y_data[szdvdf_idx_1] - y_data[j]) / d1;
        i = (pglen << 1) + j;
        expl_temp.coefs->data[j] =
            ((y_data[i] - y_data[szdvdf_idx_1]) / dnnm2 - dzzdx) / d31;
        expl_temp.coefs->data[szdvdf_idx_1] =
            dzzdx - expl_temp.coefs->data[j] * d1;
        expl_temp.coefs->data[i] = y_data[j];
      }
      i = expl_temp.breaks->size[0] * expl_temp.breaks->size[1];
      expl_temp.breaks->size[0] = 1;
      expl_temp.breaks->size[1] = 2;
      emxEnsureCapacity_real_T(expl_temp.breaks, i);
      expl_temp.breaks->data[0] = x_data[0];
      expl_temp.breaks->data[1] = x_data[2];
    }
  } else {
    double d1;
    double d31;
    double dnnm2;
    int nxm1;
    int pg;
    int pglen;
    int szdvdf_idx_1;
    int szs_idx_1;
    int yoffset;
    pglen = y->size[0];
    nxm1 = x->size[0] - 1;
    if (has_endslopes) {
      szdvdf_idx_1 = y->size[1] - 3;
      szs_idx_1 = y->size[1] - 2;
      yoffset = y->size[0] - 1;
    } else {
      szdvdf_idx_1 = y->size[1] - 1;
      szs_idx_1 = y->size[1];
      yoffset = -1;
    }
    i = s->size[0] * s->size[1];
    s->size[0] = y->size[0];
    s->size[1] = szs_idx_1;
    emxEnsureCapacity_real_T(s, i);
    s_data = s->data;
    i = dvdf->size[0] * dvdf->size[1];
    dvdf->size[0] = y->size[0];
    dvdf->size[1] = szdvdf_idx_1;
    emxEnsureCapacity_real_T(dvdf, i);
    dvdf_data = dvdf->data;
    i = dx->size[0];
    dx->size[0] = x->size[0] - 1;
    emxEnsureCapacity_real_T(dx, i);
    dx_data = dx->data;
    for (k = 0; k < nxm1; k++) {
      dx_data[k] = x_data[k + 1] - x_data[k];
      szdvdf_idx_1 = k * pglen;
      pg = (yoffset + szdvdf_idx_1) + 1;
      szs_idx_1 = (yoffset + (k + 1) * pglen) + 1;
      for (j = 0; j < pglen; j++) {
        dvdf_data[szdvdf_idx_1 + j] =
            (y_data[szs_idx_1 + j] - y_data[pg + j]) / dx_data[k];
      }
    }
    for (k = 2; k <= nxm1; k++) {
      pg = (k - 1) * pglen - 1;
      szs_idx_1 = (k - 2) * pglen;
      for (j = 0; j < pglen; j++) {
        i = (pg + j) + 1;
        s_data[i] = 3.0 * (dx_data[k - 1] * dvdf_data[szs_idx_1 + j] +
                           dx_data[k - 2] * dvdf_data[i]);
      }
    }
    if (has_endslopes) {
      d31 = 0.0;
      dnnm2 = 0.0;
      for (j = 0; j < pglen; j++) {
        s_data[j] = dx_data[1] * y_data[j];
      }
      szdvdf_idx_1 = (x->size[0] + 1) * y->size[0];
      szs_idx_1 = (x->size[0] - 1) * y->size[0];
      for (j = 0; j < pglen; j++) {
        s_data[szs_idx_1 + j] = dx_data[nx - 2] * y_data[szdvdf_idx_1 + j];
      }
    } else {
      d31 = x_data[2] - x_data[0];
      dnnm2 = x_data[x->size[0] - 1] - x_data[x->size[0] - 3];
      d1 = dx_data[0];
      for (j = 0; j < pglen; j++) {
        s_data[j] = ((d1 + 2.0 * d31) * dx_data[1] * dvdf_data[j] +
                     d1 * d1 * dvdf_data[pglen + j]) /
                    d31;
      }
      pg = (x->size[0] - 1) * y->size[0];
      szs_idx_1 = (x->size[0] - 2) * y->size[0];
      szdvdf_idx_1 = (x->size[0] - 3) * y->size[0];
      d1 = dx_data[x->size[0] - 2];
      for (j = 0; j < pglen; j++) {
        s_data[pg + j] = ((d1 + 2.0 * dnnm2) * dx_data[x->size[0] - 3] *
                              dvdf_data[szs_idx_1 + j] +
                          d1 * d1 * dvdf_data[szdvdf_idx_1 + j]) /
                         dnnm2;
      }
    }
    i = md->size[0];
    md->size[0] = x->size[0];
    emxEnsureCapacity_real_T(md, i);
    md_data = md->data;
    md_data[0] = dx_data[1];
    md_data[x->size[0] - 1] = dx_data[x->size[0] - 3];
    for (k = 2; k <= nxm1; k++) {
      md_data[k - 1] = 2.0 * (dx_data[k - 1] + dx_data[k - 2]);
    }
    d1 = dx_data[1] / md_data[0];
    md_data[1] -= d1 * d31;
    for (j = 0; j < pglen; j++) {
      i = pglen + j;
      s_data[i] -= d1 * s_data[j];
    }
    for (k = 3; k <= nxm1; k++) {
      d1 = dx_data[k - 1] / md_data[k - 2];
      md_data[k - 1] -= d1 * dx_data[k - 3];
      pg = (k - 1) * pglen - 1;
      szs_idx_1 = (k - 2) * pglen;
      for (j = 0; j < pglen; j++) {
        i = (pg + j) + 1;
        s_data[i] -= d1 * s_data[szs_idx_1 + j];
      }
    }
    d1 = dnnm2 / md_data[x->size[0] - 2];
    md_data[x->size[0] - 1] -= d1 * dx_data[x->size[0] - 3];
    pg = (x->size[0] - 1) * y->size[0] - 1;
    szs_idx_1 = (x->size[0] - 2) * y->size[0];
    for (j = 0; j < pglen; j++) {
      i = (pg + j) + 1;
      s_data[i] -= d1 * s_data[szs_idx_1 + j];
    }
    for (j = 0; j < pglen; j++) {
      i = (pg + j) + 1;
      s_data[i] /= md_data[nx];
    }
    for (k = nxm1; k >= 2; k--) {
      pg = (k - 1) * pglen - 1;
      szs_idx_1 = k * pglen;
      for (j = 0; j < pglen; j++) {
        i = (pg + j) + 1;
        s_data[i] = (s_data[i] - dx_data[k - 2] * s_data[szs_idx_1 + j]) /
                    md_data[k - 1];
      }
    }
    for (j = 0; j < pglen; j++) {
      s_data[j] = (s_data[j] - d31 * s_data[pglen + j]) / md_data[0];
    }
    nxm1 = x->size[0];
    pg = s->size[0];
    nx = s->size[0] * (x->size[0] - 1);
    i = pp1_coefs->size[0] * pp1_coefs->size[1] * pp1_coefs->size[2];
    pp1_coefs->size[0] = s->size[0];
    pp1_coefs->size[1] = x->size[0] - 1;
    pp1_coefs->size[2] = 4;
    emxEnsureCapacity_real_T(pp1_coefs, i);
    pp1_coefs_data = pp1_coefs->data;
    for (j = 0; j <= nxm1 - 2; j++) {
      dnnm2 = dx_data[j];
      szdvdf_idx_1 = j * pg - 1;
      for (k = 0; k < pg; k++) {
        double dzzdx;
        szs_idx_1 = (szdvdf_idx_1 + k) + 1;
        d1 = dvdf_data[szs_idx_1];
        dzzdx = (d1 - s_data[szs_idx_1]) / dnnm2;
        d1 = (s_data[((szdvdf_idx_1 + pg) + k) + 1] - d1) / dnnm2;
        pp1_coefs_data[szs_idx_1] = (d1 - dzzdx) / dnnm2;
        pp1_coefs_data[((nx + szdvdf_idx_1) + k) + 1] = 2.0 * dzzdx - d1;
        pp1_coefs_data[(((nx << 1) + szdvdf_idx_1) + k) + 1] =
            s_data[szs_idx_1];
        pp1_coefs_data[((3 * nx + szdvdf_idx_1) + k) + 1] =
            y_data[((yoffset + szdvdf_idx_1) + k) + 2];
      }
    }
    i = expl_temp.breaks->size[0] * expl_temp.breaks->size[1];
    expl_temp.breaks->size[0] = 1;
    expl_temp.breaks->size[1] = x->size[0];
    emxEnsureCapacity_real_T(expl_temp.breaks, i);
    szdvdf_idx_1 = x->size[0];
    for (i = 0; i < szdvdf_idx_1; i++) {
      expl_temp.breaks->data[i] = x_data[i];
    }
    i = expl_temp.coefs->size[0] * expl_temp.coefs->size[1] *
        expl_temp.coefs->size[2];
    expl_temp.coefs->size[0] = pp1_coefs->size[0];
    expl_temp.coefs->size[1] = pp1_coefs->size[1];
    expl_temp.coefs->size[2] = 4;
    emxEnsureCapacity_real_T(expl_temp.coefs, i);
    szdvdf_idx_1 = pp1_coefs->size[0] * pp1_coefs->size[1] * 4;
    for (i = 0; i < szdvdf_idx_1; i++) {
      expl_temp.coefs->data[i] = pp1_coefs_data[i];
    }
  }
  emxFree_real_T(&pp1_coefs);
  emxFree_real_T(&endslopes);
  emxFree_real_T(&md);
  emxFree_real_T(&dx);
  emxFree_real_T(&dvdf);
  emxFree_real_T(&s);
  ppval(expl_temp, xq, p);
  emxFreeStruct_struct_T(&expl_temp);
}

/*
 * File trailer for julia_spline.c
 *
 * [EOF]
 */
