import swigex as sw

file = sw.File(1,"obj")
pfile = sw.File(2,"p")
cpfile = sw.File(3,"cp")
pcfile = sw.File(4,"pc")
cpcfile = sw.File(5,"cpc")
shfile = sw.constFile()

folder = sw.Folder(file,pfile,cpfile,pcfile,cpcfile,shfile)
folder.display()

file.setA(-1)
pfile.setA(-1)
cpfile.setA(-1)
pcfile.setA(-1)
cpcfile.setA(-1)
shfile.setA(-1)


folder.display()
