#include "String.hpp"
#include "VectorT.hpp"
#include "VectorNumT.hpp"
#include "stdoutredirect.hpp"

#include <iostream>

int main()
{
  StdoutRedirect sr("testVectorT.out");

  VectorInt vec;
  vec.push_back(1);
  vec.push_back(2);
  for(auto v : vec) std::cout << v << " ";
  std::cout << std::endl;

  VectorDouble vd;
  vd.push_back(1.5);
  vd.push_back(2.6);
  for(auto v : vd) std::cout << v << " ";
  std::cout << std::endl;
  std::cout << "Mean=" << vd.mean() << std::endl;

  VectorString vs;
  vs.push_back("Hey");
  vs.push_back("You");
  for(const auto& v : vs) std::cout << v << " ";
  std::cout << std::endl;

  vec.push_back(3);
  vec.push_back(4);
  std::cout << toStrMatrix("Matrix of integer", {"Col1", "Col2"}, {"Row 1", "Row 2"}, true, 2, 2, vec) << std::endl;

  vd.push_back(3.7);
  vd.push_back(4.8);
  std::cout << toStrMatrix("Matrix of double", {"Col1", "Col2"}, {"Row 1", "Row 2"}, true, 2, 2, vd) << std::endl;
  return 0;
}
