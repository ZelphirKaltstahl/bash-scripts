#!/usr/bin/bash

# some definitions
# Virtualenv URLs:
# 	https://pypi.python.org/packages/c8/82/7c1eb879dea5725fae239070b48187de74a8eb06b63d9087cd0a60436353/virtualenv-15.0.1.tar.gz#md5=28d76a0d9cbd5dc42046dd14e76a6ecc
# Python URLs:
# 	https://www.python.org/ftp/python/3.5.1/Python-3.5.1.tar.xz
# 	https://www.python.org/ftp/python/3.4.4/Python-3.4.4.tar.xz

#################
# process input #
#################

# firstly get the parameters into variables with a speaking name

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

MESSAGE_COLOR="${BIBlue}"
ERROR_COLOR="${BIRed}"
WARNING_COLOR="${BIYellow}"
NO_COLOR="${Color_Off}"

venv_name_supplied=0
python_url_supplied=0
python_version_supplied=0
packages_supplied=0
virtualenv_url_supplied=0

while getopts n:d:p:v:i: opts; do
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
		i)
			python_version=$OPTARG
			python_version_supplied=1
			;;
	esac
done

echo ""
echo -e "${MESSAGE_COLOR}MSG:${NO_COLOR} The pipe (\"|\") character is a delimiter:"
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: venv_name: |${venv_name}|"
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: python_url: |${python_url}|"
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: python_version: |${python_version}|"
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: virtualenv_url: |${virtualenv_url}|"
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: packages: |${packages}|"
echo ""


# then check if all mandatory parameters were supplied
# and print error messages if a mandatory parameter has not been supplied
if [ $venv_name_supplied -eq 1 ]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: a name for the virtualenv has been supplied"
else
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: you need to supply a name for the virtualenv using the -n parameter"
	exit 1
fi

if [ $python_url_supplied -eq 1 ]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: a URL for the python version has been supplied"
else
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: you need to supply a url for the python version using the -p parameter"
	exit 1
fi

if [ $virtualenv_url_supplied -eq 1 ]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: a URL for the virtualenv version has been supplied"
else
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: you need to supply a url for the virtualenv version using the -v parameter"
	exit 1
fi

if [ $packages_supplied -eq 1 ]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: packages names have been supplied"
else
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: no package names have been supplied; you may supply them using the -d parameter"
fi

if [ $python_version_supplied -eq 1 ]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: python version has been supplied"
else
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: no python version has been supplied; you may supply them using the -i parameter"
	exit 1
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
	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: virtualenv directory already exists, choose another virtualenv name"
	echo ""
	exit 1
fi

# enter the venvs directory
pushd $venv_name
venv_dir=${PWD}

localpython_src_dir_created=0
localpython_dir_created=0
virtualenv_src_dir_created=0
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: now creating directory structure ..."

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
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: creation of directory structure \033[1;92msuccessful${NO_COLOR}"
else
	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: creation of directory structure ${ERROR_COLOR}failed${NO_COLOR}"
	exit 1
fi

##########
# python #
##########
PYTHONHOME="${venv_name}/localpython"
# enter the localpython source directory
pushd localpython_src
# download the python source
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: now downloading python source ..."
wget $python_url
if [ $? -ne 1 ]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: download of python source \033[1;92msuccessful${NO_COLOR}"
else
	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: download of python source ${ERROR_COLOR}failed${NO_COLOR}"
	exit 1
fi
# extract python
for filename in *.tar.xz; do
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: now extracting $filename ..."
    tar -xvf $filename 2>&1 1> python_extract_log
    if [[ $? -eq 0 ]]; then
    	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: python extraction \033[1;92msuccessful${NO_COLOR}"
    else
    	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: python extraction ${ERROR_COLOR}failed${NO_COLOR}"
		exit 1
    fi
done
# build python
# get the build dir in a variable
# pushd ..
# pushd localpython
# python_build_dir=${PWD}
# popd
# popd
python_build_dir="$(dirname "${PWD}")"/localpython

# change directory into the extracted archive directory
pushd */. >> /dev/null
# configure python sources
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: now configuring python ..."
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: logging to ${PWD}/python_configure_log"
./configure --prefix=$python_build_dir 2>&1 1> python_configure_log
if [ $? -ne 1 ]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: python configure \033[1;92msuccessful${NO_COLOR}"
else
	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: python configure ${ERROR_COLOR}failed${NO_COLOR}"
	exit 1
fi
# make python using 4 threads
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: now compiling python ..."
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: logging to ${PWD}/python_make_log"
make -j4 &> python_make_log
if [ $? -ne 1 ]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: python compilation \033[1;92msuccessful${NO_COLOR}"
else
	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: python compilation ${ERROR_COLOR}failed${NO_COLOR}"
	exit 1
fi

# make install
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: now installing python ..."
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: logging to ${PWD}/python_make_install_log"
make install &> "${PWD}/python_make_install_log"
if [[ $? -eq 0 ]]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: python install \033[1;92msuccessfully${NO_COLOR}"
else
	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: python installation ${ERROR_COLOR}failed${NO_COLOR}"
	exit 1
fi

echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: PWD: ${PWD}"

##############
# virtualenv #
##############

cd "${venv_dir}/virtualenv_src"
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: PWD: ${PWD}"

echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: now downloading virtualenv ..."
wget $virtualenv_url
if [ $? -eq 0 ]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: virtualenv source download \033[1;92msuccessful${NO_COLOR}"
else
	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: virtualenv source download ${ERROR_COLOR}failed${NO_COLOR}"
	exit 1
fi

for filename in *.tar.gz; do
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: now extracting $filename ..."
    tar -xvf $filename &> virtualenv_extract_log
    if [[ $? -eq 0 ]]; then
    	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: virtualenv extraction \033[1;92msuccessful${NO_COLOR}"
    else
    	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: virtualenv extraction ${ERROR_COLOR}failed${NO_COLOR}"
		exit 1
    fi
done

pushd */. >> /dev/null

echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: now installing virtualenv ..."
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: logging to ${PWD}/virtualenv_install_log"
${venv_dir}/localpython/bin/python${python_version} setup.py install &> virtualenv_install_log
if [[ $? -eq 0 ]]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: virtualenv installation \033[1;92msuccessful${NO_COLOR}"
else
	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: virtualenv installation ${ERROR_COLOR}failed${NO_COLOR}"
	exit 1
fi

# creating the virtualenv
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: now creating new virtual environment ..."
cd ${venv_dir} >> /dev/null
${venv_dir}/localpython/bin/virtualenv --python="${venv_dir}/localpython/bin/python${python_version}" .
if [[ $? -eq 0 ]]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: virtualenv creation \033[1;92msuccessful${NO_COLOR}"
else
	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: virtualenv creation ${ERROR_COLOR}failed${NO_COLOR}"
	exit 1
fi

# installing pip packages
if [[ $packages_supplied -eq 1 ]]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: now installing packages ..."
	pip install $packages
	if [[ $? -eq 0 ]]; then
		echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: packages installation \033[1;92msuccessful${NO_COLOR}"
	else
		echo -e "${ERROR_COLOR}ERR${NO_COLOR}: packages installation ${ERROR_COLOR}failed${NO_COLOR}"
		echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: you may fix this one on your own"
		exit 1
	fi
else
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: ${WARNING_COLOR}skipping${NO_COLOR} packages installation, because none have been supplied"
fi

# use local virtualenv in the future
echo "" >> "${venv_dir}/bin/activate"
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: Now making virtualenv point to the virtualenv executable in the localpython distribution..."
echo "### virtualenv alias" >> "${venv_dir}/bin/activate"
echo "alias virtualenv='localpython/bin/virtualenv'" >> "${venv_dir}/bin/activate"
if [[ $? -eq 0 ]]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: aliasing virtualenv \033[1;92msuccessful${NO_COLOR}"
else
	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: aliasing virtualenv ${ERROR_COLOR}failed${NO_COLOR}"
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: you may fix this one on your own"
	exit 1
fi

# use local pip in the future
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: Now making pip point to the pip\${python_version} executable in the localpython distribution..."
echo "### pip alias" >> "${venv_dir}/bin/activate"
echo "alias pip='localpython/bin/pip'${python_version}" >> "${venv_dir}/bin/activate"
if [[ $? -eq 0 ]]; then
	echo "" >> "${venv_dir}/bin/activate"
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: aliasing pip \033[1;92msuccessful${NO_COLOR}"
else
	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: aliasing pip ${ERROR_COLOR}failed${NO_COLOR}"
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: you may fix this one on your own"
	exit 1
fi

# make it relocatable
echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: now making virtual environment relocatable ..."
virtualenv --relocatable .
if [[ $? -eq 0 ]]; then
	echo -e "${MESSAGE_COLOR}MSG${NO_COLOR}: making virtual environment relocatable \033[1;92msuccessful${NO_COLOR}"
else
	echo -e "${ERROR_COLOR}ERR${NO_COLOR}: making virtual environment relocatable ${ERROR_COLOR}failed${NO_COLOR}"
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
