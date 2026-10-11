#!/usr/bin/env python3

import math
import subprocess


def graph_percent(percent):
    proportion = percent / 5
    graph = []
    for index in range(int(proportion) + 1):
        if index >= 17:
            color = "\033[31m"
        elif index >= 12:
            color = "\033[33m"
        else:
            color = "\033[32m"
        graph.append(f"{color}▓")
    spaces = " " * max(0, math.ceil(19 - proportion))
    return "│[" + "".join(graph) + spaces + "\033[0m]│"


def main():
    result = subprocess.run(
        ["df", "-hP"], check=True, capture_output=True, text=True
    )
    filesystems = [
        line.split()
        for line in result.stdout.splitlines()
        if line.startswith("/dev/")
    ]
    filesystems.sort(key=lambda fields: " ".join(fields[5:]))

    print("┌───┬───────────────────────────┬───────┬──────────────────────┬──────────────┬───────┐")
    print("│%2s │ %-25s │ %5s │ %20s │ %5s - %4s │ %5s │" % ("#", "Mounted", "Used", "", "Free", "Use%", "Size"))
    print("├───┼───────────────────────────┼───────┼──────────────────────┼──────────────┼───────┤")

    for index, fields in enumerate(filesystems):
        device, size, used, free, use_percent, mount = fields[:6]
        percent = int(use_percent.rstrip("%"))
        print("│%2d │ %-25s │" % (index, mount), end="")
        print(" %5s " % used, end="")
        print(graph_percent(percent), end="")
        print(" %5s " % free, end="")
        print("%6s " % f"({use_percent})", end="")
        print("│ %5s │" % size)

    print("└───┴───────────────────────────┴───────┴──────────────────────┴──────────────┴───────┘")


if __name__ == "__main__":
    main()