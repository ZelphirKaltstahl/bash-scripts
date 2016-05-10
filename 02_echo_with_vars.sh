#
# Script to print user information who currently login , current date & time
#
clear
echo "Hello $USER"
echo -e "Today is \c ";date
LOGGED_IN_USER_COUNT="$(who | wc -l)"  # the quotes "" preserve multiple lines if any in the output of a command
echo "Number of user login: $LOGGED_IN_USER_COUNT"
echo "Calendar"
cal
exit 0