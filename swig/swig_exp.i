// Sensitive file ! Keep Order

// Global files to be wrapped from C++ library
// Remind that swig %include doesn't follow #include inclusion.
// You must cite below each single header file that you want to export!
// Put low level headers in first positions (otherwise Syntax error in input(1).)

#include <future>
%include swigex_export.hpp // Do not forget this file in priority (for SWIG preprocessor)
%include swigex_define.hpp

// Export VectorXXX classes
%include VectorT.hpp
%include VectorNumT.hpp
%template(VectorTInt)         VectorT< int >;
%template(VectorTDouble)      VectorT< double >;
%template(VectorString)       VectorT< String >;
%template(VectorInt)          VectorNumT< int >;
%template(VectorDouble)       VectorNumT< double >;
%template(VectorVectorInt)    VectorT< VectorInt >;
%template(VectorVectorDouble) VectorT< VectorDouble >;


%include fibo.hpp
%include args.hpp
%include polymorph.hpp
%include stdoutredirect.hpp
%include const.hpp
%include ACov.hpp
%include CovAniso.hpp
// For suppressing SWIG warning due to -keyword option (if used)
#pragma SWIG nowarn=511


%include <std_shared_ptr.i>
%shared_ptr(File);
