import sys

f = open(sys.argv[1], "r")
size = 0
for i in f:
    size += int(i) 
if (size*1048576) < int(sys.argv[2]):
    print(0)
else:
    print(0)