#pragma once

#include "ACov.hpp"
#include "swigex_export.hpp"
#include "swigex_define.hpp"
#include "VectorNumT.hpp"

class ACov;

/**
 * Class which handles Fibonacci integers list
 */
class SWIGEX_EXPORT CovAniso : public ACov
{
  public:
    CovAniso (double a = 1.);
    double evalCov (double h) const override {return exp(-h/_scale);}
    virtual ~CovAniso(){};

  protected:
    double _scale;    
};

