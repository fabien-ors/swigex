#pragma once

#include "swigex_export.hpp"
#include <string>
#include <vector>

class ACov;
/**
 * Class which handles abstract Cov
 */
class SWIGEX_EXPORT ACov
{
  public:
    ACov (const std::string &op = "+");
    virtual double evalCov(double h) const;
    void push(const ACov* cov);
    virtual ~ACov(){};

  static ACov sum(const ACov* acov1,const ACov* acov2);
  static ACov product(const ACov* acov1,const ACov* acov2);


  protected:
    std::vector<const ACov*>    _covlist; 
    std::string           _op;
};

