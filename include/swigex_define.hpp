#pragma once

#include <string>
#include <cmath>
#include <math.h>

typedef std::string String;
using Id = long long;

#define DEFAULT_TITLE "Fibonacci List"

#ifndef SWIG

#define INT_NA    -999
#define DOUBLE_NA -999.999
#define STRING_NA "NA"
#define I32       int

#define EPSILON1  1.e-1
#define EPSILON2  1.e-2
#define EPSILON3  1.e-3
#define EPSILON4  1.e-4
#define EPSILON5  1.e-5
#define EPSILON6  1.e-6
#define EPSILON7  1.e-7
#define EPSILON8  1.e-8
#define EPSILON9  1.e-9
#define EPSILON10 1.e-10
#define EPSILON12 1.e-12
#define EPSILON13 1.e-13
#define EPSILON20 1.e-20
#define EPSILON25 1.e-25

#define DECLARE_UNUSED_(x)  (void)x;

#define MIN(a, b)          (((a) < (b)) ? (a) : (b))
#define MAX(a, b)          (((a) > (b)) ? (a) : (b))
#define ABS(a)             (((a) < 0.) ? -(a) : (a))

template <typename T> inline T getNA();
template <> inline double getNA() { return DOUBLE_NA; }
template <> inline Id     getNA() { return INT_NA; }
template <> inline String getNA() { return STRING_NA; }

template <typename T> inline bool isNA(const T& v);
template <> inline bool isNA(const double& v) { return (v == getNA<double>() || std::isnan(v) || std::isinf(v)); }
template <> inline bool isNA(const Id& v)     { return (v == getNA<Id>()); }
template <> inline bool isNA(const String& v) { return (v == getNA<String>()); }

#endif // SWIG
