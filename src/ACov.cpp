#include "ACov.hpp"
#include <iostream>
#include <cmath>

ACov::ACov(const std::string &op):
_op(op)
{
}

double ACov::evalCov(double h) const
{   
    if (_covlist.empty())
    {
        std::cout <<"covariance not initialized!" <<std::endl;
        return NAN;
    }
    double s;
    if (_op == "+")
        s = 0.;
    if (_op == "x")
        s = 1.;
    for(const auto &e : _covlist)
    {
        if (_op == "+")
            s += e->evalCov(h);
        if (_op == "x")
            s *= e->evalCov(h);
    }
    return s;
}

void ACov::push(const ACov* cov)
{
    _covlist.push_back(cov);
}
ACov ACov::sum(const ACov* acov1,const ACov* acov2)
{
    auto acov = ACov("+");
    acov.push(acov1);
    acov.push(acov2);
    return acov;

}

ACov ACov::product(const ACov* acov1,const ACov* acov2)
{
    auto acov = ACov("x");
    acov.push(acov1);
    acov.push(acov2);
    return acov;

}

