import sys

with open(sys.argv[1], 'r') as file1:
    with open(sys.argv[2], 'r') as file2:
        missing = set(file1).difference(file2)

missing.discard('\n')

with open(sys.argv[3], 'w') as file_out:
    for line in missing:
        file_out.write(line)