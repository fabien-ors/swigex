#include "fibo.hpp"
#include "version.h"

#include <iostream>
#include <sstream>


/**
 * Return the Nth Fibonacci number, -1 in case of error
 * (Global functions in C-style)
 *
 * @param n: index of the value
 */
int fibn(int n)
{
  if (n <= 0 || n == INT_NA)
  {
    std::cout << "Error in fibn: Integer argument must be strictly positive!"
              << std::endl;
    return -1;
  }
  int a = 0;
  int b = 1;
  int i = 1;
  while (true)
  {
    if (i == n) return a;
    int aa = a;
    a      = b;
    b      = aa + b;
    i++;
  }
  std::cout << "Error in fibn: Unknown error!" << std::endl;
  return -1;
}

/**
 * Return the Fibonacci numbers up to the provided integer value
 * in a vector of integers
 * (Global functions in C-style)
 *
 * @param n: maximum value to be generated
 */
VectorInt fib(int n)
{
  VectorInt res;
  if (n <= 0 || n == INT_NA)
  {
    std::cout << "Error in fib: Integer argument must be strictly positive!"
              << std::endl;
    return res;
  }
  int a = 0;
  int b = 1;
  while (a < n)
  {
    res.push_back(a);
    int aa = a;
    a      = b;
    b      = aa + b;
  }
  return res;
}

/**
 * Default constructor of a class which handle Fibonacci integers list up to n
 *
 * @param n     Strict positive Integer
 * @param title Title to be printed (optional)
 */
Fibo::Fibo(int n, const String& title)
  : _n(n)
  , _title(title)
{
  if (_n <= 0)
  {
    std::cout << "Fibonacci class must be initialized with a strict positive "
                 "integer. N is set to 50."
              << std::endl;
    _n = 50;
  }

  if (_title.empty())
  {
    std::stringstream sstr;
    sstr << DEFAULT_TITLE << " ("
         << SWIGEX_FULL_VERSION <<" - " << SWIGEX_DATE << ")";
    _title = sstr.str();
  }
}

/**
 * Destructor
 */
Fibo::~Fibo()
{
}

/**
 * Reset the Fibonacci list from another one
 * (In order to test class argument as value)
 *
 * @param fibo Source Fibonacci list
 */
void Fibo::resetFromFiboVal(Fibo fibo)
{
  _title = fibo._title;
  _n     = fibo._n;
}

/**
 * Reset the Fibonacci list from another one
 * (In order to test class argument as reference)
 *
 * @param fibo Source Fibonacci list
 */
void Fibo::resetFromFiboRef(const Fibo& fibo)
{
  _title = fibo._title;
  _n     = fibo._n;
}

/**
 * Write the Fibonacci list to standard output
 *
 * @param showTitle Flag for printing the title
 */
void Fibo::display(bool showTitle) const
{
  if (showTitle)
    std::cout << _title << ": ";
  VectorInt res = get();
  for (const auto& i: res)
    std::cout << i << ' ';
  std::cout << std::endl;
}

/**
 * Return the Fibonacci list as a vector of integers
 *
 * @return Fibonacci integers vector
 */
VectorInt Fibo::get() const
{
  // Make a copy of the vector
  return fib(_n);
}

/**
 * Return the Fibo object title (including version and date by default)
 *
 * @return title
 */
std::string Fibo::getTitle() const
{
  return _title;
}
