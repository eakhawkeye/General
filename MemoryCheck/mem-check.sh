#!/bin/bash
#
# Dirty script to type in the name of a process and computer the total memory % used (based off `ps aux`)
#

# Header Check
if [ "${1}x" == "-Nx" ]; then
	show_header=false
	shift
fi

# Check for arguments passed
if [ $# -lt 1 ]; then
	echo "  Usage: $( basename $0 ) [-N] <list of process names separated by a space>"
	exit 1
fi

# Set the passed all the arguments passed as an array
ary_user_search=( $@ )

# Grab the unique names of all the running processes
ary_running_process=( $( ps axo comm | sort | uniq ) )

# Grab total memory using `free`
total_memory=$(free -m | grep "Mem:" | awk '{print $2}')

# Find the real process names which correlate with the user's request
ary_user_process=()
for mysearch in ${ary_user_search[@]}; do
	ary_user_process+=( $(echo -e ${ary_running_process[@]} | tr ' ' '\n' | grep -i ${mysearch}) )
done

# Labels
if ${show_header}; then
	printf "%25s" "PROCESS_NAME"
	printf "%10s" "USED_%"
	printf "%20s" "USED_MB"
	printf "%14s\n" "PROC_COUNT"
fi

# Cycle through each of the arguments passed and process them
for my_process in ${ary_user_process[@]}; do
	process_count=0
	percent_total=0

	# Use PS to find the % of memory used and then add to the total - using bc for fp percision
	for process_percent in $(ps axo pmem,comm | grep -v grep | grep "${my_process}" | awk '{print $1}' | grep [0-9] ); do 
		percent_total=$(echo "scale=1; ${percent_total} + ${process_percent}" | bc)
		((process_count++))
	done

	# Compute the processes actual memory usage based
	used_memory=$(echo "scale=1; (${total_memory} * ${percent_total}) / 100" | bc)

	# Return the values to a percentage and output
	printf "%25s" "${my_process}:"
	printf "%10s" "${percent_total}"
	printf "%20s" "${used_memory}"
	printf "%14s\n" "${process_count}"
done

exit 0
