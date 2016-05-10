# using printf seems to be recommended
# clear
# printf "Your first name please: "
# read first_name
# printf "OK, '$first_name' it is! Too late to change it anyway.\n"

clear
echo -e "Your first name please: \c"
read first_name
echo -e "OK, '$first_name' it is! Too late to change it anyway."