#pragma once

#include "swigex_export.hpp"
#include "swigex_define.hpp"
#include "VectorNumT.hpp"

SWIGEX_EXPORT int fibn(int n);
SWIGEX_EXPORT VectorInt fib(int n);

/**
 * Class which handles Fibonacci integers list
 */
class SWIGEX_EXPORT Fibo
{
  public:
    Fibo(int n, const String& title = "");
    virtual ~Fibo();

    void resetFromFiboVal(Fibo fib);
    void resetFromFiboRef(const Fibo& fib);

    void display(bool showTitle = true) const;

    VectorInt get() const;
    String getTitle() const;

  protected:
    int    _n;     ///< Maximum integer of the Fibonacci list
    String _title; ///< Title to be shown when displaying the list
};

