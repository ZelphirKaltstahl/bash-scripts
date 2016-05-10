echo "USER: $USERNAME"
echo "PWD: $PWD"

while getopts f:t: opts; do
   case ${opts} in
      f) from_val=${OPTARG} ;;
      t) to_val=${OPTARG} ;;
   esac
done

echo "from_val: $from_val"
echo "to_val: $to_val"