#pragma once

#include "swigex_export.hpp"
#include "swigex_define.hpp"

/**
 * Parent base class for testing polymorphism in target language
 */
class SWIGEX_EXPORT ICloneable
{
  public:
  ICloneable() {};
  virtual ~ICloneable() {};

  //virtual ICloneable* clone() const = 0;
};

/**
 * Base class for testing polymorphism in target language
 */
class SWIGEX_EXPORT AParent : public ICloneable
{
  public:
    AParent() {};
    virtual ~AParent() {};

    virtual String getHello() const { return "Hello"; }

    // This class AParent is still pure abstract
    // ICloneable* clone() const override { return new AParent(); }
};

/**
 * Concrete class for testing polymorphism in target language
 */
class SWIGEX_EXPORT ChildOne : public AParent
{
  public:
    ChildOne() {};
    virtual ~ChildOne() {};

    String getHello() const override { return "ChildOne - Hello"; }

    // ChildOne* clone() const override { return new ChildOne(); } // Override clone even if the return type is different
};

/// Global function for testing polymorphism
SWIGEX_EXPORT void showHello(const AParent* parent);


