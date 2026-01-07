// Keep sync with PYTHON_PACKAGE_NAME in CMakeLists.txt
%module(directors="1") swigex

// Note : Keep order in this file!

// https://stackoverflow.com/a/26035360/3952924
%import "doc/documentation.i"

//////////////////////////////////////////////////////////////
//    Specific typemaps and fragments for Python language   //
//////////////////////////////////////////////////////////////

// Include numpy interface for creating arrays

%{
  #define SWIG_FILE_WITH_INIT
%}
%include numpy.i
%init %{
  // Use a leading '_' to prevent this: https://github.com/numpy/numpy/issues/30122
  _import_array(); // Mandatory for using PyArray_* functions
%}

%begin %{
// For converting NumPy integers to C++ integers
// https://github.com/swig/swig/issues/888
#define SWIG_PYTHON_CAST_MODE
// For isnan
#include <cmath>
// For isinf
#include <math.h>
// For numeric_limits
#include <limits>
// For cout
#include <iostream>

// Look below (python code) for integer NaN (inan definition)
#if defined(_WIN32) || defined(_WIN64)
  #define NPY_INT_TYPE       NPY_INT32
  #define NPY_INT_OUT_TYPE   int
  #define NPY_INT_NA         std::numeric_limits<NPY_INT_OUT_TYPE>::min()
#else // Linux or MacOS
  #define NPY_INT_TYPE       NPY_INT64
  #define NPY_INT_OUT_TYPE   int64_t
  #define NPY_INT_NA         std::numeric_limits<NPY_INT_OUT_TYPE>::min()
#endif

#define NPY_DOUBLE_NA        std::numeric_limits<double>::quiet_NaN()
%}

%fragment("ToCpp", "header")
{
  int isNumericVector(PyObject* obj)
  {
    if (PySequence_Check(obj) || PyArray_CheckExact(obj))
    {
      int size = (int)PySequence_Length(obj);
      for (int i = 0; i < size; ++i)
      {
        PyObject* item = PySequence_GetItem(obj, i);
        if (!PyNumber_Check(item))
          return SWIG_TypeError;
        Py_DECREF(item);
      }
      return SWIG_OK;
    }
    return SWIG_TypeError;
  }
  int isStringVector(PyObject* obj)
  {
    if (PySequence_Check(obj) || PyArray_CheckExact(obj))
    {
      int size = (int)PySequence_Length(obj);
      for (int i = 0; i < size; ++i)
      {
        PyObject* item = PySequence_GetItem(obj, i);
        if (!PyUnicode_Check(item))
          return SWIG_TypeError;
        Py_DECREF(item);
      }
      return SWIG_OK;
    }
    return SWIG_TypeError;
  }

  template <typename Type> int convertToCpp(PyObject* obj, Type& value);
  
  template <> int convertToCpp(PyObject* obj, Id& value)
  {
    // Test argument
    if (obj == NULL) return SWIG_TypeError;

    int myres = SWIG_AsVal_long_SS_long(obj, &value);
    //std::cout << "convertToCpp(int): value=" << value << std::endl;
    if (SWIG_IsOK(myres) || myres == SWIG_OverflowError)
    {
      if (myres == SWIG_OverflowError || value == NPY_INT_NA) // NaN, Inf or out of bound value becomes NA
      {
        value = getNA<Id>();
      }
      myres = SWIG_OK;
    }
    return myres;
  }
  template <> int convertToCpp(PyObject* obj, double& value)
  {
    // Test argument
    if (obj == NULL) return SWIG_TypeError;

    int myres = SWIG_AsVal_double(obj, &value);
    //std::cout << "convertToCpp(double): value=" << value << std::endl;
    if (SWIG_IsOK(myres))
    {
      if (std::isnan(value) || std::isinf(value))
        value = getNA<double>();
    }
    return myres; 
  }
  template <> int convertToCpp(PyObject* obj, String& value)
  {
    // Test argument
    if (obj == NULL) return SWIG_TypeError;
      
    int myres = SWIG_AsVal_std_string(obj, &value);
    //std::cout << "convertToCpp(String): value=" << value << std::endl;
    // No undefined
    return myres;
  }
  
  template <typename Vector>
  int vectorToCpp(PyObject* obj, Vector& vec)
  {
    // Type definitions
    using ValueType = typename Vector::value_type;
    vec.clear();

    // Test argument
    if (obj == NULL) return SWIG_TypeError;

    // Conversion
    int myres = SWIG_OK;
    int size = (int)PySequence_Length(obj);
    if (size < 0)
    {
      // Not a sequence (maybe a single value ?)
      ValueType value;
      // Clear Python error indicator
      PyErr_Restore(NULL, NULL, NULL);
      // Try to convert
      myres = convertToCpp(obj, value);
      if (SWIG_IsOK(myres))
        vec.push_back(value);
    }
    else if (size > 0)
    {
      // Real sequence 
      vec.reserve(size);
      for (int i = 0; i < size && SWIG_IsOK(myres); i++)
      {
        PyObject* item = PySequence_GetItem(obj, i);
        ValueType value;
        myres = convertToCpp(item, value);
        if (SWIG_IsOK(myres))
          vec.push_back(value);
        Py_DECREF(item);
      }
    }
    // else size is zero (empty vector)
    return myres;
  }

  template <typename VectorVector>
  int vectorVectorToCpp(PyObject* obj, VectorVector& vvec)
  {
    // Type definitions
    using InputVector = typename VectorVector::value_type;
    vvec.clear();

    // Test argument
    if (obj == NULL) return SWIG_TypeError;

    // Conversion
    int myres = SWIG_OK;
    int size = (int)PySequence_Length(obj);
    if (size < 0)
    {
      // Not a sequence
      InputVector vec;
      // Clear Python error indicator
      PyErr_Restore(NULL, NULL, NULL);
      // Try to convert
      myres = vectorToCpp(obj, vec);
      if (SWIG_IsOK(myres))
        vvec.push_back(vec);
    }
    else if (size > 0)
    {
      for (int i = 0; i < size && SWIG_IsOK(myres); i++)
      {
        PyObject* item = PySequence_GetItem(obj, i);
        InputVector vec;
        myres = vectorToCpp(item, vec);
        if (SWIG_IsOK(myres))
          vvec.push_back(vec);
        Py_DECREF(item);
      }
    }
    // else size is zero (empty vector)
    return myres;
  }
}

// Add numerical vector typecheck typemaps for dispatching functions
%typemap(typecheck, noblock=1, fragment="ToCpp", precedence=SWIG_TYPECHECK_DOUBLE_ARRAY) const VectorInt&,    VectorInt,
                                                                                         const VectorDouble&, VectorDouble
{
  $1 = SWIG_CheckState(isNumericVector($input));
}

// Add generic vector typecheck typemaps for dispatching functions
%typemap(typecheck, noblock=1, fragment="ToCpp", precedence=SWIG_TYPECHECK_STRING_ARRAY) const VectorString&, VectorString
{
  $1 = SWIG_CheckState(isStringVector($input));
}

%fragment("FromCpp", "header")
{
  template <typename Type> NPY_TYPES numpyType();
  template <> NPY_TYPES numpyType<Id>()     { return NPY_INT_TYPE; }
  template <> NPY_TYPES numpyType<double>() { return NPY_DOUBLE; }
  template <> NPY_TYPES numpyType<String>() { return NPY_STRING; }
  
  template<typename Type> struct TypeHelper;
  template <> struct TypeHelper<Id>     { static bool hasFixedSize() { return true; } };
  template <> struct TypeHelper<double> { static bool hasFixedSize() { return true; } };
  template <> struct TypeHelper<String> { static bool hasFixedSize() { return false; } };
  template <typename Type> bool hasFixedSize() { return TypeHelper<Type>::hasFixedSize(); }
  
  template <typename InputType> struct OutTraits;
  template <> struct OutTraits<Id>      { using OutputType = NPY_INT_OUT_TYPE; };
  template <> struct OutTraits<double>  { using OutputType = double; };
  template <> struct OutTraits<String>  { using OutputType = const char*; };
  
  template <typename Type> typename OutTraits<Type>::OutputType convertFromCpp(const Type& value);
  template <> NPY_INT_OUT_TYPE convertFromCpp(const Id& value)
  {
    //std::cout << "convertFromCpp(int): value=" << value << std::endl;
    NPY_INT_OUT_TYPE vres = static_cast<NPY_INT_OUT_TYPE>(value);
    if (isNA<Id>(value))
      vres = NPY_INT_NA;
    return vres;
  }
  template <> double convertFromCpp(const double& value)
  {
    //std::cout << "convertFromCpp(double): value=" << value << std::endl;
    if (isNA<double>(value))
      return NPY_DOUBLE_NA;
    return value;
  }
  template <> const char* convertFromCpp(const String& value)
  {
    //std::cout << "convertFromCpp(String): value=" << value << std::endl;
    return value.c_str(); // No special conversion provided
  }
  
  template <typename Type> PyObject* objectFromCpp(const Type& value);
  template <> PyObject* objectFromCpp(const Id& value)
  {
    return PyLong_FromLongLong(convertFromCpp(value));
  }
  template <> PyObject* objectFromCpp(const double& value)
  {
    return PyFloat_FromDouble(convertFromCpp(value));
  }
  template <> PyObject* objectFromCpp(const String& value)
  {
    return PyUnicode_FromString(convertFromCpp(value));
  }
  
  template <typename Vector>
  int vectorFromCpp(PyObject** obj, const Vector& vec)
  {
    // Type definitions
    int myres = SWIG_TypeError;
    using SizeType = typename Vector::size_type;
    using InputType = typename Vector::value_type;

    // Conversion
    if (hasFixedSize<InputType>()) // Convert to 1D NumPy array
    {
      using OutputType = typename OutTraits<InputType>::OutputType;
      SizeType size = vec.size();
      npy_intp dims[1] = { (npy_intp)size };
      //*obj = PyArray_SimpleNew(1, dims, numpyType<InputType>());
      PyArray_Descr* descr = PyArray_DescrFromType(numpyType<InputType>());
      *obj = PyArray_NewFromDescr(&PyArray_Type, descr, 1, dims, NULL, NULL, 0, NULL);
      if (*obj != NULL)
      {
        OutputType* array_ptr = (OutputType*) PyArray_DATA((PyArrayObject*)(*obj));
        std::transform(vec.cbegin(), vec.cend(), array_ptr, convertFromCpp<InputType>);
        myres = SWIG_OK;
      }
    }
    else // Convert to a tuple using standard std_vector
    {
      // Test NA values
      auto vec2 = vec.getVector();
      SizeType size = vec2.size();
      for(SizeType i = 0; i < size; i++)
      {
        vec2[i] = convertFromCpp(vec2[i]);
      }
      // Convert to tuple
      *obj = swig::from(vec.getVector());
      myres = (*obj) == NULL ? SWIG_TypeError : SWIG_OK;
    }
    return myres;
  }

  template <typename VectorVector>
  int vectorVectorFromCpp(PyObject** obj, const VectorVector& vec)
  {
    // Type definitions
    int myres = SWIG_TypeError;
    using SizeType = typename VectorVector::size_type;
    using VectorType = typename VectorVector::value_type;
    using InputType = typename VectorType::value_type;
    using OutputType = typename OutTraits<InputType>::OutputType;

    // Check if empty
    if (vec.empty())
    {
      VectorType v; // Create an empty 1D NumPy array
      return vectorFromCpp(obj, v);
    }
    
    // Check the size of sub-vectors
    bool same_size = true;
    SizeType size = vec.at(0).size();
    for(auto v : vec)
    {
      if (same_size)
        same_size = (v.size() == size);
    }
    
    // Conversion
    if (same_size && hasFixedSize<InputType>()) // Convert to a 2D NumPy array
    {
      SizeType size2 = vec.size();
      npy_intp dims[2] = { (npy_intp)size2, (npy_intp)size };
      *obj = PyArray_SimpleNew(2, dims, numpyType<InputType>());
      if (*obj != NULL)
      {
        OutputType* array_ptr = (OutputType*) PyArray_DATA((PyArrayObject*)(*obj));
        for (auto v : vec)
        {
          std::transform(v.cbegin(), v.cend(), array_ptr, convertFromCpp<InputType>);
          array_ptr += size;
        }
        myres = SWIG_OK;
      }
    }
    else // Convert to a list of 1D NumPy array (fixed item size) or tuple (no item size)
    {
      // https://stackoverflow.com/questions/36050713/using-py-buildvalue-to-create-a-list-of-tuples-in-c
      *obj = PyList_New(0);
      if(*obj != NULL)
      {
        myres = SWIG_OK;
        SizeType size2 = vec.size();
        for(SizeType i = 0; i < size2 && SWIG_IsOK(myres); i++)
        {
          PyObject* tuple;
          myres = vectorFromCpp(&tuple, vec.at(i));
          if (SWIG_IsOK(myres))
            myres = PyList_Append(*obj, tuple);
        }
      }
    }
    
    return myres;
  }
}

//////////////////////////////////////////////////////////////
//         C++ library SWIG includes and typemaps           //
//////////////////////////////////////////////////////////////

%include ../swig/swig_inc.i

//////////////////////////////////////////////////////////////
//                C++ library SWIG interface                //
//////////////////////////////////////////////////////////////

%include ../swig/swig_exp.i

//////////////////////////////////////////////////////////////
//                    Add C++ extension                     //
//////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////
//       Add target language additional features below      //
//////////////////////////////////////////////////////////////

%pythoncode %{

import swigex as se
import numpy as np
import sys

## Version and authors
from swigex.version import __version__
from swigex.version import __author__

## Numpy default integer type could be different according the OS (int64 or int32)
## https://stackoverflow.com/questions/36278590/numpy-array-dtype-is-coming-as-int32-by-default-in-a-windows-10-64-bit-machine
## Remind that there is no standard NaN for integers in Python
## We cannot use std::numeric_limits<int>::quiet_NaN() in C++
## But we can use the minimum signed integer value as follow

import os
## Integer NaN custom value
if os.name == 'nt':         # Windows
  inan = -2147483648
else:                       # Others
  inan = -sys.maxsize - 1

## isNaN custom function
def isNaN(value):
  if (type(value).__module__ == np.__name__): # Numpy type
    if (np.dtype(value) == 'intc' or np.dtype(value) == 'int64' or np.dtype(value) == 'int32'):
      return value == se.inan
  else:
    if (type(value).__name__ == 'int'):
      return value == se.inan
  return np.isnan(value)


## Add operator [] to VectorXXX class [0-based index] ##
## -------------------------------------------------- ##

def setitem(self, idx, item):
  if idx < 0 or idx >= self.length():
    raise IndexError("Index out or range")
  self.setAt(idx,item)
  
def getitem(self, idx):
  if idx < 0 or idx >= self.length():
    raise IndexError("Index out or range")
  return self.getAt(idx)

setattr(se.VectorDouble,       "__getitem__", getitem)
setattr(se.VectorDouble,       "__setitem__", setitem)
setattr(se.VectorInt,          "__getitem__", getitem)
setattr(se.VectorInt,          "__setitem__", setitem)
setattr(se.VectorString,       "__getitem__", getitem)
setattr(se.VectorString,       "__setitem__", setitem)
setattr(se.VectorVectorDouble, "__getitem__", getitem)
setattr(se.VectorVectorDouble, "__setitem__", setitem)
setattr(se.VectorVectorInt,    "__getitem__", getitem)
setattr(se.VectorVectorInt,    "__setitem__", setitem)
%}
