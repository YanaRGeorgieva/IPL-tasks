echo -n "Please enter the name of the C file you wish to highlight:"
read fileName
if ! [[ $fileName == *.c\n ]]; then
    set PWD=%~dp0
    set base=%PWD% and "/c2html.pl"
    PL=swipl
    exec $PL -q -f "%base%" "%fileName%"
else
    ECHO "Not a correct C filename!"
fi
