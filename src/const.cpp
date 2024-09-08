#include "const.hpp"
#include <iostream>
void File::display() const
{
    std::cout << _name << " " << _a << std::endl;
}
