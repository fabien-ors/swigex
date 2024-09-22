#include "swigex_export.hpp"
#include <string>
#include <memory>
#include <iostream>

class SWIGEX_EXPORT File
{
  public:
  File(int a = 0,const std::string& name=""): _a(a),_name(name){}
  void setA(int a) {_a = a; }
  void display() const;
  virtual ~File() {std::cout << "destruction of "<< _name <<std::endl;};
  private:
  int _a;
  
  std::string _name;

};

class SWIGEX_EXPORT Folder
{
  public:
  Folder(const File &file, 
         File* pfile, 
         const File* cpfile, 
         File* const pcfile, 
         const File* const cpcfile)
  :_file(file)
  ,_pFile(pfile)
  ,_cpFile(cpfile)
  ,_pcFile(pcfile)
  ,_cpcFile(cpcfile)
  {};

  virtual ~Folder(){};
  void display() const
  {
    _file.display();
    _pFile->display();  
    _cpFile->display();
    _pcFile->display();
    _cpcFile->display();
  }
  static File* createFile(int a, const std::string &name = "name"){return new File(a,name);}
  static std::shared_ptr<File> createShFile(int a, const std::string &name = "name")
                               {
                                return std::shared_ptr<File>(new File(a,name));
                               }
  
  private:
  File  _file;
  File* _pFile;
  const File* _cpFile;
  File* const _pcFile;
  const File* const _cpcFile;

};