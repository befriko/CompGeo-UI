/* fillmissing for Octave
 *
 * This is a first cut: it will be simple.
 *
 * Step through the array, find missing data, and replace it with an
 * interpolated value. Use simple linear interpolation. This is not
 * ideal, but will be sufficient for the application I have in mind.
 *
 * The missing data will be represented by either NA or NaN.
 *   NA    Not Available (this is the intended value)
 *   NaN   Not a Number  (common alternative)
 *
 * Oh! I cannot find an equivalent of mexIsNaN for NA.
 * ---------------------------------------------------
 *
 * This code is based on a MEX example in the Octave documentation.
 * I did not find the copyright for the example code. See the manual's
 * copyright in the file Octave-manual-copyright.txt.
 *
 * Copyright 2020 Claude Marinier.
 * See the file COPYRIGHT.
 */

#include "mex.h"

/*******
 *
 * There was a typo in mex.h. Changed line 83 from
 *
 *     #define mexGetNaN mxGetNan
 *
 * to
 *
 *     #define mexGetNaN mxGetNaN
 *
 * Before this, that line was generating a compiler error.
 *
 *******/

#define DEBUG 1

#ifdef DEBUG
#include <stdio.h>
#endif

void
mexFunction ( int nlhs, mxArray* plhs[],
              int nrhs, const mxArray* prhs[] )
{
    mwSize n;
    mwIndex i, j;
    double *vri, *vro;

    if ( nrhs != 1 || ! mxIsDouble (prhs[0]) )
        mexErrMsgTxt ("ARG1 must be a double matrix");

    if (mxIsComplex (prhs[0]))
        mexErrMsgTxt ("ARG1 cannot be a complex matrix");

    n = mxGetNumberOfElements (prhs[0]);
    plhs[0] = mxCreateNumericArray ( mxGetNumberOfDimensions (prhs[0]),
                                     mxGetDimensions (prhs[0]),
                                     mxGetClassID (prhs[0]),
                                     mxIsComplex (prhs[0]) );
    vri = mxGetPr (prhs[0]);
    vro = mxGetPr (plhs[0]);

    /* Handle the degenerate cases.
     *
     * Here are the three types of cases:
     *   [ NaN ]
     *   [ NaN, 1.1 ]
     *   [ 1.1, NaN ]
     *
     * The [ NaN, NaN ] case gets converted to [ 1.1, NaN ].
     *
     * The loop can handle sizes 3 and up.
     */
    if ( n == 1 ) {
        if ( ! mexIsNaN(vri[0]) ) {
            vro[0] = vri[0];
        } else {
            /* No value: use zero. */
            vro[0] = 0.0;
        }
        return;
    } else if ( n == 2 ) {
        /* first */
        if ( ! mexIsNaN(vri[0]) ) {
            vro[0] = vri[0];
        } else {
            if ( ! mexIsNaN(vri[1]) ) {
                /* use neighbour */
                vro[0] = vri[1];
            } else {
                /* No values: use zero. */
                vro[0] = 0.0;
            }
        }
        /* second */
        if ( ! mexIsNaN(vri[1]) ) {
            vro[1] = vri[1];
        } else {
            if ( ! mexIsNaN(vri[0]) ) {
                /* use neighbour */
                vro[1] = vri[0];
            } else {
                /* No value: use zero. */
                vro[1] = 0.0;
            }
        }
        return;
    }

    /* The first and last elements only have one neighbour; handle
     * them separately. All others have two neighbours, so do simple
     * linear interpolation.
     */

    /*
     * Handle the first element
     *
     * Linear extrapolation
     *   y = m x + b
     * where m is the slope and b is the Y intercept
     *
     * say that  x1 is 1      and  x2 is 2     (it simplifies things)
     * and that  y1 is vri[1] and  y2 is vri[2]
     * the slope is ( y2 - y1 ) / ( x2 - x1 )
     * so m = vri[2] - vri[1]  because x2 - x1 = 1
     *
     * since b = y - m x
     * then  b = y1 - ( vri[2] - vri[1] ) x1
     * pick the first point
     * so    b = vri[1] - ( vri[2] - vri[1] )   because x1 = 1
     * so    b = 2 vri[1] - vri[2]
     */
    if ( ! mexIsNaN(vri[0]) ) {
        vro[0] = vri[0];
    } else {
        if ( ! mexIsNaN(vri[1]) && ! mexIsNaN(vri[2]) ) {
            /* use following two neighbours */
            vro[0] = 2.0 * vri[1] - vri[2];
        } else {
            /* one of the neighbours is bad
             * search forward for the first real number and use it
             */
            vro[0] = mexGetNaN(); /* initial value */
            for ( i = 2; i < n; i++ ) {
                if ( ! mexIsNaN(vri[i]) ) {
                    vro[0] = vri[i];
                    break;
                }
            }
            if ( mexIsNaN(vro[0]) ) {
                /* all NAN, use zero */
                vro[0] = 0.0;
            }
        }
    }

    /*
     * Handle the last element
     *
     * Linear extrapolation
     *   y = m x + b
     * where m is the slope and b is the Y intercept
     *
     * say that  x1 is 1        and  x2 is 2     (it simplifies things)
     * and that  y1 is vri[n-2] and  y2 is vri[n-3]
     * the slope is ( y2 - y1 ) / ( x2 - x1 )
     * so m = vri[n-3] - vri[n-2]  because x2 - x1 = 1
     *
     * since b = y - m x
     * then  b = y1 - ( vri[n-3] - vri[n-2] ) x1
     * pick the first point
     * so    b = vri[n-2] - ( vri[n-3] - vri[n-2] )   because x1 = 1
     * so    b = 2 vri[n-2] - vri[n-3]
     */
    if ( ! mexIsNaN(vri[n-1]) ) {
        vro[n-1] = vri[n-1];
    } else {
        if ( ! mexIsNaN(vri[n-2]) && ! mexIsNaN(vri[n-3]) ) {
            /* use previous two neighbours */
            vro[n-1] = 2.0 * vri[n-2] - vri[n-3];
        } else {
            /* one of the neighbours is bad
             * search backward for the first real number and use it
             */
            vro[n-1] = mexGetNaN(); /* initial value */
            for ( i = n-2; i >= 0; i-- ) {
                if ( ! mexIsNaN(vri[i]) ) {
                    vro[n-1] = vri[i];
                    break;
                }
            }
            if ( mexIsNaN(vro[n-1]) ) {
                /* all NAN, use zero */
                vro[n-1] = 0.0;
            }
        }
    }

    /*
     * must skip the first and last elements (handled separately above)
     */
    for ( i = 1; i < n-1; i++ ) {

        if ( ! mexIsNaN(vri[i]) ) {

            /* common case: nothing to do */
            vro[i] = vri[i];

        } else {

            /* need to replace this one
             * interpolate using preceeding and following neighbours
             */

            if ( ! mexIsNaN(vri[i-1]) && ! mexIsNaN(vri[i+1]) ) {

                /* neighbours are good, use them */
                vro[i] = ( vri[i-1] + vri[i+1] ) / 2.0;

            } else {

                /* one of the neighbours is bad
                 *
                 * Search backward or forward or both when one or both
                 * neighbours are also NaN.
                 *
                 * If the search hits an end, use the corresponding value
                 * from vro which was previously set.
                 */
                double a, b;

                if ( ! mexIsNaN(vri[i-1]) ) {
                    a = vri[i-1];
                } else {
                    /*
                     * search backward for the first real number and use it
                     */
                    a = mexGetNaN(); /* initial value */
                    for ( j = i-2; j >= 0; j-- ) {
                        if ( ! mexIsNaN(vri[j]) ) {
                            a = vri[j];
#ifdef DEBUG
/*  printf( "a = %f\n", a );  */
#endif
                            break;
                        }
                    }
                    if ( mexIsNaN(a) ) {
                        /* all NaN on the left,
                         * use first which was set earlier
                         */
                        a = vro[0];
                    }
                }

                if ( ! mexIsNaN(vri[i+1]) ) {
                    b = vri[i+1];
                } else {
                    /*
                     * search forward for the first real number and use it
                     */
                    b = mexGetNaN(); /* initial value */
                    for ( j = i+2; j < n; j++ ) {
                        if ( ! mexIsNaN(vri[j]) ) {
                            b = vri[j];
#ifdef DEBUG
/*  printf( "b = %f\n", b );  */
#endif
                            break;
                        }
                    }
                    if ( mexIsNaN(b) ) {
                        /* all NaN on the right,
                         * use last which was set earlier
                         */
                        b = vro[n-1];
                    }
                }

                vro[i] = ( a + b ) / 2.0;

            }

        }
    }
}
