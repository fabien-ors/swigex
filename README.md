# swigex C++ Library and Wrappers

* Author: Fabien Ors (MINES Paris - PSL University) 
* Date: May 2025

The *swigex* C++ library is a derivative work based on the *swigex0* project: [https://github.com/fabien-ors/swigex0](https://github.com/fabien-ors/swigex0)

*swigex* is an example of a cross-platform C++ library exported in Python and R using CMake and SWIG. **Additional following features** are tested:
* Special classes for handling *vectors* and *numerical vectors* based on std::vector (see VectorT.hpp and VectorNumT.hpp) which permits to:
  * Extend std::vector capabilities (stream, numerical operators,...)
  * Handle *undefined values* of any types
* Use of typemaps for testing *arguments* wrapping (see testArgs):
  * For C++ types: int, double, std::string, Vector\*, VectorVector\*
  * Passed by input value, input reference, input pointers and output pointers
  * Possibly having C++ default values (argument naming is not yet possible in R)
* *Inheritance* in target language (see testPolymorph) (still in development)

* C++ Vector\* class is converted:

|        | from C++    | to C++                   |
|--------|-------------|--------------------------|
| Python | numpy.array | tuple, list, numpy.array |
| R      | vector      | vector, list             |

* C++ VectorVector\* class is converted:

|        | from C++                    | to C++                                               |
|--------|-----------------------------|------------------------------------------------------|
| Python | numpy.array of numpy.arrays | list or numpy.array of tuples, lists or numpy.arrays |
| R      | list of vectors             | list of vectors                                      |

Please, refer to *swigex0* project for more details: [https://github.com/fabien-ors/swigex0](https://github.com/fabien-ors/swigex0)

## Install

### Python Package
From a shell command prompt:

    pip install swigex

For a pre release:

    pip install --pre swigex

### R Package
From an R command prompt:

    install.packages("swigex", repos="https://soft.mines-paristech.fr/cran")

For a prerelease:

    install.packages("swigex", repos="https://soft.mines-paristech.fr/cran/prerelease")

## Usage
This library implements a Fibonacci list C++ object exported to Python and R via SWIG using numerical vector class. Here is an example usage in Python:

    import swigex
    vec = swigex.Fibo(40).get()
    print("vec type is {}".format(type(vec)))


## Install from source

This library has been successfully tested with Ubuntu 20/22/24 LTS, Windows 10 and MacOS.

For installing from source, you must follow instructions from [https://github.com/fabien-ors/swigex0](https://github.com/fabien-ors/swigex0).

## Additional Requirements

The only additional prerequisites are:
* [All users] : *doxygen* 1.8.3 or higher
* [Python users] : *numpy*, *notebook* and *nbconvert* Python packages
* [R users] : *roxygen2*, *knitr* and *callr* R packages

### Linux (Ubuntu)

```
sudo apt install doxygen
python3 -m pip install numpy notebook nbconvert
Rscript -e 'install.packages(c("roxygen2", "knitr", "callr"),repos="https://cloud.r-project.org")'
```

### MacOS

```
brew install doxygen
python3 -m pip install numpy notebook nbconvert
Rscript -e 'install.packages(c("roxygen2", "knitr", "callr"),repos="https://cloud.r-project.org")'
```
  
### Windows - Microsoft Visual Studio

These requirements are also recommended to people who wants to compile *swigex* Python package. If you want to compile *swigex* R package under Windows, you should look at the next section.

#### Install additionnal tools

Download and install the following tool using default options during installation:

1. Doxygen [from here](https://www.doxygen.nl/download.html) (*Binary distribution* [setup.exe] - remind the installation folder, we assume it is `C:\Program Files\doxygen`)
2. Install additional Python modules by running following instructions in a command prompt:

````
python -m pip install numpy notebook nbconvert
````

#### Update the Path environment variable

The *Path* environment variable (*System variables*) must be updated to make *doxygen.exe* available in the batch command line:

1. Follow [this guide](https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10) to add *bin* directory from the *Doxygen* installation folder in the *Path* System variable (i.e: `C:\Program Files\doxygen\bin`)
2. Restart Windows


### Windows - MinGW (via RTools)

These requirements are recommended to people who wants to compile *swigex* R package. If you want to compile *swigex* Python package under Windows, you should look at the previous section. This is not the only way to install MinGW. But using MinGW provided with RTools permits us to also handle *swigex* R package compilation.

* From the *mingw64* shell command prompt, execute following instructions:

````
pacman -Sy mingw-w64-x86_64-doxygen
Rscript -e 'install.packages(c("roxygen2", "knitr", "callr"),repos="https://cloud.r-project.org")'
````

## Generate the Documentation

The Doxygen HTML documentation is optional (not included in the installation by default). If you want to generate it, execute the command:

```
cmake -Bbuild -S. -DBUILD_DOC=ON
cmake --build build --target doxygen
```

or faster (for Makefile user):

```
make doxygen
```

The documentation is then available by opening the following HTML file with your favorite web-browser:

```
firefox build/doxygen/html/index.html
```

## Known caveats

If you experience the following error while importing *swigex* Package under Python:

    RuntimeError: module compiled against API version 0x10 but this version of numpy is 0xe

... you may need to upgrade numpy:

    python -m pip install numpy

* You may need to precise the location of Doxygen installation directory. In that case, add the following variable in the first cmake command (configuration):
  * `-DDoxygen_ROOT="path/to/doxygen"`
---

## License
MIT

2025 Fabien Ors
