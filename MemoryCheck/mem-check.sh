#!/bin/bash
#
# Dirty script to type in the name of a process and computer the total memory % used (based off `ps aux`)
#

# Check for arguments passed
if [ $# -lt 1 ]; then
	echo "  Usage: $( basename $0 ) <list of process names separated by a space>"
	exit 1
fi

# Set the passed all the arguments passed as an array
ary_process=( $@ )

# Grab total memory using `free`
total_memory=$(free -m | grep "Mem:" | awk '{print $2}')

# Cycle through each of the arguments passed and process them
for my_process in ${ary_process[@]}; do
	count=0

	# Use PS to find the % of memory used and then add to the total
	for mynum in $(ps axo pmem,comm | grep -v grep | grep "${my_process}" | awk '{print $1}' | grep [0-9] ); do 
		count=$(echo "scale=1; ${count} + ${mynum}" | bc)
	done

	# Computer the processes actual memory usage based
	used_memory=$(echo "scale=1; (${total_memory} * ${count}) / 100" | bc)

	# Return the values to a percentage and output
	echo -e "  ${my_process}:\t${count}%\t(${used_memory} MB)"

done

exit 0
