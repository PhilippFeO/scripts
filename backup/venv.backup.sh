#!/bin/bash

# This script extracts all installed python modules of each venv, i.e. it executes
# "pip freeze > FILE" for every venv and archives all these files. (Name scheme of
# these files: VENV_requirements.txt)
# This is done to create a backup of every virtualenv avoiding copying the whole
# ~/.virtualenvs directore. Execute "pip install -r FILE" to reestablish the venv
# via a "VENV_requirements.txt" file.

venv_dir=~/.virtualenvs
req_list=$venv_dir/requirements_list.txt
file_postfix=_requirements.txt
target_path=/home/philipp/.backup-files

# Clear list to avoid accumulating file names
cat /dev/null > $req_list

for dir in $venv_dir/*; do
    # Venvs are saved as directories, hence files must be skipped
    if [ -d $dir ]; then
		cd $dir
        # Save venv name
		dir_name=$(echo $dir | sed s_/home/philipp/.virtualenvs/__)
        # Activate venv to execute <pip freeze>
		source ./bin/activate
        # venv dependent requirements file
		req_file=$venv_dir/$dir_name$file_postfix
		pip freeze > $req_file
        # Save file path in a list to tar all of them (below)
		echo $req_file >> $req_list
        # deactivate venv
		deactivate
	fi
done

# archive and compress all requirement files of each venv
tar -czf $target_path/venv-requirements.tar.gz -T $req_list
