import swigex
import numpy as np

a = swigex.TypeClass()
i = a.testInt(12)
print(type(i))
if (i != 12) :
  print("Wrong int!")
i = a.testIntRef(22)
print(type(i))
if (i != 22) :
  print("Wrong int Reference!")
i = a.testIntPtr(32)
print(type(i))
if (i != 32) :
  print("Wrong int Pointer!")
i = 5
a.testIntRefOut(i)
print(type(i))
#if (i != 32) : # TODO : Output argument for scalar not supported (i still equal to 5)
#  print("Wrong int Reference Out!")
a.testIntRefDef()
a.testIntRefDef(3)
a.testIntRefDef(b=5)
a.testIntRefDef(b=np.nan)

vi = a.testVectorInt(np.array((23,33,43)))
print(type(vi))
if (vi[0] != 23 or vi[1] != 33 or vi[2] != 43) :
  print("Wrong VectorInt!")
vi = np.atleast_2d(vi).T  # Convert to 2D 1-column array
vi = a.testVectorInt(vi)
if (vi[0] != 23 or vi[1] != 33 or vi[2] != 43) :
  print("Wrong VectorInt as column!")
vi = a.testVectorIntRef([24,34,44]) # From list
vi = a.testVectorIntRef(vi) # From a numpy array returned by the C++ library
print(type(vi))
if (vi[0] != 24 or vi[1] != 34 or vi[2] != 44) :
  print("Wrong VectorInt Reference!")
vi = a.testVectorIntPtr((25,35,45)) # From tuple
print(type(vi))
if (vi[0] != 25 or vi[1] != 35 or vi[2] != 45) :
  print("Wrong VectorInt Pointer!")
#vi = swigex.VectorInt([26,36]) # TODO : this constructor doesn't work yet
vi = swigex.VectorInt()
vi.push_back(26)
vi.push_back(36)
a.testVectorInt(vi) # Test true vector by value
a.testVectorIntRef(vi) # Test true vector by reference
a.testVectorIntPtr(vi) # Test true vector by pointer
vi.clear()
a.testVectorIntRefOut(vi) # Output argument
print(type(vi))
if (vi[0] != 26 or vi[1] != 36) :
  print("Wrong VectorInt Reference Out!")
a.testVectorIntRefDef()
a.testVectorIntRefDef(np.array([]))
a.testVectorIntRefDef([])
a.testVectorIntRefDef(())
a.testVectorIntRefDef((3))
a.testVectorIntRefDef(b=10)
a.testVectorIntRefDef(b=[10,np.nan])

vvi = a.testVVectorInt(np.array([[23,33,43],[53,63,73],[83,93,103]])) # From numpy.array
print(type(vvi))
if (vvi[0][0] != 23 or vvi[0][1] != 33 or vvi[0][2] != 43 or
    vvi[1][0] != 53 or vvi[1][1] != 63 or vvi[1][2] != 73 or
    vvi[2][0] != 83 or vvi[2][1] != 93 or vvi[2][2] != 103) :
  print("Wrong VectorVectorInt!")
vvi = a.testVVectorIntRef([[24,34,44],[54,64,74],[74,84,94]]) # From list
vvi = a.testVVectorIntRef(vvi) # From a numpy array returned by the C++ library
print(type(vvi))
if (vvi[0][0] != 24 or vvi[0][1] != 34 or vvi[0][2] != 44 or
    vvi[1][0] != 54 or vvi[1][1] != 64 or vvi[1][2] != 74 or
    vvi[2][0] != 74 or vvi[2][1] != 84 or vvi[2][2] != 94) :
  print("Wrong VectorVectorInt Reference!")
vvi = a.testVVectorIntPtr(((25,35,45),(55,65,75),(85,95,105))) # From tuple
print(type(vvi))
if (vvi[0][0] != 25 or vvi[0][1] != 35 or vvi[0][2] != 45 or
    vvi[1][0] != 55 or vvi[1][1] != 65 or vvi[1][2] != 75 or
    vvi[2][0] != 85 or vvi[2][1] != 95 or vvi[2][2] != 105) :
  print("Wrong VectorVectorInt Pointer!")
#vvi = swigex.VectorVectorInt([[26,36],[56,66]]) # TODO : This constructor doesn't work yet
vvi = swigex.VectorVectorInt()
vvi.push_back(swigex.VectorInt([26,36])) # TODO : push_back requires real Vectors only
vvi.push_back(swigex.VectorInt([56,66])) # TODO : push_back requires real Vectors only
a.testVVectorInt(vvi) # Test true vector of vectors by value
a.testVVectorIntRef(vvi) # Test true vector of vectors by reference
a.testVVectorIntPtr(vvi) # Test true vector of vectors by pointer
vvi.clear()
a.testVVectorIntRefOut(vvi) # Output argument
print(type(vvi))
if (vvi[0][0] != 26 or vvi[0][1] != 36 or
    vvi[1][0] != 56 or vvi[1][1] != 66) :
  print("Wrong VectorVectorInt Reference Out!")
vvi.clear()
vvi.push_back(swigex.VectorInt([100,101,102]))
vvi = a.testVVectorInt(vvi)
vvi = a.testVVectorInt([[100,101,102]])
a.testVVectorIntRefDef()
a.testVVectorIntRefDef((3))
a.testVVectorIntRefDef(np.array([]))
a.testVVectorIntRefDef([])
a.testVVectorIntRefDef(())
a.testVVectorIntRefDef([3,4])
a.testVVectorIntRefDef([(3)])
a.testVVectorIntRefDef([()])
a.testVVectorIntRefDef([(6,7),(8,9)])
a.testVVectorIntRefDef(b=10)
a.testVVectorIntRefDef(b=[(10,np.nan)])

d = a.testDouble(12.1)
print(type(d))
if (d != 12.1) :
  print("Wrong double!")
d = a.testDoubleRef(22.2)
print(type(d))
if (d != 22.2) :
  print("Wrong double Reference!")
d = a.testDoublePtr(32.3) # TODO : Pointer scalar argument not yet possible
print(type(d))
if (d != 32.3) :
  print("Wrong double Pointer!")
d = 5.0
a.testDoubleRefOut(d)
print(type(d))
#if (d != 22.2) : # TODO : Output argument for scalar not supported (d still equal to 5.0)
#  print("Wrong double Reference Out!")
a.testDoubleRefDef()
a.testDoubleRefDef(3.1)
a.testDoubleRefDef(b=5.1)
a.testDoubleRefDef(b=np.nan)

vd = a.testVectorDouble([23.1,33.1,43.1]) # From list
print(type(vd))
if (vd[0] != 23.1 or vd[1] != 33.1 or vd[2] != 43.1) :
  print("Wrong VectorDouble!")
vd = np.atleast_2d(vd).T  # Convert to 2D 1-column array
vd = a.testVectorDouble(vd)
if (vd[0] != 23.1 or vd[1] != 33.1 or vd[2] != 43.1) :
  print("Wrong VectorDouble as column!")
vd = a.testVectorDoubleRef(np.array([24.2,34.2,44.2])) # From numpy.array
vd = a.testVectorDoubleRef(vd) # From numpy.array returned by the C++ library
print(type(vd))
if (vd[0] != 24.2 or vd[1] != 34.2 or vd[2] != 44.2) :
  print("Wrong VectorDouble Reference!")
vd = a.testVectorDoublePtr((25.3,35.3,45.3)) # From tuple
print(type(vd))
if (vd[0] != 25.3 or vd[1] != 35.3 or vd[2] != 45.3) :
  print("Wrong VectorDouble Pointer!")
# vd = swigex.VectorDouble([26.3,36.3]) # TODO : This constructor doesn't work yet
vd = swigex.VectorDouble()
vd.push_back(26.3)
vd.push_back(36.3)
a.testVectorDouble(vd) # Test true vector by value
a.testVectorDoubleRef(vd) # Test true vector by reference
a.testVectorDoublePtr(vd) # Test true vector by pointer
vd.clear()
a.testVectorDoubleRefOut(vd) # Output argument
print(type(vd))
if (vd[0] != 26.3 or vd[1] != 36.3) :
  print("Wrong VectorDouble Reference Out!")
a.testVectorDoubleRefDef()
a.testVectorDoubleRefDef(np.array([]))
a.testVectorDoubleRefDef([])
a.testVectorDoubleRefDef(())
a.testVectorDoubleRefDef((3.1))
a.testVectorDoubleRefDef(b=10.1)
a.testVectorDoubleRefDef(b=(10.1,np.nan))

vvd = a.testVVectorDouble(np.array([[23.1,33.1,43.1],[53.1,63.1,73.1],[83.1,93.1,103.1]]))  # From numpy.array
print(type(vvd))
if (vvd[0][0] != 23.1 or vvd[0][1] != 33.1 or vvd[0][2] != 43.1 or
    vvd[1][0] != 53.1 or vvd[1][1] != 63.1 or vvd[1][2] != 73.1 or
    vvd[2][0] != 83.1 or vvd[2][1] != 93.1 or vvd[2][2] != 103.1) :
  print("Wrong VectorVectorDouble!")
vvd = a.testVVectorDoubleRef([[24.2,34.2,44.2],[54.2,64.2,74.2],[74.2,84.2,94.2]]) # From list
vvd = a.testVVectorDoubleRef(vvd) # From numpy.array returned by the C++ library
print(type(vvd))
if (vvd[0][0] != 24.2 or vvd[0][1] != 34.2 or vvd[0][2] != 44.2 or
    vvd[1][0] != 54.2 or vvd[1][1] != 64.2 or vvd[1][2] != 74.2 or
    vvd[2][0] != 74.2 or vvd[2][1] != 84.2 or vvd[2][2] != 94.2) :
  print("Wrong VectorVectorDouble Reference!")
vvd = a.testVVectorDoublePtr(((25.3,35.3,45.3),(55.3,65.3,75.3),(85.3,95.3,105.3))) # From tuple 
print(type(vvd))
if (vvd[0][0] != 25.3 or vvd[0][1] != 35.3 or vvd[0][2] != 45.3 or
    vvd[1][0] != 55.3 or vvd[1][1] != 65.3 or vvd[1][2] != 75.3  or
    vvd[2][0] != 85.3 or vvd[2][1] != 95.3 or vvd[2][2] != 105.3) :
  print("Wrong VectorVectorDouble Pointer!")
#vvd = swigex.VectorVectorDouble([[26.3,36.3],[56.3,66.3]]) # TODO : This constructor doesn't work yet
vvd = swigex.VectorVectorDouble()
vvd.push_back(swigex.VectorDouble([26.3,36.3])) # TODO : push_back requires real Vectors only
vvd.push_back(swigex.VectorDouble([56.3,66.3])) # TODO : push_back requires real Vectors only
a.testVVectorDouble(vvd) # Test true vector of vectors by value
a.testVVectorDoubleRef(vvd) # Test true vector of vectors by reference
a.testVVectorDoublePtr(vvd) # Test true vector of vectors by pointer
vvd.clear()
a.testVVectorDoubleRefOut(vvd) # Output argument
print(type(vvd))
if (vvd[0][0] != 26.3 or vvd[0][1] != 36.3 or
    vvd[1][0] != 56.3 or vvd[1][1] != 66.3) :
  print("Wrong VectorVectorDouble Reference Out!")
a.testVVectorDoubleRefDef()
a.testVVectorDoubleRefDef((3.1))
a.testVVectorDoubleRefDef(np.array([]))
a.testVVectorDoubleRefDef([])
a.testVVectorDoubleRefDef(())
a.testVVectorDoubleRefDef([3.1,4.1])
a.testVVectorDoubleRefDef([(3.1)])
a.testVVectorDoubleRefDef([()])
a.testVVectorDoubleRefDef([(6.1,7.1),(8.1,9.1)])
a.testVVectorDoubleRefDef(b=10.1)
a.testVVectorDoubleRefDef(b=[(10.1, np.nan)])

s = a.testString("Str12")
print(type(s))
if (s != "Str12") :
  print("Wrong String!")
s = a.testStringRef("Str22")
print(type(s))
if (s != "Str22") :
  print("Wrong String Reference!")
#s = a.testStringPtr("Str32") # TODO : Pointer scalar argument not yet possible
#print(type(s))
#if (s != "Str32") :
#  print("Wrong String Pointer!")
#s = "SSS"
#a.testStringRefOut(s) # TODO : Output argument for scalar not supported
#print(type(s))
#if (s != "Str22") :
#  print("Wrong String Reference Out!")
a.testStringRefDef()
a.testStringRefDef("Str3")
a.testStringRefDef(b="Str5")
a.testStringRefDef(b="")

vs = a.testVectorString(np.array(("Str23","Str33","Str43"))) # From numpy.array
print(type(vs))
if (vs[0] != 'Str23' or vs[1] != 'Str33' or vs[2] != 'Str43') :
  print("Wrong VectorString!")
vs = np.atleast_2d(vs).T  # Convert to 2D 1-column array
vs = a.testVectorString(vs)
if (vs[0] != 'Str23' or vs[1] != 'Str33' or vs[2] != 'Str43') :
  print("Wrong VectorString as column!")
vs = a.testVectorStringRef(["Str24","Str34","Str44"]) # From list
vs = a.testVectorStringRef(vs) # From numpy.array returned by the C++ library
print(type(vs))
if (vs[0] != 'Str24' or vs[1] != 'Str34' or vs[2] != 'Str44') :
  print("Wrong VectorString Reference!")
vs = a.testVectorStringPtr(("Str25","Str35","Str45")) # From tuple
print(type(vs))
if (vs[0] != 'Str25' or vs[1] != 'Str35' or vs[2] != 'Str45') :
  print("Wrong VectorString Pointer!")
vs = swigex.VectorString(['Str26', 'Str36'])
a.testVectorString(vs) # Test true vector by value
a.testVectorStringRef(vs) # Test true vector by reference
a.testVectorStringRef(vs) # Test true vector by pointer
vs.clear()
a.testVectorStringRefOut(vs) # Output argument
print(type(vs))
if (vs[0] != 'Str26' or vs[1] != 'Str36') :
  print("Wrong VectorString Reference Out!")
a.testVectorStringRefDef()
a.testVectorStringRefDef(np.array([]))
a.testVectorStringRefDef([])
a.testVectorStringRefDef(())
a.testVectorStringRefDef(["Str3"])
a.testVectorStringRefDef(b="Str5")
a.testVectorStringRefDef(b=[""])
# No VectorVectorString (doesn't exist in the C++ library)

# Test NA values
#print(a.testDouble(None)) # None is forbidden
print(a.testDouble(np.nan)) # equivalent to float('nan')
print(a.testDouble(np.inf))
print(a.testDouble(2e505)) # Overflow becomes NA
print(a.testVectorDouble(np.array((1.2, np.nan, 3.3))))

# Cannot print NA for int as it is different between platforms (use isNaN from swigex)
#print(a.testInt(None)) # None is forbidden
print("nan") if (swigex.isNaN(a.testInt(np.nan))) else print("oups") # This works even for integers
print("nan") if (swigex.isNaN(a.testInt(swigex.inan))) else print("oups") # Custom value for Python integer NaN
print("nan") if (swigex.isNaN(a.testInt(np.inf))) else print("oups")
print("nan") if (swigex.isNaN(a.testInt(1111111111111111111111111111111111111))) else print("oups") # Overflow becomes NA
print("[nan]") if (swigex.isNaN(a.testVectorInt(swigex.inan)[0])) else print("oups")

# Test special vectors
a.testVectorInt(()) # Empty vector
a.testVectorInt(101) # Single value
a.testVectorInt((102,)) # Vector with 1 item
a.testVectorDouble(()) # Empty vector
a.testVectorDouble(201.1) # Single value
a.testVectorDouble((202.1,)) # Vector with 1 item
a.testVectorString(()) # Empty vector
a.testVectorString('Str301') # Single value             # TODO : Will never work: String is decomposed in a vector of one character items. Use ['xxx'] or ('xxx',)
a.testVectorString(("Str302",)) # Vector with 1 item     
a.testVVectorInt(()) # Empty vector
a.testVVectorInt(101) # Single value
a.testVVectorInt(((102,),)) # Only 1 vector with 1 item
a.testVVectorInt(((103, 104),)) # Only 1 vector with 2 items
a.testVVectorInt([[103, 104]]) # Should give same results
a.testVVectorDouble((())) # Empty vector
a.testVVectorDouble(201.1) # Single value
a.testVVectorDouble(((202.1,),)) # Only 1 vector with 1 item
a.testVVectorDouble(((203.1, 204.1),)) # Only 1 vector with 2 items
a.testVVectorDouble([[203.1, 204.1]]) # Should give same result
# No VectorVectorString (doesn't exist in the C++ library)

a.testIntOverload(12) # TODO : Behavior different from R
a.testIntOverload((12))
a.testIntOverload((13, 14))
a.testIntOverload([15, 16])
a.testIntOverload(np.array([17, 18]))

a.testDoubleOverload(12.1) # TODO : Behavior different from R
a.testDoubleOverload((12.1))
a.testDoubleOverload((13.1, 14.1))
a.testDoubleOverload([15.1, 16.1])
a.testDoubleOverload(np.array([17.1, 18.1]))

a.testStringOverload("Str12.1") # TODO : Behavior different from R
a.testStringOverload(("Str12.1"))
a.testStringOverload(("Str13.1", "Str14.1"))
a.testStringOverload(["Str15.1", "Str16.1"])
a.testStringOverload(np.array(["Str17.1", "Str18.1"]))