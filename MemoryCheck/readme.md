# Linux - Memory Check
Simiple tool to check the memory usage per processes based on name to quickly identify how much memory is being used per process name. 
 - Combines the searched processes per name to give total value per name (ie Chrome)
 - Gives a percentage of memory used by each process compared to the total system memory

## Example
```
-$ mem-check.sh terminator chrome firefox
  terminator:	2.2%	(175.2 MB)
  chrome:	20.5%	(1632.8 MB)
  firefox:	6.2%	(493.8 MB)
```

## Usage
```
  Usage: mem-check.sh <list of process names separated by a space>
```
