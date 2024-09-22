#include "CovAniso.hpp"
#include <cmath>


CovAniso::CovAniso(double a):_scale(a){}

double CovAniso::evalCov(double h) const
{
    return exp(-h/_scale);
}