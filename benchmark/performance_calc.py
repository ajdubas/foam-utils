#!/usr/bin/python3
"""
performance_calc.

A utility to extract the performance of an OpenFOAM benchmark
from a given log file.
"""
import argparse

parser = argparse.ArgumentParser(
    description='Calculate OpenFOAM performance.')
parser.add_argument('logfile',
                    help='Log file from performance benchmark.')
parser.add_argument('cells', type=int,
                    help='Number of cells.')
args = parser.parse_args()

# Load data from log file
with open(args.logfile, "r") as fin:
    loglines = fin.readlines()

# Extract data from log file
timesteps = []
iters = []
exectimes = []
clocktimes = []
for line in loglines:
    words = line.split()
    if len(words) < 3:
        continue
    if words[0] == "nProcs":
        procs = int(words[2])
    if words[0] == "Time":
        timesteps.append(words[2])
        iters.append([])
    if words[-2] == "Iterations":
        iters[-1].append(int(words[-1]))
    if words[0] == "ExecutionTime":
        exectimes.append(float(words[2]))
        clocktimes.append(float(words[6]))

# Calculate performance excluding first and last timestep
itersum = 0
for iter in iters[1:-1]:
    itersum += sum(iter)
exectime = exectimes[-2] - exectimes[1]
clocktime = clocktimes[-2] - clocktimes[1]
print("Performance excluding first and last timestep:")
print("{} iterations over {} cells".format(itersum, args.cells))
print("{} s execution time".format(exectime))
print("{} s clock time".format(clocktime))
print("{} s/itercell execution".format(exectime/(itersum*args.cells)))
print("{} s/itercell clock".format(clocktime/(itersum*args.cells)))
print("{} iter.cell/µs clock".format((itersum*args.cells)/(clocktime*1e6)))
print("{} iter.cell/µs.core clock".format((itersum*args.cells) /
                                          (clocktime*1e6*procs)))

# Input, setup and output performance estimates
ts1calc = sum(iters[0])*clocktime/itersum
tsfcalc = sum(iters[-1])*clocktime/itersum
istime = clocktimes[0]-ts1calc
outime = (clocktimes[-1]-clocktimes[-2])-tsfcalc
print("\nPerformance of input, setup and output:")
print("{} s input and setup time".format(istime))
print("{} s output time".format(outime))
print("{} cells/s input and setup performance".format(args.cells/istime))
print("{} cells/s output performance".format(args.cells/outime))
