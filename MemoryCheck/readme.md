# Linux - Memory Check
Simple tool to check the memory usage per process passed to the command.
 - Combines the searched processes per name to give total value per name (ie Chrome)
 - Gives a percentage of memory used by each process compared to the total system memory

###### Output: Default
```
-$ ./mem-check.sh terminator chrome firefox
             PROCESS_NAME    USED_%             USED_MB    PROC_COUNT
              terminator:        .7                55.6             1
                  chrome:      32.1              2552.2            24
         chrome-gnome-sh:        .3                23.8             1
                 firefox:       3.9               310.0             1
```
###### Output: No Headers | -N
```
-$ ./mem-check.sh -N terminator chrome firefox
              terminator:        .7                55.6             1
                  chrome:      32.1              2552.2            24
         chrome-gnome-sh:        .3                23.8             1
                 firefox:       3.9               310.0             1

```
###### Output: CSV | -c
```
-$ ./mem-check.sh -c terminator chrome firefox
process=terminator,memory_percent=.7,memory_mb=55.6,process_count=1
process=chrome,memory_percent=32.1,memory_mb=2552.2,process_count=24
process=chrome-gnome-sh,memory_percent=.3,memory_mb=23.8,process_count=1
process=firefox,memory_percent=3.9,memory_mb=310.0,process_count=1
```
###### Output: MB Only | -m
```
-$ ./mem-check.sh -m terminator chrome firefox
55.6
2552.2
23.8
310.0

```

## Usage
```
  Usage: mem-check.sh [-N|-m|-c] <list of process names separated by a space> | -a
	-a	|	Show ALL processes
	-N	|	No headers
	-m	|	Just show MB used (includes -N functionality)
	-c	|	Output in CSV format (includes -N functionality)
	Sort Tip: <command> | sort -rnk 2
```
