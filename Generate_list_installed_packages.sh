#!/bin/bash

tempdir="/tmp/dpkg_list_$$"
final_file="$tempdir/dpkg_final"
final_file_sorted="./dpkg_final_sorted"
final_file_sorted_install_script="./dpkg_install_script.sh"
all_files="$tempdir/dpkg.log*"
mkdir $tempdir
cp /var/log/*dpkg* $tempdir
gunzip $tempdir/dpkg*.gz
touch $final_file

#iter through files
for file in $all_files;
do
	echo $file
	sed -n '/ install /p' $file >> $final_file
done
#cleanup; date and package names remain only
sed -n -i 's/\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\).*install \([^:]*\):.*/\1 \2/p' $final_file

sort $final_file > $final_file_sorted
sed -n 's/^.* /sudo apt install /p' $final_file_sorted > $final_file_sorted_install_script
chmod +x $final_file_sorted_install_script
sed -i '1 i #!/bin/bash\n' $final_file_sorted_install_script

