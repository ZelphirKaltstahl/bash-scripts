#!/usr/bin/bash

# some definitions
# Virtualenv URL:
# https://pypi.python.org/packages/c8/82/7c1eb879dea5725fae239070b48187de74a8eb06b63d9087cd0a60436353/virtualenv-15.0.1.tar.gz#md5=28d76a0d9cbd5dc42046dd14e76a6ecc
# Python URL:
# https://www.python.org/ftp/python/3.5.1/Python-3.5.1.tar.xz

#################
# process input #
#################

# firstly get the parameters into variables with a speaking name
$recent_python_version=3.5

venv_name_supplied=0
python_url_supplied=0
packages_supplied=0
virtualenv_url_supplied=0

while getopts n:d:p:v: opts; do
	case $opts in
		n)
			venv_name=$OPTARG
			venv_name_supplied=1
			;;
		d)
			packages=$OPTARG
			packages_supplied=1
			;;
		p)
			python_url=$OPTARG
			python_url_supplied=1
			;;
		v)
			virtualenv_url=$OPTARG
			virtualenv_url_supplied=1
			;;
	esac
done

echo ""
echo -e "\033[1;35mMSG\033[0m: venv_name: $venv_name"
echo -e "\033[1;35mMSG\033[0m: python_url: $python_url"
echo -e "\033[1;35mMSG\033[0m: virtualenv_url: $virtualenv_url"
echo -e "\033[1;35mMSG\033[0m: packages: $packages"
echo ""


# then check if all mandatory parameters were supplied
# and print error messages if a mandatory parameter has not been supplied
if [ $venv_name_supplied -eq 1 ]; then
	echo -e "\033[1;35mMSG\033[0m: a name for the virtualenv has been supplied"
else
	echo -e "\033[1;35mMSG\033[0m: you need to supply a name for the virtualenv using the -n parameter"
	exit 1
fi

if [ $python_url_supplied -eq 1 ]; then
	echo -e "\033[1;35mMSG\033[0m: a URL for the python version has been supplied"
else
	echo -e "\033[1;35mMSG\033[0m: you need to supply a url for the python version using the -p parameter"
	exit 1
fi

if [ $virtualenv_url_supplied -eq 1 ]; then
	echo -e "\033[1;35mMSG\033[0m: a URL for the virtualenv version has been supplied"
else
	echo -e "\033[1;35mMSG\033[0m: you need to supply a url for the virtualenv version using the -v parameter"
	exit 1
fi

if [ $packages_supplied -eq 1 ]; then
	echo -e "\033[1;35mMSG\033[0m: packages names have been supplied"
else
	echo -e "\033[1;35mMSG\033[0m: no package names have been supplied; you may supply them using the -d parameter"
fi

####################
# make directories #
####################

# if the script did not exit until here,
# we should have all necessary variables
if ! [ -d "$venv_name" ]; then  # the whitespace between the brackets and -d are necessary!
	mkdir $venv_name
else
	echo ""
	echo -e "\033[1;91mERR\033[0m: virtualenv directory already exists, choose another virtualenv name"
	echo ""
	exit 1
fi

# enter the venvs directory
pushd $venv_name
venv_dir=$PWD

localpython_src_dir_created=0
localpython_dir_created=0
virtualenv_src_dir_created=0
echo -e "\033[1;35mMSG\033[0m: now creating directory structure ..."

mkdir localpython_src
if [ $? -eq 0 ]; then
	localpython_src_dir_created=1
fi

mkdir localpython
if [ $? -eq 0 ]; then
	localpython_dir_created=1
fi

mkdir virtualenv_src
if [ $? -eq 0 ]; then
	virtualenv_src_dir_created=1
fi

if [[ $localpython_src_dir_created -eq 1 ]] && [[ $localpython_dir_created -eq 1 ]] && [[ $virtualenv_src_dir_created -eq 1 ]]; then
	echo -e "\033[1;35mMSG\033[0m: creation of directory structure \033[1;92msuccessful\033[0m"
else
	echo -e "\033[1;91mERR\033[0m: creation of directory structure \033[1;91mfailed\033[0m"
	exit 1
fi

##########
# python #
##########
$PYTHONHOME=$venv_name/localpython
# enter the localpython source directory
pushd localpython_src
# download the python source
echo -e "\033[1;35mMSG\033[0m: now downloading python source ..."
wget $python_url
if [ $? -ne 1 ]; then
	echo -e "\033[1;35mMSG\033[0m: download of python source \033[1;92msuccessful\033[0m"
else
	echo -e "\033[1;91mERR\033[0m: download of python source \033[1;91mfailed\033[0m"
	exit 1
fi
# extract python
for filename in *.tar.xz; do
	echo -e "\033[1;35mMSG\033[0m: now extracting $filename ..."
    tar -xvf $filename 2>&1 1> python_extract_log
    if [[ $? -eq 0 ]]; then
    	echo -e "\033[1;35mMSG\033[0m: python extraction \033[1;92msuccessful\033[0m"
    else
    	echo -e "\033[1;91mERR\033[0m: python extraction \033[1;91mfailed\033[0m"
		exit 1
    fi
done
# build python
# get the build dir in a variable
# pushd ..
# pushd localpython
# python_build_dir=$PWD
# popd
# popd
python_build_dir="$(dirname "$PWD")"/localpython

# change directory into the extracted archive directory
pushd */. >> /dev/null
# configure python sources
echo -e "\033[1;35mMSG\033[0m: now configuring python ..."
echo -e "\033[1;35mMSG\033[0m: logging to $PWD/python_configure_log"
./configure --prefix=$python_build_dir 2>&1 1> python_configure_log
if [ $? -ne 1 ]; then
	echo -e "\033[1;35mMSG\033[0m: python configure \033[1;92msuccessful\033[0m"
else
	echo -e "\033[1;91mERR\033[0m: python configure \033[1;91mfailed\033[0m"
	exit 1
fi
# make python using 4 threads
echo -e "\033[1;35mMSG\033[0m: now compiling python ..."
echo -e "\033[1;35mMSG\033[0m: logging to $PWD/python_make_log"
make -j4 &> python_make_log
if [ $? -ne 1 ]; then
	echo -e "\033[1;35mMSG\033[0m: python compilation \033[1;92msuccessful\033[0m"
else
	echo -e "\033[1;91mERR\033[0m: python compilation \033[1;91mfailed\033[0m"
	exit 1
fi

# make install
echo -e "\033[1;35mMSG\033[0m: now installing python ..."
echo -e "\033[1;35mMSG\033[0m: logging to $PWD/python_make_install_log"
make install &> python_make_install_log
if [[ $? -eq 0 ]]; then
	echo -e "\033[1;35mMSG\033[0m: python install \033[1;92msuccessfully\033[0m"
else
	echo -e "\033[1;91mERR\033[0m: python installation \033[1;91mfailed\033[0m"
	exit 1
fi

echo -e "\033[1;35mMSG\033[0m: PWD: $PWD"

##############
# virtualenv #
##############

cd $venv_dir/virtualenv_src
echo -e "\033[1;35mMSG\033[0m: PWD: $PWD"

echo -e "\033[1;35mMSG\033[0m: now downloading virtualenv ..."
wget $virtualenv_url
if [ $? -eq 0 ]; then
	echo -e "\033[1;35mMSG\033[0m: virtualenv source download \033[1;92msuccessful\033[0m"
else
	echo -e "\033[1;91mERR\033[0m: virtualenv source download \033[1;91mfailed\033[0m"
	exit 1
fi

for filename in *.tar.gz; do
	echo -e "\033[1;35mMSG\033[0m: now extracting $filename ..."
    tar -xvf $filename &> virtualenv_extract_log
    if [[ $? -eq 0 ]]; then
    	echo -e "\033[1;35mMSG\033[0m: virtualenv extraction \033[1;92msuccessful\033[0m"
    else
    	echo -e "\033[1;91mERR\033[0m: virtualenv extraction \033[1;91mfailed\033[0m"
		exit 1
    fi
done

pushd */. >> /dev/null

echo -e "\033[1;35mMSG\033[0m: now installing virtualenv ..."
echo -e "\033[1;35mMSG\033[0m: logging to $PWD/virtualenv_install_log"
$venv_dir/localpython/bin/python3.5 setup.py install &> virtualenv_install_log
if [[ $? -eq 0 ]]; then
	echo -e "\033[1;35mMSG\033[0m: virtualenv installation \033[1;92msuccessful\033[0m"
else
	echo -e "\033[1;91mERR\033[0m: virtualenv installation \033[1;91mfailed\033[0m"
	exit 1
fi

echo -e "\033[1;35mMSG\033[0m: now creating new virtual environment ..."
cd $venv_dir >> /dev/null
$venv_dir/localpython/bin/virtualenv --python=$venv_dir/localpython/bin/python3.5 .

echo -e "\033[1;35mMSG\033[0m: now installing packages ..."
pip install $packages
if [[ $? -eq 0 ]]; then
	echo -e "\033[1;35mMSG\033[0m: packages installation \033[1;92msuccessful\033[0m"
else
	echo -e "\033[1;91mERR\033[0m: packages installation \033[1;91mfailed\033[0m"
	echo -e "\033[1;35mMSG\033[0m: you may fix this one on your own"
	exit 1
fi

# use local virtualenv in the future
echo "" >> $venv_dir/bin/activate
echo "### virtualenv" >> $venv_dir/bin/activate
echo "alias virtualenv='localpython/bin/virtualenv'" >> $venv_dir/bin/activate
echo "" >> $venv_dir/bin/activate

# make it relocatable
echo -e "\033[1;35mMSG\033[0m: now making virtual environment relocatable ..."
virtualenv --relocatable . 
if [[ $? -eq 0 ]]; then
	echo -e "\033[1;35mMSG\033[0m: making virtual environment relocatable \033[1;92msuccessful\033[0m"
else
	echo -e "\033[1;91mERR\033[0m: making virtual environment relocatable \033[1;91mfailed\033[0m"
	exit 1
fi

# test things
# which python
# python --version
# which virtualenv
# virtualenv --version
# which pip
# pip --version

# exit successfuly
exit 0