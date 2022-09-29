#pragma once

#include "swigex_export.hpp"
#include "swigex_define.hpp"

#include "VectorT.hpp"
#include "VectorNumT.hpp"


class SWIGEX_EXPORT TypeClass
{
public:
  TypeClass();
  ~TypeClass();
//                                                                                     //   R         Python

  int testInt(int a);                                                                  //   OK        OK
  const int& testIntRef(const int& a);                                                 //   OK        OK
  const int* testIntPtr(const int* a);                                                 //   ## NOK    OK
  void testIntRefOut(int& a) const;                                                    //   ## NOK    ## NOK
  void testIntRefDef(const int& a = 2, const int& b = 3);                              //   OK        OK

  VectorInt testVectorInt(VectorInt a);                                                //   OK        OK
  const VectorInt& testVectorIntRef(const VectorInt& a);                               //   OK        OK
  const VectorInt* testVectorIntPtr(const VectorInt* a);                               //   OK        OK
  void testVectorIntRefOut(VectorInt& a) const;                                        //   OK        OK
  void testVectorIntRefDef(const VectorInt& a = VectorInt({2,3}),                      //   OK        OK
                           const VectorInt& b = VectorInt({4,5}));

  VectorVectorInt testVVectorInt(VectorVectorInt a);                                   //   OK        OK
  const VectorVectorInt& testVVectorIntRef(const VectorVectorInt& a);                  //   OK        OK
  const VectorVectorInt* testVVectorIntPtr(const VectorVectorInt* a);                  //   OK        OK
  void testVVectorIntRefOut(VectorVectorInt& a) const;                                 //   OK        OK
  void testVVectorIntRefDef(const VectorVectorInt& a =                                 //   OK        OK
                                  VectorVectorInt({{4,5},{6,7}}),
                            const VectorVectorInt& b =
                                  VectorVectorInt({{8,9},{10,11}}));

  double testDouble(double a);                                                         //   OK        OK
  const double& testDoubleRef(const double& a);                                        //   OK        OK
  const double* testDoublePtr(const double* a);                                        //   ## NOK    OK
  void testDoubleRefOut(double& a) const;                                              //   ## NOK    ## NOK
  void testDoubleRefDef(const double& a = 2.0, const double& b = 3.0);                 //   OK        OK

  VectorDouble testVectorDouble(VectorDouble a);                                       //   OK        OK
  const VectorDouble& testVectorDoubleRef(const VectorDouble& a);                      //   OK        OK
  const VectorDouble* testVectorDoublePtr(const VectorDouble* a);                      //   OK        OK
  void testVectorDoubleRefOut(VectorDouble& a) const;                                  //   OK        OK
  void testVectorDoubleRefDef(const VectorDouble& a = VectorDouble({2.1,3.1}),         //   OK        OK
                              const VectorDouble& b = VectorDouble({4.1,5.1}));

  VectorVectorDouble testVVectorDouble(VectorVectorDouble a);                          //   OK        OK
  const VectorVectorDouble& testVVectorDoubleRef(const VectorVectorDouble& a);         //   OK        OK
  const VectorVectorDouble* testVVectorDoublePtr(const VectorVectorDouble* a);         //   OK        OK
  void testVVectorDoubleRefOut(VectorVectorDouble& a) const;                           //   OK        OK
  void testVVectorDoubleRefDef(const VectorVectorDouble& a =                           //   OK        OK
                                     VectorVectorDouble({{4.1,5.1},{6.1,7.1}}),
                               const VectorVectorDouble& b =
                                     VectorVectorDouble({{8.1,9.1},{10.1,11.1}}));

  String testString(String a);                                                         //   OK        OK
  const String& testStringRef(const String& a);                                        //   OK        OK
  const String*testStringPtr(const String* a);                                         //   ## NOK    ## NOK
  void testStringRefOut(String& a) const;                                              //   ## NOK    ## NOK
  void testStringRefDef(const String& a = "Str2", const String& b = "Str3");           //   OK        OK

  VectorString testVectorString(VectorString a);                                       //   OK        OK
  const VectorString& testVectorStringRef(const VectorString& a);                      //   OK        OK
  const VectorString* testVectorStringPtr(const VectorString* a);                      //   OK        OK
  void testVectorStringRefOut(VectorString& a) const;                                  //   OK        OK
  void testVectorStringRefDef(const VectorString& a =                                  //   OK        OK
                                    VectorString({"Str4","Str5"}),
                              const VectorString& b =
                                    VectorString({"Str6","Str7"}));

  void testIntOverload(int a) const;                                                   //   OK        OK
  void testIntOverload(const VectorInt& a) const;                                      //   OK        OK
  void testDoubleOverload(double a) const;                                             //   OK        OK
  void testDoubleOverload(const VectorDouble& a) const;                                //   OK        OK
  void testStringOverload(String a) const;                                             //   OK        OK
  void testStringOverload(const VectorString& a) const;                                //   OK        OK

private:
  int                _varInt;
  double             _varDouble;
  String             _varString;
  VectorInt          _varVectorInt;
  VectorVectorInt    _varVVectorInt;
  VectorDouble       _varVectorDouble;
  VectorVectorDouble _varVVectorDouble;
  VectorString       _varVectorString;
};
