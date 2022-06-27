/*
 * File: julia_spline_emxutil.h
 *
 * MATLAB Coder version            : 5.4
 * C/C++ source code generated on  : 17-May-2022 16:48:18
 */

#ifndef JULIA_SPLINE_EMXUTIL_H
#define JULIA_SPLINE_EMXUTIL_H

/* Include Files */
#include "julia_spline_types.h"
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
extern void emxEnsureCapacity_real_T(emxArray_real_T *emxArray, int oldNumel);

extern void emxFreeStruct_struct_T(struct_T *pStruct);

extern void emxFree_real_T(emxArray_real_T **pEmxArray);

extern void emxInitStruct_struct_T(struct_T *pStruct);

extern void emxInit_real_T(emxArray_real_T **pEmxArray, int numDimensions);

#ifdef __cplusplus
}
#endif

#endif
/*
 * File trailer for julia_spline_emxutil.h
 *
 * [EOF]
 */
