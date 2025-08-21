#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
sys.dont_write_bytecode = True

import os
import venv
import subprocess
import argparse

DEFAULT_ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__))).replace('\\', '/')


def parse_arguments():
    parser = argparse.ArgumentParser(description='Initializes and configures the Babylon environment')
    parser.add_argument('--rootdir', default=f'{DEFAULT_ROOT_DIR}', help=f'Project root directory (default: {DEFAULT_ROOT_DIR})')
    return parser.parse_known_args()


def create_venv(args):
    venv_dir = os.path.join(os.path.normpath(args.rootdir), ".venv").replace('\\', '/')
    if not os.path.isdir(venv_dir):
        print(f'Creating venv: {venv_dir}')
        venv.EnvBuilder(with_pip=True, clear=False, upgrade=False, symlinks=True).create(venv_dir)

    if os.name == 'nt':
        vpython = os.path.join(venv_dir, 'Scripts', 'python.exe').replace('\\', '/')
    else:
        vpython = os.path.join(venv_dir, 'bin', 'python').replace('\\', '/')

    subprocess.check_call([vpython, '-m', 'pip', 'install', '--upgrade', 'pip', 'wheel', 'setuptools'])
    subprocess.check_call([vpython, '-m', 'pip', 'install', 'meson', 'ninja', 'meson-python'])


def main():
    args, extra_args = parse_arguments()
    create_venv(args)


if __name__ == '__main__':
    try:
        main()
    except subprocess.CalledProcessError as e:
        sys.exit(e.returncode)
