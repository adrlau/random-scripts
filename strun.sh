#takes a language and a a option for file or string. If needed it creates temporary files before it (if needed compiles and) runs the file.

#IMPORTANT! do add a new language to all three arrays at the same time.

#array of supported languages, aliases and runner to each language, python c and c++
languages=( "python" "py" "py3" "python3" "c"  "gcc" "c++" "cpp" "g++" )
#array of supported file types
filetypes=( "py" "py" "py" "py" "c" "c" "cpp" "cpp" "cpp")
#array of runners (claunch is a custom script to take c/cpp files, compile and run, other compiled languages would eigther need to be added to claunch or have their own runners written)
runners=( "python3"  "python3" "python3" "python3" "./claunch.sh -f --gcc" "./claunch.sh -f --gcc" "./claunch.sh -f " "./claunch.sh -f " "./claunch.sh -f ")

#variables
language=""
filetype=""
runner=""
file=""


#help message
if [ "$1" = "help" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "strun uses takes a language and file or string as argument and runs the program using eigther an interpreter or a runner from a list"
    echo "Usage: strun.sh [language] [file/string] [option]"
    echo "language: language in which the file/string is written"
    echo "file/string: either the path to the file or the string to execute"
    echo "ls lists supported languages"
    echo "option: -f for file, -s for string"
    echo "example: strun.sh python3 -f helloworld.py"
    echo "example: strun.sh python3 file helloworld.py"
    echo "example: strun.sh python3 string \"print('hello world!')\""
    exit 0
fi

#ls
if [ "$1" = "ls" ] || [ "$1" = "-l" ] || [ "$1" = "--list" ]; then
    echo "Supported languages:"
    #print languages file extentions and runners /interpreters
    for i in "${languages[@]}"
    do
        #like this but with the : aligned in the print echo "$i : file .${filetypes[$c]} : cmd ${runners[$c]}"
        echo -e "$i \t: file .${filetypes[$c]} \t: runner ${runners[$c]}"
        c=$((c+1))
    done
    exit 0
fi

#check if option is valid
if [ "$2" != "-f" ] && [ "$2" != "-s" ] && [ "$2" != "file" ] && [ "$2" != "string" ]; then
    echo "$2 is not a valid option. Use strun.sh help for help."
    exit 1
fi

#check if language is supported and set runner and filetype
c=0
for i in "${languages[@]}"
do
    if [ "$1" = "$i" ]; then
        language="$i"
        filetype="${filetypes[$c]}"
        runner="${runners[$c]}"
    fi
    c=$((c+1))
done

#check if language is supported
if [ "$language" = "" ]; then
    echo "$1 is not a supported language. Use strun.sh ls to list supported languages."
    exit 1
fi

#if string create file else set file variable to file
if [ "$2" = "-s" ] || [ "$2" = "string" ]; then
    file=".strun-temp.$filetype"
    echo "$3" > $file
else
    file="$3"
fi

#check if file is of correct filetype
if [ "${file##*.}" != "$filetype" ]; then
    echo "$file is not a $filetype file. Use strun.sh ls to list supported languages."
    exit 1
fi

#check if file exists
if [ ! -f "$file" ]; then
    echo "$file does not exist."
    exit 1
fi

##if print status
#echo "language: $language"
#echo "filetype: $filetype"
#echo "runner: $runner"
#echo "file: $file"
#echo "file content:" 
#cat $file
#echo ""

#run file
eval $runner $file

#remove temp file if created
if [ "$2" = "-s" ] || [ "$2" = "string" ]; then
    rm $file
fi
