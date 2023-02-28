import sys
from functions.function_01 import hello
from functions.function_02 import bye
from functions.function_03 import data


def main(args):
    print(args)
    hello()
    bye()
    data()


if __name__ == '__main__':
    main(sys.argv[1:])
