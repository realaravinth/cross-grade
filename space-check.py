import sys

options = [  
    "sum",
    "space-check"
]

size = 0

if str(sys.argv[1]) == options[0]:
    f = open(sys.argv[2], "r")
    for i in f:
        size += int(i) 
    print(size)

if str(sys.argv[1]) == options[1]:
    if int(sys.argv[2])*1048576 < int(sys.argv[3]):
        print(1)
    else:
        print(0)