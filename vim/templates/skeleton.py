#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim: ft=python ts=4 syntax=python

# =====================================
## INFORMATIONS -----------------------
# =====================================
# Author: [:VIM_EVAL:]$FULLNAME[:END_EVAL:]
# Create date: [:VIM_EVAL:]strftime('%Y/%m/%d - %H:%M')[:END_EVAL:]
# Copyright: (C) [:VIM_EVAL:]strftime('%Y')[:END_EVAL:] [:VIM_EVAL:]$COPYRIGHT[:END_EVAL:]
# Describle:
#
#


import argparse
import logging

# =====================================
## LIBRARY ----------------------------
# =====================================
import os
import sys

# PYTHON_ARGCOMPLETE_OK
import argcomplete

# =====================================
## VARIABLES --------------------------
# =====================================

## -- logging level: (DEBUG,INFO,WARNING,ERROR,CRITICAL,NOTSET)
#  LOG_FILENAME = 'example.log'
#  logging.basicConfig(filename=LOG_FILENAME,level=logging.INFO)
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(os.path.basename(__file__))


# =====================================
## CLASS ------------------------------
# =====================================


class test:
    """
    Ma class test trop cool.
    """

    def __init__(self):
        return None

    def __del__(self):
        return True

    def test(self, arg1):
        """
        Methode test

        :param arg1: description
        :param arg2: description
        :type arg1: type
        :type arg1: type
        :return: description de la valeur de retour
        :rtype:	type de la valeur de retour

        :Example:

        Un exemple écrit après un saut de ligne.

        .. seealso:: Référence à une autre partie du code
        .. warnings:: Avertissement
        .. note:: Note
        .. todo:: A faire
        """
        return True


# =====================================
## FUNCTIONS --------------------------
# =====================================


def main(args):
    #  logging.debug('This is a debug message')
    #  logging.info('This is an info message')
    #  logging.warning('This is a warning message')
    #  logging.error('This is an error message')
    #  logging.critical('This is a critical error message')
    return 0


# =====================================
## MAIN -------------------------------
# =====================================

if __name__ == "__main__":
    ## Traitement des arguments:
    parser = argparse.ArgumentParser(description="This is a script of Spartiat AAHHAHAHAHH!")

    parser.add_argument("-d", "--debug", action="store_true", help="Active debug mode.")

    #  parser.add_argument('integers',
    #  metavar='N',
    #  type=int,
    #  nargs='+',
    #  help='an integer for the accumulator')

    #  parser.add_argument('--foo',
    #  nargs='?',
    #  help='foo help')

    #  parser.add_argument('--sum',
    #  dest='accumulate',
    #  action='store_const',
    #  const=sum,
    #  default=max,
    #  help='sum the integers (default: find the max)')

    # Activation de l'autocompletion: eval "$(register-python-argcomplete -s bash my-python-app)"
    # https://kislyuk.github.io/argcomplete/
    argcomplete.autocomplete(parser)

    args = parser.parse_args()

    if args.debug:
        logging.setLevel(logging.DEBUG)

    logger.debug("Arguments: %s" % args)

    ## Main
    r = main(args)

    ## Code retour
    if r or r == 0:
        sys.exit(0)
    sys.exit(1)
