#!/bin/python

import sys
import urllib.request
import re
import os

TL_MIRROR = 'https://www.texlive.info/tlnet-archive/{}/{}/{}/tlnet/'


def github_env(variable, value):
    line = f'{variable}={value}'
    print(line)
    if 'GITHUB_ENV' in os.environ:
        with open(os.environ['GITHUB_ENV'], 'a') as f:
            f.write(line + '\n')


def get_tl_year(mirror):
    listing = urllib.request.urlopen(mirror).read().decode('utf-8')
    matches = re.findall('>TEXLIVE_([\\d]+)<', listing)
    return int(matches[0])


def main():
    date = sys.argv[1]

    year = date[0:4]
    month = date[4:6]
    day = date[6:8]

    mirror = TL_MIRROR.format(year, month, day)

    tl_year = get_tl_year(mirror)

    versions = [f'devel-{tl_year}',  f'devel-{tl_year}-{date}',  f'devel-any-{date}']
    versions = ' '.join(versions)

    github_env('TL_MIRROR', mirror)
    github_env('VERSIONS', versions)


if __name__ == '__main__':
    main()
