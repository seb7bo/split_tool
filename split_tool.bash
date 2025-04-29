#!/bin/bash

# Description: A simple tool to split, concatenate, and compare large files.
# Usage:
#   -s <file>           Split the file into 5GB chunks and create a log
#   -c                  Concatenate x* files into outfile.rrec
#   -d <file1> <file2>  Compare two files; print message if identical
#   -h                  Show this help message

# Function to show help
show_help() {
    echo "-s <file>           Split the file into 5GB chunks and log output"
    echo "-c                  Concatenate x* files into outfile.bin"
    echo "-d <file1> <file2>  Compare two files; print message if identical"
    echo "-h                  Show this help message"
}

# If no arguments, show help
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

# Parse options
while getopts ":s:cdh" opt; do
    case $opt in
        s)
            input_file="$OPTARG"
            echo "Splitting file: $input_file"

            # Extract base name for log file (e.g., "mydata.rrec" -> "mydata.rrec.log")
            log_file="${input_file}.log"

            # Perform the split and list new files
            split --bytes=5G "$input_file"
            echo "Created chunks:" > "$log_file"
            ls -1 x* >> "$log_file"

            echo "Log saved to: $log_file"
            ;;
        c)
            echo "Concatenating files into outfile.rrec"
            cat x* > outfile.rrec
            ;;
        d)
            file1="${!OPTIND}"; OPTIND=$((OPTIND + 1))
            file2="${!OPTIND}"; OPTIND=$((OPTIND + 1))

            if [ -z "$file1" ] || [ -z "$file2" ]; then
                echo "Error: -d requires two file arguments." >&2
                show_help
                exit 1
            fi

            echo "Comparing files:"
            echo "  File 1: $file1"
            echo "  File 2: $file2"
            echo "-----------------------------"

            diff_output=$(diff "$file1" "$file2")
            if [ -z "$diff_output" ]; then
                echo "Result: Files are binary same"
            else
                echo "Result: Files are different"
                echo "$diff_output"
            fi
            ;;
        h)
            show_help
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            show_help
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            show_help
            exit 1
            ;;
    esac
done
