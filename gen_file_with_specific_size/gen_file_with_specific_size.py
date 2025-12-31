#!/usr/bin/env python
# coding: UTF-8

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

def gen_hex_chunk(size_bytes):
    """Generate a large chunk of hex data at once for better performance.
    
    Args:
        size_bytes: Size in bytes to generate (as hex characters)
    
    Returns:
        String of hex characters
    """
    # Each byte needs 2 hex characters, so we need size_bytes/2 random bytes
    num_random_bytes = (size_bytes + 1) // 2  # Round up for odd sizes
    # Generate random bytes more efficiently
    random_bytes = random.getrandbits(num_random_bytes * 8).to_bytes(num_random_bytes, byteorder='big')
    hex_str = random_bytes.hex()
    # Return exact size needed
    return hex_str[:size_bytes]

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

    target_size_bytes = arguments.size * 1024 * 1024 * 1024
    chunk_size_bytes = 10 * 1024 * 1024  # Write 10MB chunks at a time for better performance
    
    with open(absolute_filepath, 'w', buffering=8*1024*1024) as fs:  # 8MB buffer
        bytes_written = 0
        
        while bytes_written < target_size_bytes:
            # Calculate remaining size to avoid overshooting
            remaining_bytes = target_size_bytes - bytes_written
            
            # Determine how much to write this iteration
            write_size = min(chunk_size_bytes, remaining_bytes)
            
            # Generate and write hex data
            chunk = gen_hex_chunk(write_size)
            fs.write(chunk)
            bytes_written += len(chunk)
    
    sys.exit(0)

