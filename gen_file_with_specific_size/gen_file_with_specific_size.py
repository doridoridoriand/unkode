import os
import sys
import logging
import argparse
import random

import pdb
import pprint


def pretty_print(obj):
    pprint.pprint(obj)

def gen_hex():
    rndm = random.randrange(10**160)
    r = "%064x" % rndm
    return r[:128]

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description = 'Generate file with specific size')
    parser.add_argument('-s', '--size',
                        action = 'store',
                        nargs = None,
                        const = None,
                        default = None,
                        type = int,
                        choices = None,
                        help = 'Please input filesize you want.',
                        metavar = None,
                        required = True)
    parser.add_argument('-d', '--directory-path',
                        action = 'store',
                        nargs = None,
                        const = None,
                        default = None,
                        type = str,
                        choices = None,
                        help = 'Please input absolute directory path.',
                        metavar = None,
                        required = True)
    parser.add_argument('-f', '--filename',
                        action = 'store',
                        nargs = None,
                        const = None,
                        default = None,
                        type = str,
                        choices = None,
                        help = 'Please input filename.',
                        metavar = None,
                        required = True)
    arguments = parser.parse_args()
    
    absolute_filepath = "%s/%s.txt" % (arguments.directory_path, arguments.filename)

    # 指定したファイルが既に存在したら例外で終了
    if os.path.exists(absolute_filepath):
        raise Exception('FileAlreadyExistsError')

    # 指定したファイルサイズが保存先のディスクの容量を上回っていれば例外で終了
    stats = os.statvfs(arguments.directory_path)
    available_gigabytes = stats.f_frsize * stats.f_bavail / 1024 / 1024 / 1024
    if available_gigabytes <= arguments.size:
        raise Exception('FilesizeExceedsTargetDriveError')

    fs = open(absolute_filepath, 'w')

    while True:
        try:
            if int(os.path.getsize(absolute_filepath)) >= (arguments.size * 1024 * 1024 * 1024):
                raise Exception('FilesizeReachedError')
            fs.write(gen_hex())
        except Exception as err:
            fs.close()
            sys.exit()

