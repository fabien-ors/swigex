#pragma once

#include "swigex_export.hpp"

#include <map>

class SWIGEX_EXPORT OptCst
{
public:
  enum ECst
  {
    E_NTCAR   = 1,
    E_NTDEC   = 2,
    E_NTROW   = 3,
    E_NTCOL   = 4,
    E_NTBATCH = 5,
    E_NTNAME  = 6,
    E_NTRANK  = 7,
    E_NPROC   = 8,
    E_LOCMOD  = 9
  };
  
  static double query(const ECst& option);
  static void   define(const ECst& option, double value);
  static void   display(void);

private:
  static std::map<int, double> _cst;
};
