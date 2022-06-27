/*
 * File: julia_spline_types.h
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 17-May-2022 16:48:18
 */

#ifndef JULIA_SPLINE_TYPES_H
#define JULIA_SPLINE_TYPES_H

/* Include Files */
#include "rtwtypes.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T
struct emxArray_real_T {
  double *data;
  int *size;
  int allocatedSize;
  int numDimensions;
  boolean_T canFreeData;
};
#endif /* struct_emxArray_real_T */
#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T
typedef struct emxArray_real_T emxArray_real_T;
#endif /* typedef_emxArray_real_T */

#ifndef typedef_struct_T
#define typedef_struct_T
typedef struct {
  emxArray_real_T *breaks;
  emxArray_real_T *coefs;
} struct_T;
#endif /* typedef_struct_T */

#endif
/*
 * File trailer for julia_spline_types.h
 *
 * [EOF]
 */
