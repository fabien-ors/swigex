#include "polymorph.hpp"
#include "stdoutredirect.hpp"

#include <iostream>

class ChildTwo : public AParent
{
public:
  ChildTwo(): AParent() {}
  virtual ~ChildTwo() {}

  String getHello() const override { return "ChildTwo in C++ - Hello"; }

  // ICloneable* clone() const override { return new ChildTwo(); }
};

int main()
{
  StdoutRedirect sr("testPolymorph.out");
  
  // AParent pa;
  // showHello(&pa);
  ChildOne co;
  showHello(&co);
  ChildTwo ct;
  showHello(&ct);

  return 0;
}
