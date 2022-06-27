/*
 * File: julia_spline_emxAPI.h
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 17-May-2022 16:48:18
 */

#ifndef JULIA_SPLINE_EMXAPI_H
#define JULIA_SPLINE_EMXAPI_H

/* Include Files */
#include "julia_spline_types.h"
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
extern emxArray_real_T *emxCreateND_real_T(int numDimensions, const int *size);

extern emxArray_real_T *
emxCreateWrapperND_real_T(double *data, int numDimensions, const int *size);

extern emxArray_real_T *emxCreateWrapper_real_T(double *data, int rows,
                                                int cols);

extern emxArray_real_T *emxCreate_real_T(int rows, int cols);

extern void emxDestroyArray_real_T(emxArray_real_T *emxArray);

extern void emxInitArray_real_T(emxArray_real_T **pEmxArray, int numDimensions);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for julia_spline_emxAPI.h
 *
 * [EOF]
 */
