#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vim: ts=4 syntax=python


# =====================================
## INFORMATIONS -----------------------
# =====================================
# Author: Henry Stéphane
# Create date: 2017/01/23 - 23:16
# Copyright: (C) 2017 Stéphane Henry
# Describle:
#


# =====================================
## LIBRARY ----------------------------
# =====================================
import argparse
import fnmatch
import logging
import operator
import os
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor

import argcomplete  # PYTHON_ARGCOMPLETE_OK
from prettytable.colortable import ColorTable, Theme
from termcolor import colored

# =====================================
## VARIABLES --------------------------
# =====================================
FORMAT = "%(asctime)-15s | %(levelname)s | %(message)s"
logging.basicConfig(format=FORMAT, level=logging.INFO)
logger = logging.getLogger()
C_RED = "\033[1;31m"
C_CYAN = "\033[1;36m"
C_BLUE = "\033[1;34m"
C_GREEN = "\033[1;32m"
C_YELLOW = "\033[1;33m"
C_PURPLE = "\033[1;35m"
C_GRAY = "\033[1;90m"
C_END = "\033[0m"


# =====================================
## CLASS ------------------------------
# =====================================


class Chkout(object):
    """
    Ma class test trop cool.
    """

    def __init__(self, typeCvs, path):
        self.statusCode = 0
        self.statusRemoteCode = 0
        self.msg = []
        self.path = path
        self.type = typeCvs
        userHome = os.path.expanduser("~")
        self._cPath = path.replace(userHome, "~", 1)  # Cache cPath
        self.data = {
            "IN": 0,
            "OUT": 0,
            "A": 0,
            "M": 0,
            "D": 0,
            # Pour svn; E = '!': 0,
            "E": 0,
            "~": 0,
            # Pour svn; U = '?': 0
            "U": 0,
            # Pour svn conflit
            "C": 0,
        }
        return None

    def __del__(self):
        return True

    def __getattr__(self, name):
        if name == "cPath":
            return self._cPath
        else:
            v = self.data[name]
        return v

    def color(self, name):
        v = self.data[name]

        if not str(v).isdigit():
            if v == "-":
                return C_GREEN
            elif v == "X":
                return C_RED

        if self.statusCode > 0:
            return C_RED
        elif v > 0:
            if name in ["E"]:
                return C_RED
            elif name in ["U", "C"]:
                return C_CYAN
            elif name in ["A", "M", "D"]:
                return C_BLUE
            elif name in ["OUT"]:
                return C_YELLOW
            elif name in ["IN", "P"]:
                return C_PURPLE
        elif v == 0:
            return C_GREEN
        return "\033[0m"

    # Pour le IN/OUT
    def status_remote(self):
        # Le delta de revision entre IN et OUT sera en nombre de ligne de cmd_out
        if self.type == "svn":
            cmd_in = "svn diff --non-interactive -r HEAD --summarize ||:"
            cmd_out = None
            # Une substraction sera faire entre IN et out.
        elif self.type == "git":
            # Fusionner les deux commandes git en une seule pour réduire les Popen
            cmd_combined = """
            IN=$(git fetch --recurse-submodules=yes 2>/dev/null && git log --no-decorate --oneline ..origin/main 2>/dev/null | wc -l)
            OUT=$(git log --no-decorate --not --remotes --submodule 2>/dev/null | wc -l)
            echo "${IN} ${OUT}"
            """
            cmd_in = None  # Sera géré par cmd_combined
            cmd_out = None
        elif self.type == "hg":
            cmd_in = "grep '^changeset' < <( hg in )  ||:"
            cmd_out = "grep '^changeset' < <( hg out ) ||:"
        ##
        logger.debug("  path: %s" % self.path)

        ##
        if self.type == "git" and cmd_in is None:
            # Cas git avec commande combinée
            self._exec_git_combined(cmd_combined)
        else:
            self.data["IN"] = self.exec_IN_OUT(cmd_in)
            self.data["OUT"] = self.exec_IN_OUT(cmd_out)
        ##
        return True

    def _exec_git_combined(self, cmd):
        """Exécute une commande git combinée pour IN et OUT."""
        try:
            logger.debug("CMD: %s" % cmd)
            p = subprocess.Popen(
                cmd,
                cwd=self.path,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                shell=True,
                executable="/bin/bash",
                universal_newlines=True,
            )
            stdout, stderr = p.communicate()
            rcode = p.wait()
            logger.debug("STDOUT: %s" % stdout)
            logger.debug("STDERR: %s" % stderr)
            logger.debug("RCODE: %d" % rcode)

            if rcode != 0 or not stdout.strip():
                self.msg.append("Remote (git) KO!")
                self.statusRemoteCode = rcode
                self.data["IN"] = 0
                self.data["OUT"] = 0
            else:
                try:
                    in_count, out_count = map(int, stdout.strip().split())
                    self.data["IN"] = in_count
                    self.data["OUT"] = out_count
                except (ValueError, IndexError):
                    self.data["IN"] = 0
                    self.data["OUT"] = 0
        except Exception as e:
            logger.error("Git combined error: %s" % e)
            self.data["IN"] = "X"
            self.data["OUT"] = "X"

    def exec_IN_OUT(self, cmd=None):
        if cmd:
            rData = ""
            logger.debug("CMD: %s" % cmd)
            p = subprocess.Popen(
                cmd,
                cwd=self.path,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                shell=True,
                executable="/bin/bash",
                universal_newlines=True,
            )
            stdout, stderr = p.communicate()
            try:
                rcode = p.wait()
                logger.debug("STDOUT: %s" % stdout)
                logger.debug("STDERR: %s" % stderr)
                logger.debug("-RCODE: %d" % rcode)
                if rcode != 0:
                    self.msg.append("Remote (in) KO!")
                    self.statusRemoteCode = rcode
                else:
                    rData = len(str(stdout).rstrip("\n").split("\n")) - 1
            except Exception as e:
                rData = "X"
                logger.error(e)
        else:
            rData = "-"
        return rData

    def status(self):
        ##
        if self.type == "svn":
            cmd = "svn status --non-interactive"
        elif self.type == "git":
            cmd = "git status && git submodule status --recursive"
        elif self.type == "hg":
            cmd = "hg status"
        ##
        logger.debug("path: %s" % self.path)
        logger.debug(" cmd: %s" % cmd)
        ##
        try:
            p = subprocess.Popen(
                'cd "%s" && %s' % (self.path, cmd),
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                shell=True,
                universal_newlines=True,
            )
            stdout, stderr = p.communicate()
            rcode = p.wait()
            if rcode != 0:
                stderr = stderr.split("\n")
                # self.msg.append('%s on error' % cmd)
                logger.debug("STDOUT: %s" % stdout)
                logger.debug("STDERR: %s" % stderr)
                logger.debug("RCODE: %d" % rcode)
                if len(stderr) == 2:
                    self.msg.append(stderr[0])
                else:
                    self.msg.append("Local KO!")
                self.statusCode = 1
        except Exception as e:
            logger.error("Check status error: %s" % e)
            return self.data

        ##
        logger.debug(stdout)
        # for line in str(stdout).split('\n'):
        for line in stdout.split("\n"):
            logger.debug("Status stdout line: %s" % line)
            try:
                (status, file) = line.split()
            except ValueError:
                continue
            try:
                self.data[status] += 1
            except KeyError:
                self.data[status] = 1

        ## Renommage des clés du dico:
        if "!" in self.data.keys():
            self.data["E"] = self.data.pop("!")
        if "?" in self.data.keys():
            self.data["U"] = self.data.pop("?")
        if "AM" in self.data.keys():
            self.data["A"] += self.data.pop("AM")
        if "??" in self.data.keys():
            self.data["U"] += self.data.pop("??")

        # Note: status_remote() est appelée seulement si update=True (voir _prepare_cvs)

        ##
        self_data_in = self.data["IN"]
        self_data_out = self.data["OUT"]
        if not str(self_data_in).isdigit():
            self_data_in = 0
        if not str(self_data_out).isdigit():
            self_data_out = 0

        ## Algo couleur du status total:
        ## du plus grave au plus normal
        if self.statusCode != 0 or self.statusRemoteCode != 0 or self.data["E"] != 0:
            self.status_color = C_RED
        elif self.data["U"] != 0 or self.data["C"] != 0:
            self.status_color = C_CYAN
        elif self_data_in == 0 and (self.data["A"] != 0 or self.data["M"] != 0 or self.data["D"] != 0):
            self.status_color = C_BLUE
        elif self_data_in == 0 and self_data_out == 0:
            self.status_color = C_GREEN
        elif self_data_in > 0 and self_data_out == 0:
            self.status_color = C_PURPLE
        elif self_data_out > 0 and self_data_in == 0:
            self.status_color = C_YELLOW
        elif self_data_out > 0 and self_data_in > 0:
            self.status_color = C_PURPLE
        else:
            self.status_color = C_RED
        logger.debug("self_data_out: %d & self_data_in: %d" % (self_data_out, self_data_in))
        ##
        return self.data

    def source(self):
        if self.type == "svn":
            cmd = "svn info --show-item url"
        elif self.type == "git":
            cmd = "git config --get remote.origin.url"
        elif self.type == "hg":
            cmd = "hg paths default"
        ##
        try:
            p = subprocess.Popen(
                'cd "%s" && %s' % (self.path, cmd),
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                shell=True,
            )
            stdout, stderr = p.communicate()
            p.wait()
            # rcode = p.wait()
            # if rcode != 0:
            # self.msg.append('Update faild.')
            # else:
            # self.msg.append('Update %d commit done.' % self.date['IN'])
        except Exception as e:
            logger.debug(cmd, e)
            return False
        ##
        return str(stdout).strip()

    def update(self):
        ##
        if self.data["IN"] == 0:
            self.msg.append("No update needed.")
            return True
        ##
        if self.type == "svn":
            cmd = "svn update"
        elif self.type == "git":
            # Utiliser merge au lieu de pull (fetch a déjà été fait dans status_remote)
            cmd = "git merge --no-edit origin/master --recurse-submodules"
        elif self.type == "hg":
            cmd = "hg pull -u"
        ##
        logger.debug("path: %s" % self.path)
        logger.debug(" cmd: %s" % cmd)
        ##
        try:
            p = subprocess.Popen(
                'cd "%s" && %s' % (self.path, cmd),
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                shell=True,
            )
            stdout, stderr = p.communicate()
            rcode = p.wait()
            if rcode != 0:
                self.msg.append(C_RED + "Update faild." + C_END)
            else:
                self.msg.append("Update %d commit done." % self.date["IN"])
        except Exception as e:
            logger.debug(e)
            return False
        ##
        return True


# =====================================
## FUNCTIONS --------------------------
# =====================================


def del_stdout_char(charCount):
    for _ in range(0, charCount):
        sys.stdout.write("\b")
    sys.stdout.flush()
    return True


def find_repository(path, recursif=False, filter=None):
    charCount = 0
    matches = []
    namePattern = [".svn", ".git", ".hg"]
    userHome = os.path.expanduser("~")
    for root, dirnames, filenames in os.walk(path, topdown=True, followlinks=False):
        # Ne pas descendre dans les répertoires cachés sauf les dossiers VCS connus.
        dirnames[:] = [d for d in dirnames if not d.startswith(".") or d in namePattern]

        # Ne pas scanner les répertoires cachés en eux-mêmes.
        if (root.startswith(".") and not root.startswith("./")) or root.startswith("./."):
            continue

        for dirname in dirnames:
            if root == userHome:
                continue
            if dirname in namePattern:
                if filter and not filter.search(root):
                    continue
                cvsType = dirname[1:]
                logger.debug("> %s (%s)" % (root, cvsType))

                # On affiche des points pour chaque repertoire trouvé:
                sys.stdout.write(".")
                charCount = charCount + 1
                sys.stdout.flush()

                cvs = Chkout(cvsType, root)
                matches.append(cvs)
        if not recursif:
            break
    del_stdout_char(charCount)
    return matches


def print_source(matches):
    userHome = os.path.expanduser("~")
    ## Cherche la path (string) le plus long:
    maxPathLen = 0
    for cvs in matches:
        pathLen = len(cvs.cPath)
        if maxPathLen < pathLen:
            maxPathLen = pathLen
    ##
    for cvs in matches:
        cvs.cPath.replace(userHome, "~", 1)
        # root = cvs.cPath.replace(userHome, "~", 1)
        # print root, cvs.source()
        # msg = " {:<{MPL}s} | {:s}".format(root, cvs.source(), MPL=maxPathLen)
        # print(msg)
    return True


# def print_info(


def _prepare_cvs(cvs, update=False):
    """Prépare un CVS en parallèle : appelle status() et optionnellement update() et status_remote()."""
    cvs.status()
    # Récupérer les infos remote seulement si update est True
    if update:
        cvs.status_remote()
        cvs.update()
    # Cache les conversions de type pour IN/OUT
    cvs._in_is_digit = str(cvs.IN).isdigit()
    cvs._out_is_digit = str(cvs.OUT).isdigit()
    return cvs


def printPretty(
    matches,
    path=None,
    recursif=False,
    verbose=False,
    update=False,
    source=False,
    max_workers=5,
):
    userHome = os.path.expanduser("~")
    T = Theme()
    T.vertical_color = "\u001b[33m"
    T.horizontal_color = "\u001b[34m"
    T.junction_color = "\u001b[33m"
    x = ColorTable(theme=T)
    field_names = ["Path"]
    if verbose:
        field_names.append("Type")
    field_names.extend(
        [
            "Add",
            "Mod",
            "Del",
            "Err!",
            "Ukn?",
            "Con?",
            "IN",
            "OUT",
        ]
    )
    x.field_names = field_names
    x.align = "c"
    x.align["Path"] = "l"

    # Paralléliser la préparation des repos (status + update)
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        matches = list(executor.map(lambda cvs: _prepare_cvs(cvs, update=update), matches))

    for cvs in matches:
        root = cvs.cPath.replace(userHome, "~", 1)
        row = [root]
        if verbose:
            row.append(cvs.type)
        row.extend(
            [
                colored(cvs.A, "light_red") if cvs.A != 0 else colored("🗸", "light_green"),
                colored(cvs.M, "light_red") if cvs.M > 0 else colored("🗸", "light_green"),
                colored(cvs.D, "light_red") if cvs.D > 0 else colored("🗸", "light_green"),
                colored(cvs.E, "red") if cvs.E > 0 else colored("🗸", "light_green"),
                colored(cvs.U, "magenta") if cvs.U > 0 else colored("🗸", "light_green"),
                colored(cvs.C, "yellow") if cvs.C > 0 else colored("🗸", "light_green"),
                colored(cvs.IN, "yellow") if cvs.IN != 0 else colored("🗸", "light_green"),
                colored(cvs.OUT, "yellow") if cvs.OUT != 0 else colored("🗸", "light_green"),
            ]
        )
        x.add_row(row)
    #
    print(x)
    return 0


# =====================================
## MAIN -------------------------------
# =====================================


def main(path=None, recursif=False, verbose=False, filter=None, update=False, source=False, max_workers=5):
    ##
    matches = []
    for p in path:
        matches += find_repository(p, recursif=recursif, filter=filter)
    ## Trie alphabetic des chemins:
    matches.sort(key=operator.attrgetter("path"))
    ##
    #  print_info(matches, source=source, verbose=verbose, update=update)
    printPretty(matches, source=source, verbose=verbose, update=update, max_workers=max_workers)
    ##
    # print_source(matches)
    ##
    return 0


def cli():
    """Point d'entrée pour pipx/console scripts."""
    ## Traitement des arguments:
    parser = argparse.ArgumentParser(description="Multi CVS tool.")
    parser.add_argument("-d", "--debug", action="store_true", default=False, help="Enable debug mode.")
    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        default=False,
        help="Print results in verbose mode (include repository type)",
    )
    parser.add_argument(
        "path",
        metavar="directory",
        nargs="*",
        default=["."],
        help="Directory(s) to scan.",
    )
    parser.add_argument("-f", "--filter", default=None, help="Filter repositories by path pattern")
    parser.add_argument("-r", "--recursif", action="store_true", default=False, help="Scan recursively.")
    parser.add_argument("-s", "--source", action="store_true", default=False, help="Display source repository URLs")
    parser.add_argument(
        "-u", "--update", action="store_true", default=False, help="Update repositories with incoming changes"
    )
    parser.add_argument(
        "-w", "--workers", type=int, default=5, help="Number of parallel workers for scanning repositories (default: 5)"
    )
    argcomplete.autocomplete(parser)
    args = parser.parse_args()
    ## Activation du mode debug
    if args.debug:
        logger.setLevel(logging.DEBUG)
    ## Argument: Filter - compile regex une seule fois
    argFilter = None
    if args.filter:
        # Convertir le filtre fnmatch en regex et compiler
        if "*" not in args.filter:
            pattern = f"*{args.filter}*"
        else:
            pattern = args.filter
        # Convertir fnmatch pattern en regex
        regex_pattern = fnmatch.translate(pattern)
        argFilter = re.compile(regex_pattern)
    ##
    # if not args.path:
    # args.path = ["."]
    ## Main
    try:
        r = main(
            path=args.path,
            recursif=args.recursif,
            verbose=args.verbose,
            filter=argFilter,
            update=args.update,
            source=args.source,
            max_workers=args.workers,
        )
    except KeyboardInterrupt:
        r = 1
    sys.exit(r)


if __name__ == "__main__":
    cli()
