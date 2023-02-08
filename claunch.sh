# A simple script that takes a cpp file as an argument, compiles it and if sucsessful runs the compiled code.
#option flag to delete compiled file after completion
#option flag to choose compiled file directory
#option flag to choose g++ or gcc
#option flag to pass arguments to compiler
#help menu



#initial argument parsing
if [ $# -eq 0 ]; then
    echo "No arguments supplied try -h or --help for how to use"
    exit 1
fi
if [ $1 = "-h" ] || [ $1 = "--help" ]; then
    echo "help menu"
    echo "claunch takes a cpp/c file as an argument, compiles it and if sucsessful runs the compiled code."
    echo "-f --force option flag to force the program to run, even if it writes over stuff"
    echo "-r --remove option flag to delete compiled file after completion"
    echo "-d --dir option flag to choose compiled file directory"
    echo "-c --gcc option flag to choose gcc over the default g++"
    echo "-a --args option flag to pass arguments to compiler"
    echo "-h --help this help menu"
    exit 0
fi

#initializing variables
force=false
remove=false
dir="."
gcc=false
args=""

#argument parsing
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -f|--force)
    force=true
    shift # past argument
    ;;
    -r|--remove)
    remove=true
    shift # past argument
    ;;
    -d|--dir)
    dir="$2"
    shift # past argument
    shift # past value
    ;;
    -c|--gcc)
    gcc=true
    shift # past argument
    ;;
    -a|--args)
    args="$2"
    shift # past argument
    shift # past value
    ;;
    *)
    file="$1"
    shift # past argument
    ;;
esac
done

#checking if compiled file is there before and abort unless force is enabled
if [ -f "$dir/${file%.*}" ]; then
    if [ $force = false ]; then
        echo "compiled file already exists, use -f or --force to run anyway"
        exit 1
    fi
fi



#checking if file is cpp or c
if [ ${file: -4} == ".cpp" ]; then
    if [ $gcc = false ]; then
        g++ $args $file -o "$dir/${file%.*}"
        if [ $? -eq 0 ]; then
            "$dir/${file%.*}"
            if [ $remove = true ]; then
                rm "$dir/${file%.*}"
            fi
        fi
    else
        gcc $args $file -o "$dir/${file%.*}"
        if [ $? -eq 0 ]; then
            "$dir/${file%.*}"
            if [ $remove = true ]; then
                rm "$dir/${file%.*}"
            fi
        fi
    fi
elif [ ${file: -2} == ".c" ]; then
    gcc $args $file -o "$dir/${file%.*}"
    if [ $? -eq 0 ]; then
        "$dir/${file%.*}"
        if [ $remove = true ]; then
            rm "$dir/${file%.*}"
        fi
    fi
else
    echo "file is not a cpp or c file"
    exit 1
fi

