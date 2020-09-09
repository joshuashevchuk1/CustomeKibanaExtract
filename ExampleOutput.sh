
#------------------------------------------
# general template for grep commands below
#
#============================================
# general format for a single phrase to search
#
# grep pattern filename
#============================================
# general format for multiple phrases to search
# 
# grep -e pattern1 -e pattern 2 ... -e pattern n filename 
#============================================
# store the grep command in a variable
test="$(grep -e DISK -e export DISK.sh)"
echo "$test"
#------------------------------------------

