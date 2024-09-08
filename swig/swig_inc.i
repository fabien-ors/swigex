%feature(director) ICloneable;
%feature(director) AParent;

%{
  #include "swigex_export.hpp"
  #include "swigex_define.hpp"
  #include "VectorT.hpp"
  #include "VectorNumT.hpp"
  #include "fibo.hpp"
  #include "args.hpp"
  #include "polymorph.hpp"
  #include "stdoutredirect.hpp"
  #include "const.hpp"
  #include "ACov.hpp"
  #include "CovAniso.hpp"
%}

////////////////////////////
//        Typemaps        //
////////////////////////////

// Mandatory for using swig::asptr and swig::from for std::vectors
%include std_vector.i
%include std_string.i
%template(DoNotUseVectorIntStd)     std::vector< int >;
%template(DoNotUseVectorDoubleStd)  std::vector< double >;
%template(DoNotUseVectorStringStd)  std::vector< std::string >; // Keep std::string here otherwise asptr fails!
%template(DoNotUseVVectorIntStd)    std::vector< std::vector< int > >;
%template(DoNotUseVVectorDoubleStd) std::vector< std::vector< double > >;

////////////////////////////////////////////////
// Conversion Target language => C++

// Note : Before including this file :
//        - vectorToCpp, vectorVectorToCpp and convertToCpp 
//          functions must be defined in ToCpp fragment

// Convert scalar arguments by value
%typemap(in, fragment="ToCpp") int,
                               double,
                               String
{
  int errcode = convertToCpp($input, $1);
  if (!SWIG_IsOK(errcode))
    %argument_fail(errcode, "$type", $symname, $argnum);
}

// Convert scalar argument by reference
%typemap(in, fragment="ToCpp") int*       (int val), const int*       (int val),
                               int&       (int val), const int&       (int val),
                               double* (double val), const double* (double val),
                               double& (double val), const double& (double val) // Don't add String here otherwise "res2 not declared"
{
  int errcode = convertToCpp($input, val);
  if (!SWIG_IsOK(errcode))
    %argument_fail(errcode, "$type", $symname, $argnum);
  $1 = &val;
}

%typemap(in, fragment="ToCpp") VectorInt    (void *argp),
                               VectorDouble (void *argp),
                               VectorString (void *argp)
{ 
  // Try to convert from any target language vector
  int errcode = vectorToCpp($input, $1);
  if (!SWIG_IsOK(errcode))
  {
    // Try direct conversion of Vectors by value (see swigtypes.swg)
    errcode = SWIG_ConvertPtr($input, &argp, $&descriptor, %convertptr_flags);
    if (SWIG_IsOK(errcode))
    {
      if (!argp) {
        %argument_nullref("$type", $symname, $argnum);
      }
      else {
        $&ltype temp = %reinterpret_cast(argp, $&ltype);
        $1 = *temp;
        if (SWIG_IsNewObj(errcode)) %delete(temp);
      }
    }
    else
      %argument_fail(errcode, "$type", $symname, $argnum);
  }
}

%typemap(in, fragment="ToCpp") VectorVectorInt    (void *argp),
                               VectorVectorDouble (void *argp)
{
  // Try to convert from any target language vector
  int errcode = vectorVectorToCpp($input, $1);
  if (!SWIG_IsOK(errcode))
  {
    // Try direct conversion of VectorVectors by value (see swigtypes.swg)
    errcode = SWIG_ConvertPtr($input, &argp, $&descriptor, %convertptr_flags);
    if (SWIG_IsOK(errcode))
    {
      if (!argp) {
        %argument_nullref("$type", $symname, $argnum);
      }
      else {
        $&ltype temp = %reinterpret_cast(argp, $&ltype);
        $1 = *temp;
        if (SWIG_IsNewObj(errcode)) %delete(temp);
      }
    }
    else {
      %argument_fail(errcode, "$type", $symname, $argnum);
    }
  }
}

%typemap(in, fragment="ToCpp") const VectorInt&    (void *argp, VectorInt vec),
                               const VectorInt*    (void *argp, VectorInt vec),
                               const VectorDouble& (void *argp, VectorDouble vec),
                               const VectorDouble* (void *argp, VectorDouble vec),
                               const VectorString& (void *argp, VectorString vec),
                               const VectorString* (void *argp, VectorString vec)
{
  // Try to convert from any target language vector
  int errcode = vectorToCpp($input, vec);
  if (!SWIG_IsOK(errcode))
  {
    try
    {
      // Try direct conversion of Vectors by reference/pointer (see swigtypes.swg)
      errcode = SWIG_ConvertPtr($input, &argp, $descriptor, %convertptr_flags);
      if (SWIG_IsOK(errcode))
      {
        if (!argp) {
          %argument_nullref("$type", $symname, $argnum);
        }
        $1 = %reinterpret_cast(argp, $ltype);
      }
      else {
        %argument_fail(errcode, "$type", $symname, $argnum);
      }
    }
    catch(...)
    {
      %argument_fail(errcode, "$type", $symname, $argnum);
    }
  }
  else {
    $1 = &vec;
  }
}

%typemap(in, fragment="ToCpp") const VectorVectorInt&    (void *argp, VectorVectorInt vec),
                               const VectorVectorInt*    (void *argp, VectorVectorInt vec),
                               const VectorVectorDouble& (void *argp, VectorVectorDouble vec),
                               const VectorVectorDouble* (void *argp, VectorVectorDouble vec)
{
  // Try to convert from any target language vector
  int errcode = vectorVectorToCpp($input, vec);
  if (!SWIG_IsOK(errcode))
  {
    try
    {
      // Try direct conversion of VectorVectors by reference/pointer (see swigtypes.swg)
      errcode = SWIG_ConvertPtr($input, &argp, $descriptor, %convertptr_flags);
      if (SWIG_IsOK(errcode))
      {
        if (!argp) {
          %argument_nullref("$type", $symname, $argnum);
        }
        $1 = %reinterpret_cast(argp, $ltype);
      }
      else {
        %argument_fail(errcode, "$type", $symname, $argnum);
      }
    }
    catch(...)
    {
      %argument_fail(errcode, "$type", $symname, $argnum);
    }
  }
  else
  {
    $1 = &vec;
  }
}

////////////////////////////////////////////////
// Conversion C++ => Target language

// Note : Before including this file :
//        - vectorFromCpp, vectorVectorFromCpp and objectFromCpp 
//          functions must be defined in FromCpp fragment

%typemap(out, fragment="FromCpp") int,
                                  double,
                                  String
{
  $result = objectFromCpp($1);
}

%typemap(out, fragment="FromCpp") int*,    const int*,    int&,    const int&,
                                  double*, const double*, double&, const double&,
                                  String*, const String*, String&, const String&
{
  $result = objectFromCpp(*$1);
}

%typemap(out, fragment="FromCpp") VectorInt, 
                                  VectorDouble, 
                                  VectorString
{
  int errcode = vectorFromCpp(&($result), $1);
  if (!SWIG_IsOK(errcode))
    SWIG_exception_fail(SWIG_ArgError(errcode), "in method $symname, wrong return value: $type");
}

%typemap(out, fragment="FromCpp") VectorInt*,    VectorInt&,
                                  VectorDouble*, VectorDouble&,
                                  VectorString*, VectorString&
{
  int errcode = vectorFromCpp(&($result), *$1);
  if (!SWIG_IsOK(errcode))
    SWIG_exception_fail(SWIG_ArgError(errcode), "in method $symname, wrong return value: $type");
}

%typemap(out, fragment="FromCpp") VectorVectorInt,
                                  VectorVectorDouble
{
  int errcode = vectorVectorFromCpp(&($result), $1);
  if (!SWIG_IsOK(errcode))
    SWIG_exception_fail(SWIG_ArgError(errcode), "in method $symname, wrong return value: $type");
}

%typemap(out, fragment="FromCpp") VectorVectorInt*,    VectorVectorInt&,
                                  VectorVectorDouble*, VectorVectorDouble&
{
  int errcode = vectorVectorFromCpp(&($result), *$1);
  if (!SWIG_IsOK(errcode))
    SWIG_exception_fail(SWIG_ArgError(errcode), "in method $symname, wrong return value: $type");
}

