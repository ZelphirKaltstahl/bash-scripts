# if ! [ -d "$DIRECTORY" ]; then  # the whitespace between the brackets and -d are necessary!
# 	mkdir testdir
# fi

# [ -d "$DIRECTORY" ] || mkdir testdir

DIRECTORY=testdir

# if ! [ -d "$DIRECTORY" ]; then  # the whitespace between the brackets and -d are necessary!
# 	mkdir testdir
# fi

# even shorter! || is the else it seems?
[[ -d $DIRECTORY ]] || mkdir $DIRECTORY

pushd testdir
touch testfile
popd

cd testdir
touch second
cd ..