# integer arithmetic
result_addition=$((1+1))
result_substraction=$((1-1))
result_multiplication=$((1*1))
result_division=$((1/1))

echo "1 + 1 = $result_addition"
echo "1 - 1 = $result_substraction"
echo "1 * 1 = $result_multiplication"
echo "1 / 1 = $result_division"

#float using python
term1=1.1
term2=1.1

result_float_addition=$(python -c "print($term1+$term2)")
result_float_substration=$(python -c "print($term1-$term2)")
result_float_multiplication=$(python -c "print($term1*$term2)")
result_float_division=$(python -c "print($term1/$term2)")

echo -e "using python: \c"; $(python --version; 2>&1)
echo "1 + 1 = $result_float_addition"
echo "1 - 1 = $result_float_substraction"
echo "1 * 1 = $result_float_multiplication"
echo "1 / 1 = $result_float_division"

#float using awk
term1=1.1
term2=1.1

result_float_addition=$(awk "BEGIN {print $term1+$term2; exit}")
result_float_substration=$(awk "BEGIN {print $term1+$term2; exit}")
result_float_multiplication=$(awk "BEGIN {print $term1+$term2; exit}")
result_float_division=$(awk "BEGIN {print $term1+$term2; exit}")

# modulo
echo "Modulo: $((20%3))"

echo "using awk:"
echo "1 + 1 = $result_float_addition"
echo "1 - 1 = $result_float_substraction"
echo "1 * 1 = $result_float_multiplication"
echo "1 / 1 = $result_float_division"