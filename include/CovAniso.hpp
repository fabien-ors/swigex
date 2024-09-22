#pragma once

#include "ACov.hpp"
#include "swigex_export.hpp"

class ACov;

/**
 * Class which handles Fibonacci integers list
 */
class SWIGEX_EXPORT CovAniso : public ACov
{
  public:
    CovAniso (double a = 1.);
    double evalCov (double h) const override;
    virtual ~CovAniso(){};

  protected:
    double _scale;    
};

