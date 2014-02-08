#!/usr/bin/python2.7

# requirements: python2.7, python-ipcalc

from ipcalc import Network
from socket import gethostbyaddr, herror
from argparse import ArgumentParser, RawDescriptionHelpFormatter

a_desc = '''Reverse hostname scanner - revhost.py'''

parser = ArgumentParser(description=a_desc,formatter_class=RawDescriptionHelpFormatter)
parser.add_argument('target', help='IPv4/IPv6 address or CIDR')
parser.add_argument('-v', '--verbose', help='enables verbosity', action='store_true')
args = parser.parse_args()

try:
    for ipaddr in Network(args.target):
        try:
            attr = gethostbyaddr(str(ipaddr))
            print "%s resolves to: \033[92m%s\033[0m" % (ipaddr, attr[0])
        except herror as e:
            if args.verbose:
                print "%s \033[91m(unknown host)\033[0m" % (ipaddr)
except ValueError:
    print "Wrong arguments. Please enter only IPv4/6 addresses and CIDR."

except KeyboardInterrupt:
    print "\nScan terminated by user."
