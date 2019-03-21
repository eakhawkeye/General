#!/bin/bash
#
# Dirty script to type in the name of a process and computer the total memory % used (based off `ps aux`)
#

function help_me() {
    # Show Help and Exit
    echo "  Usage: $( basename $0 ) [-N|-m|-c] <list of process names separated by a space> | -a"
    echo -e "\t-a\t|\tShow ALL processes"
    echo -e "\t-N\t|\tNo headers"
    echo -e "\t-m\t|\tJust show MB used (includes -N functionality)"
    echo -e "\t-c\t|\tOutput in CSV format (includes -N functionality)"
    echo -e "\tSort Tip: <command> | sort -rnk 2"
    exit 1
}

# Arguments Formatting
compute_all=false
show_header=true
output_mb=false
output_csv=false
while [[ "${1}" =~ ^- ]]; do
    case "${1}" in
        '-a' ) compute_all=true; shift;;
        '-N' ) show_header=false; shift;;
        '-m' ) output_mb=true; show_header=false; shift;;
        '-c'* ) output_csv=true; show_header=false; shift;;
        '-'* ) help_me; shift;;
    esac
done

# Output Help if no processes passed
if [ $# -lt 1 ] && ! ${compute_all}; then help_me; fi

# Grab the unique names of all the running processes
ary_running_process=( $( ps axo comm | sort | uniq ) )

# Set the passed all the arguments passed as an array
ary_user_search=( $@ )


if ${compute_all}; then 
    ary_user_search=${ary_running_process[@]}
else
    ary_user_search=( $@ )
fi

# Grab total memory using `free`
total_memory=$(free -m | grep "Mem:" | awk '{print $2}')

# Find the real process names which correlate with the user's request
ary_user_process=()
for mysearch in ${ary_user_search[@]}; do
    ary_user_process+=( $(echo -e ${ary_running_process[@]} | tr ' ' '\n' | sort | uniq | grep -i ${mysearch}) )
done

# Output Header
if ${show_header}; then
    printf "%25s" "PROCESS_NAME"
    printf "%10s" "USED_%"
    printf "%20s" "USED_MB"
    printf "%14s\n" "PROC_COUNT"
fi

# Cycle through each of the arguments passed then process
for my_process in ${ary_user_process[@]}; do
    process_count=0
    percent_total=0

    # Use PS to find the % of memory used and then add to the total - using bc for fp percision
    for process_percent in $(ps axo pmem,comm | grep -v grep | grep "${my_process}" | awk '{print $1}' | grep [0-9] ); do 
        percent_total=$(echo "scale=1; ${percent_total} + ${process_percent}" | bc)
        ((process_count++))
    done

    # Compute the process's actual memory usage based
    used_memory=$(echo "scale=1; (${total_memory} * ${percent_total}) / 100" | bc)

    # Output Data
    if ${output_csv}; then
        echo -n "process=${my_process},"
        echo -n "memory_percent=${percent_total},"
        echo -n "memory_mb=${used_memory},"
        echo "process_count=${process_count}"
    elif ${output_mb}; then
        echo ${used_memory}
    else
        printf "%25s" "${my_process}:"
        printf "%10s" "${percent_total}"
        printf "%20s" "${used_memory}"
        printf "%14s\n" "${process_count}"
    fi
done

exit 0