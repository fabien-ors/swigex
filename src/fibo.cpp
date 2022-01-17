#include "fibo.hpp"
#include <iostream>

/**
 * Print Fibonacci numbers up to the provided value
 *
 * @param n: maximum value to be generated
 */
std::vector<int> fib(int n)
{
  std::vector<int> res;
  int a = 0;
  int b = 1;
  while (a < n)
  {
    res.push_back(a);
    int aa = a;
    a = b;
    b = aa+b;
  }
  return res;
}

/**
 * Default constructor of a class which handle Fibonacci integer serie up to n
 * 
 * @param n     Strict Positive Integer
 * @param title Title to be printed
 */
Fibo::Fibo(int n, const std::string& title)
: _n(n)
, _title(title)
{
  if (_n <= 0)
  {
    std::cout << "Fibonacci class must be initialized with a strict positive integer. N is set to 50." << std::endl;
    _n = 50;
  }
  if (_title.empty())
  {
    _title = "Fibonacci";
  }
}

/**
 * Destructor
 */
Fibo::~Fibo()
{
}

/**
 * Write the Fibonacci serie to standard output
 *
 * @param showTitle Flag for displaying title
 */
void Fibo::display(bool showTitle) const
{
  if (showTitle) std::cout << _title << ": ";
  std::vector<int> res = get();
  for (const auto& i: res)
    std::cout << i << ' ';
  std::cout << std::endl;

}

/**
 * Return the Fibonacci serie as a vector of integer
 *
 * @return Fibonacci integer vector serie
 */
std::vector<int> Fibo::get() const
{
  return fib(_n);
}
