#include <stdio.h>

#include "mex.h"

typedef unsigned int ub4;
typedef unsigned char ub1;

#define mix(a,b,c) \
{ \
	a -= b; a -= c; a ^= (c>>13); \
	b -= c; b -= a; b ^= (a<<8); \
	c -= a; c -= b; c ^= (b>>13); \
	a -= b; a -= c; a ^= (c>>12); \
	b -= c; b -= a; b ^= (a<<16); \
	c -= a; c -= b; c ^= (b>>5); \
	a -= b; a -= c; a ^= (c>>3); \
	b -= c; b -= a; b ^= (a<<10); \
	c -= a; c -= b; c ^= (b>>15); \
}


unsigned int
hash_func1(register ub1 *k, register ub4 length, register ub4 initval)
{
register ub4 a, b, c, len;

	/* Set up the internal state */
	len = length;
	a = b = 0x9e3779b9;
	c = initval;

	/* handle most of the key */
	while(len >= 12) {
		a += (k[0] + ((ub4)k[1]<<8) + ((ub4)k[2]<<16) + ((ub4)k[3]<<24));
		b += (k[4] + ((ub4)k[5]<<8) + ((ub4)k[6]<<16) + ((ub4)k[7]<<24));
		c += (k[8] + ((ub4)k[9]<<8) + ((ub4)k[10]<<16) + ((ub4)k[11]<<24));
		mix(a, b, c);
		k += 12; len -= 12;
	}

	c += length;
	switch(len) {
		case 11: c += ((ub4)k[10]<<24);
		case 10: c += ((ub4)k[9]<<16);
		case 9:  c += ((ub4)k[8]<<8);
		case 8:  b += ((ub4)k[7]<<24);
		case 7:  b += ((ub4)k[6]<<16);
		case 6:  b += ((ub4)k[5]<<8);
		case 5:  b += k[4];
		case 4:  a += ((ub4)k[3]<<24);
		case 3:  a += ((ub4)k[2]<<16);
		case 2:  a += ((ub4)k[1]<<8);
		case 1:  a += k[0];
	}
	mix(a, b, c);

	return c;
}


void 
mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
int mrows, ncols;
double *x, *h;
unsigned int hval;

	/* Check if proper number of arguments */
	if(nrhs != 1) {
		mexErrMsgTxt("One Input is required.");
	} else if(nlhs != 1) {
		mexErrMsgTxt("One output is returned.");
	}

	/* First input is x */
	mrows = mxGetM(prhs[0]);
	ncols = mxGetN(prhs[0]);
	/*
	if(!mxIsDouble(prhs[0]) || !(mrows == 1)) {
		mexErrMsgTxt("First input must be a column array of integers.");
	}
	*/
	x = (double *)mxGetPr(prhs[0]);

	/* Create output variables */
	plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
	h = (double *)mxGetPr(plhs[0]);

	/* Calculate hash value */
	hval = hash_func1((unsigned char *)x, mrows * sizeof(double), 0);
	
	hval += (hval << 9);
	hval ^= ((hval >> 14) | (hval << 18));
	hval += (hval << 4);
	hval ^= ((hval >> 10) | (hval << 22));
	
	*h = (double)hval;
}
