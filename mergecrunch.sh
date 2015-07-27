#!/bin/bash

# Título:      MergeCrunch
# Descripción: Download from Crunchyroll and generate a mkv file with video, subtitles and fonts merged.
# Autor:       José Ángel Pastrana Padilla

# DEPENDENCIES:

# - Enough fonts installed in your system!
# - youtube-dl
# - mkvmerge
# - rhash (recommend, but it has not).

# DEFAULT PARAMETERS.

# Argument for calculate CRC32 sum after finish and rename file name.
# By command line, it can be actived by "-c" or "--crc32"
CRC32="" # Default: "" (Means disabled). Change to "YES" for always active

# Argument for set video resolution.
# By command line, it is "-f value" or "--format value".
# Default: "" (Means best resolution). 
# Change to other value as "480p", "720p", "1080p".
# If there are any problem, try "480p-0", "720p-0", "1080p-1", "480p-1", "720p-1", "1080p-0", "1080p-1".
FORMAT=""

# Argument for set default track subtitle if your player doesn't set this field.
# By command line, use "-s value" or "--sub_default value"
# Default: "" (Means english).
# Value to "enUS" for force English.
# Value to "esES" for force Spanish Castillian.
# Value to "esLA" for force Spanish Mejicano.
# Value to "frFR" for force Français.
# Value to "itIT" for force Italiano.
# Value to "ptBR" for force Português.
# Value to "deDE" for force Deutsch.
# Value to "arME" for force العربية
SUB_DEFAULT="" 


# NEED THIS VARIABLES...
TMP_DIR="/tmp/${$}"
DEST_DIR="$(pwd)"
declare -A SUB_LANG
SUB_LANG["enUS","tag"]="eng"
SUB_LANG["enUS","cty"]="English (US)"
SUB_LANG["esES","tag"]="spa"
SUB_LANG["esES","cty"]="Español (España)"
SUB_LANG["esLA","tag"]="spa"
SUB_LANG["esLA","cty"]="Español (México)"
SUB_LANG["frFR","tag"]="fre"
SUB_LANG["frFR","cty"]="Français (France)"
SUB_LANG["itIT","tag"]="ita"
SUB_LANG["itIT","cty"]="Italiano (Italia)"
SUB_LANG["ptBR","tag"]="por"
SUB_LANG["ptBR","cty"]="Português (Brasil)"
SUB_LANG["deDE","tag"]="ger"
SUB_LANG["deDE","cty"]="Deutsch (Deutschland)"
SUB_LANG["arME","tag"]="ara"
SUB_LANG["arME","cty"]="العربية"

# CHECKING...
if [ ${#} -eq 0 ]
then
	echo "Error. MergeCrunch needs a input URL as parameter."
	echo "Syntaxis:"
	echo "	${0} -i URL [-f format] [-s force] [-c] [-o output]"
	exit -1
fi

if [ -z "$(which youtube-dl)" ]
then
	echo "Please, first install youtube-dl package."
	echo "Run 'sudo apt-get install youtube-dl' and try again."
	exit -1
fi

if [ -z "$(which mkvmerge)" ]
then
	echo "Please, first install mkvtoolnix package."
	echo "Run 'sudo apt-get install mkvtoolnix mkvtoolnix-gui' and try again."
	exit -1
fi


# PARSING...
while [ ${#} -gt 0 ]
do
	case "${1}" in
		-i|--input)
			INPUT="${2}"
			shift
		;;
		-o|--output)
			OUTPUT="${DEST_DIR}/${2}"
			shift
		;;
		-c|--crc32)
			if [ -z "$(which rhash)" ]
			then
				echo "For use -c argument, it needs rhash installed."
				echo "Run 'sudo apt-get install rhash' and try again."
				exit -1
			fi
			CRC32="YES"
		;;
		-f|--format)
			FORMAT="-f ${2}"
			shift
		;;
		-s|--sub_default)
			if [ -z "${SUB_LANG["${2}","tag"]}" ]  || [ -z "${SUB_LANG["${2}","cty"]}" ]
			then
				echo "Error. Subtitle specification for ${2} not found."
				echo "Edit this script and add it in SUB_LANG array."
				exit -1
			fi
			SUB_DEFAULT="${2}"
			shift
		;;
		*)
			echo "Error. Unexpected argument: ${1}"
			exit -1
		;;
	esac
	shift
done


# MAIN...
# Prepare temp dir
mkdir -p "${TMP_DIR}"
cd "${TMP_DIR}"

# Get Crunchyroll file
if [ -n "${SUB_DEFAULT}" ]
then
	youtube-dl ${FORMAT} --no-continue --no-part --all-subs --add-header "Accept-Language:${SUB_DEFAULT}" ${INPUT}
else
	youtube-dl ${FORMAT} --no-continue --no-part --all-subs ${INPUT}
fi

# Prepare output filename
DL_NAME="$(ls *.flv)"
if [ -z "${OUTPUT}" ]
then
	OUTPUT="${DEST_DIR}/${DL_NAME%-*.flv}.mkv"
fi

# Prepare subtitles downloaded for will merge to output file
for each in *.ass
do
	sl=${each%.ass}
	sl=${sl##*.}
	unset def
	if [ "${SUB_DEFAULT}" = "${sl}" ]
	then
		def="--default-track 0:yes"
	fi
	SUB_MKV+=("--language 0:${SUB_LANG["${sl}","tag"]} --track-name '0:${SUB_LANG["${sl}","cty"]}' ${def} '(' '${each}' ')'")
done

# Searching for fonts attachments
for each in *.ass
do
        while read -r line
        do
                fonts+=("${line}")
        done <<< "$(cat "${each}" | grep "^Style:" | cut -d"," -f2 | sort -u)"
done

while read -r line
do
        found=$(fc-match "${line}" | cut -d'"' -f2)
        if [ "${found}" != "${line}" ]
        then
                echo "WARNING: REQUEST FONT ${line} IS NOT INSTALLED IN YOUR SYSTEM. WILL BE USE ${found}."
        fi
        FONT_MKV+=("--attach-file $(fc-match -v "${line}" | grep "file:" | cut -d'"' -f2)")
done <<< "$(printf "%s\n" "${fonts[@]}" | sort -u)"

# Launch mkvmerge
MKVCOMMAND="mkvmerge --output '${OUTPUT}' --language 0:jpn --track-name '0:${DL_NAME%-*.flv}' --language 1:jpn --track-name '1:${DL_NAME%-*.flv}' '(' '${DL_NAME}' ')' ${SUB_MKV[*]} ${FONT_MKV[*]} --title '${DL_NAME%-*.flv}'"
echo ${MKVCOMMAND}
eval ${MKVCOMMAND}

# Create sum if crc32 is actived by parameter
if [ -n "${CRC32}" ]
then
	rhash -Ce "${OUTPUT}"
fi

# Delete temp dir
rm -r "${TMP_DIR}"

