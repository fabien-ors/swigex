#pragma once

#include "swigex_export.hpp"
#include "swigex_define.hpp"
#include "VectorNumT.hpp"

SWIGEX_EXPORT Id fibn(Id n);
SWIGEX_EXPORT VectorInt fib(Id n);

/**
 * Class which handles Fibonacci integers list
 * 
 * The following comment is for test purpose.
 * 
 * \link Fibo FiboClass \endlink
 * 
 * The distance between \f$ p1=(x_1,y_1) \f$ and \f$ p2=(x_2,y_2) \f$ is \f$\sqrt{(x_2-x_1)^2+(y_2-y_1)^2}\f$
 * 
 * \remark This is a remark for test purpose.
 */
class SWIGEX_EXPORT Fibo
{
  public:
    Fibo(Id n, const String& title = "");
    virtual ~Fibo();

    void resetFromFiboVal(Fibo fib);
    void resetFromFiboRef(const Fibo& fib);

    void display(bool showTitle = true) const;

    VectorInt get() const;
    String getTitle() const;

  protected:
    Id     _n;     ///< Maximum integer of the Fibonacci list
    String _title; ///< Title to be shown when displaying the list
};

