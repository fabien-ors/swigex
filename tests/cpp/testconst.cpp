#include "const.hpp"
#include "stdoutredirect.hpp"

#include <memory>

int main()
{
  //StdoutRedirect sr("testconst.out");
  
  File  a(1,"obj");
  File* b = new File(2,"p");
  File* c = new File(3,"pc");
  File* d = new File(4,"cp");
  File* e = new File(5,"cpc");
  std::shared_ptr<const File> f(new File(5,"shr"));

  //std::shared_ptr<const File> f(new File(6,"sh"));
  Folder folder(a,b,c,d,e,f);
  folder.display();

  a.setA(-1);
  b->setA(-1);
  c->setA(-1);
  d->setA(-1);
  e->setA(-1);
  //f->setA(-1);// forbiden
  folder.display();
  return 0;
}
