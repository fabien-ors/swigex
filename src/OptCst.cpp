
#include "OptCst.hpp"
#include "swigex_define.hpp"

#include <iostream>
#include <sstream>

std::map<int, double> OptCst::_cst =
 {{ ECst::E_NTCAR,  10. },
  { ECst::E_NTDEC,   3. },
  { ECst::E_NTROW,   7. },
  { ECst::E_NTCOL,   7. },
  { ECst::E_NTBATCH, 7. },
  { ECst::E_NTNAME, 12. },
  { ECst::E_NTRANK,  3. },
  { ECst::E_NPROC,   0. },
  { ECst::E_LOCMOD,  1. }};

double OptCst::query(const ECst& option)
{
  for (auto e: _cst)
  {
    if (e.first == option) return e.second;
  }
  return DOUBLE_NA;
}


void OptCst::define(const ECst& option, double value)
{
  for (auto &e: _cst)
  {
    if (e.first == option)
    {
      e.second = value;
      return;
    }
  }
}

void OptCst::display()
{
  std::stringstream sstr;

  sstr << "List of Options of internal Constant values";

  for (auto e: _cst)
  {
    sstr << std::endl;
    switch (e.first)
    {
      case ECst::E_NTCAR:
        sstr << " - NTCAR:";
        break;
      case ECst::E_NTDEC:
        sstr << " - NTDEC:";
        break;
      case ECst::E_NTROW:
        sstr << " - NTROW:";
        break;
      case ECst::E_NTCOL:
        sstr << " - NTCOL:";
        break;
      case ECst::E_NTBATCH:
        sstr << " - NTBATCH:";
        break;
      case ECst::E_NTNAME:
        sstr << " - NTNAME:";
        break;
      case ECst::E_NTRANK:
        sstr << " - NTRANK:";
        break;
      case ECst::E_NPROC:
        sstr << " - NPROC:";
        break;
      case ECst::E_LOCMOD:
        sstr << " - LOCMOD:";
        break;
      default:
        sstr << " - UNKNOWN OPTION";
    }
    sstr << e.second;
  }

  sstr << "Use 'OptCst::define' to modify the previous values" << std::endl;

  std::cout << sstr.str();
}