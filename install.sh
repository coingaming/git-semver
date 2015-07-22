#!/bin/bash

# Get script directory
pushd $(dirname $0) > /dev/null
DIR_SELF=$(pwd -P)
popd > /dev/null

DIR_DATA="${HOME}/.git-semver"

# Running on MinGW
uname -s | grep -q 'MINGW[^_]\+_NT'
OS_MINGW=$?

dirs=("${HOME}/bin" "/usr/local/bin" "/usr/bin" "/bin")
for i in "${dirs[@]}"
do
    if [ -d "${i}" ] && $(echo $PATH | grep -q "${i}")
    then
        DIR_BIN="${i}"
        break;
    fi
done

FILE_SRC="${DIR_SELF}/git-semver.sh"
FILE_DEST="${DIR_BIN}/git-semver"
FILE_CONF_SRC="${DIR_SELF}/config.example"
FILE_CONF_DEST="${DIR_DATA}/config"

# If MinGW
if [ ${OS_MINGW} -eq 0 ]
then
	# Tabs are important for the heredoc
	cat <<-EOF > "${FILE_DEST}"
		#!/bin/bash

		FILE_SRC="${FILE_SRC}"
		FILE_PREFIX=""
		if uname -s | grep -q 'MINGW[^_]\+_NT'
		then
		    "\${FILE_SRC}" \$@
		else
		    if uname -s | grep -q 'CYGWIN_NT'
		    then
		       FILE_PREFIX="/cygdrive"
		    fi
		    echo -e "Error: This file is a stub designed to run under MinGW, please reinstall \$(basename "\$0") by running:\n\n  \${FILE_PREFIX}\$(dirname \${FILE_SRC})/install.sh"
		fi
	EOF
# Otherwise
else
    if [ -L "${FILE_DEST}" ]
    then
        rm "${FILE_DEST}"
    fi
    # Symlink
    ln -s "${FILE_SRC}" "${FILE_DEST}"
fi

# Copy configuration
mkdir -p "${DIR_DATA}"
if [ ! -f "${FILE_CONF_DEST}" ]
then
    cp "${FILE_CONF_SRC}" "${FILE_CONF_DEST}"
fi
