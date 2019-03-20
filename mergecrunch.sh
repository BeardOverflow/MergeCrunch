#!/bin/bash

# Title:       MergeCrunch
# Description: Download from Crunchyroll and generate a pretty mkv file with all video, subtitles and fonts merged.
# Author:      José Ángel Pastrana Padilla
# Email:       japp0005@red.ujaen.es
# Last update: 2019-03-20
# Revision:    24

# DEPENDENCIES:

# - fontconfig (and enough fonts installed in your system. If any font is missing, put it inside your fonts folder ~/.fonts).
# - youtube-dl
# - mkvmerge
# - rhash (recommend, but it is not required).

# DEFAULT PARAMETERS.

# This argument sets a premium username Crunchyroll account.
# By command line, it is "-u username" or "--username username"
USERNAME="" # Default: "" (Means guest session).

# This argument sets a password for your username Crunchyroll account.
# By command line, it is "-p password" or "--password password"
PASSWORD="" # Default: "" (Means guest session if username is not specific).

# This argument sets where cookies file is stored.
# By command line, it is "-c cookies.txt" or "--cookies cookies.txt"
COOKIES="" # Default: "" (Means not using previous cookies).

# This argument computes a CRC32 sum to downloaded file and renames it in order to append the hash.
# By command line, it can be actived by "-x" or "--crc32"
CRC32="" # Default: "" (Means disabled). Change to "YES" for always active

# This argument sets video resolution.
# By command line, it is "-f value" or "--format value".
# Default: "" (Means best resolution).
# Change to other value as "worst", "240p", "360p", "480p", "720p", "1080p", "best".
FORMAT=""

# This argument sets user agent.
# By command line, it is, for example, "--ua 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0'"
USER_AGENT=""

# Only the language specified on SUB_DEFAULT (-s) will be merged
# By command line, it is, for example, "--one -s esES"
ONE_SUBTITLE=""  # Default: "" (Means disabled). Change to "YES" for always active

# Ship hard subtitle specified by SUB_DEFAULT (-s). Implies ONE_SUBTITLE
# By command line, it is, for example, "--hard -s esES"
HARD_SUBTITLE="" # Default: "" (Means disabled). Change to "YES" for always active

# For further references: ISO 639 and mkvmerge --list-languages
# This argument sets default track subtitle if your player doesn't set this field.
# By command line, use "-s value" or "--sub_default value"
# Default: "" (Means english).
# Value to "enUS" forces American English.
# Value to "esES" forces European Spanish.
# Value to "esLA" forces American Spanish.
# Value to "frFR" forces Français.
# Value to "itIT" forces Italiano.
# Value to "ptBR" forces Brazilian Português.
# Value to "ptPT" forces European Português.
# Value to "deDE" forces Deutsch.
# Value to "arME" forces العربية.
# Value to "trTR" forces Türkçe
# Value to "ruRU" forces Русский.
# Value to "jaJP" forces 日本語.
SUB_DEFAULT=""

# This argument spoofs X-Forwarded-For using a fake IP
# By command line, it is "-g US" or "--geo enUS"
# Default: "" (Means your actual IP country)
# Value to "enUS" forces USA.
# Value to "esES" forces España.
# Value to "esLA" forces México.
# Value to "frFR" forces France.
# Value to "itIT" forces Italia.
# Value to "ptBR" forces Brasil.
# Value to "ptPT" forces Brasil.
# Value to "deDE" forces Deutschland.
# Value to "arME" forces العربية.
# Value to "trTR" forces Türkiye
# Value to "ruRU" forces Россия.
# Value to "jaJP" forces 日本.
GEO_COUNTRY="" # Default: "" (Means your actual IP country)

# NEED THIS VARIABLES...
TMP_DIR="/tmp/${$}"
DEST_DIR="$(pwd)"
declare -A FORMAT_SUP
FORMAT_SUP["worst"]="worst[format_id !*= hardsub]"
FORMAT_SUP["240p"]="best[format_id !*= hardsub][height=240]"
FORMAT_SUP["360p"]="best[format_id !*= hardsub][height=360]"
FORMAT_SUP["480p"]="best[format_id !*= hardsub][height=480]"
FORMAT_SUP["720p"]="best[format_id !*= hardsub][height=720]"
FORMAT_SUP["1080p"]="best[format_id !*= hardsub][height=1080]"
FORMAT_SUP["240"]="best[format_id !*= hardsub][height=240]"
FORMAT_SUP["360"]="best[format_id !*= hardsub][height=360]"
FORMAT_SUP["480"]="best[format_id !*= hardsub][height=480]"
FORMAT_SUP["720"]="best[format_id !*= hardsub][height=720]"
FORMAT_SUP["1080"]="best[format_id !*= hardsub][height=1080]"
FORMAT_SUP["best"]="best[format_id !*= hardsub]"
FORMAT_SUP["hard-worst"]="worst[format_id *= hardsub]"
FORMAT_SUP["hard-240p"]="best[format_id *= hardsub][height=240]"
FORMAT_SUP["hard-360p"]="best[format_id *= hardsub][height=360]"
FORMAT_SUP["hard-480p"]="best[format_id *= hardsub][height=480]"
FORMAT_SUP["hard-720p"]="best[format_id *= hardsub][height=720]"
FORMAT_SUP["hard-1080p"]="best[format_id *= hardsub][height=1080]"
FORMAT_SUP["hard-240"]="best[format_id *= hardsub][height=240]"
FORMAT_SUP["hard-360"]="best[format_id *= hardsub][height=360]"
FORMAT_SUP["hard-480"]="best[format_id *= hardsub][height=480]"
FORMAT_SUP["hard-720"]="best[format_id *= hardsub][height=720]"
FORMAT_SUP["hard-1080"]="best[format_id *= hardsub][height=1080]"
FORMAT_SUP["hard-best"]="best[format_id *= hardsub]"
declare -A SUB_LANG
SUB_LANG["enUS","tag"]="eng"
SUB_LANG["enUS","cty"]="English (USA)"
SUB_LANG["enUS","geo"]="US"
SUB_LANG["esES","tag"]="spa"
SUB_LANG["esES","cty"]="Español (España)"
SUB_LANG["esES","geo"]="ES"
SUB_LANG["esLA","tag"]="spa"
SUB_LANG["esLA","cty"]="Español (México)"
SUB_LANG["esLA","geo"]="LA"
SUB_LANG["frFR","tag"]="fre"
SUB_LANG["frFR","cty"]="Français (France)"
SUB_LANG["frFR","geo"]="FR"
SUB_LANG["itIT","tag"]="ita"
SUB_LANG["itIT","cty"]="Italiano (Italia)"
SUB_LANG["itIT","geo"]="IT"
SUB_LANG["ptBR","tag"]="por" # Should be bzs according to ISO-639-3, but mkvmerge only supports ISO-639-1/2
SUB_LANG["ptBR","cty"]="Português (Brasil)"
SUB_LANG["ptBR","geo"]="BR"
SUB_LANG["ptPT","tag"]="por"
SUB_LANG["ptPT","cty"]="Português (Portugal)"
SUB_LANG["ptPT","geo"]="PT"
SUB_LANG["deDE","tag"]="ger"
SUB_LANG["deDE","cty"]="Deutsch (Deutschland)"
SUB_LANG["deDE","geo"]="DE"
SUB_LANG["arME","tag"]="ara"
SUB_LANG["arME","cty"]="العربية"
SUB_LANG["arME","geo"]="ME"
SUB_LANG["trTR","tag"]="tur"
SUB_LANG["trTR","cty"]="Türkçe (Türkiye)"
SUB_LANG["trTR","geo"]="TR"
SUB_LANG["ruRU","tag"]="rus"
SUB_LANG["ruRU","cty"]="Русский (Россия)"
SUB_LANG["ruRU","geo"]="RU"
SUB_LANG["jaJP","tag"]="jap"
SUB_LANG["jaJP","cty"]="日本語 (日本)"
SUB_LANG["jaJP","geo"]="JP"

# Turn off substitution history
# Sad example: echo "blabla!.mkv"
set +H

# A SIMPLES FUNCTIONS FOR COLOURED OUTPUT TEXT
function greencon {
	echo -e "\e[1m\e[92m${*}\e[0m"
}
function redcon {
	echo -e "\e[1m\e[91m${*}\e[0m"
}
function yellowcon {
	echo -e "\e[1m\e[93m${*}\e[0m"
}


# HANDLE SIGNAL
function handlesignal {
	if [ -d "${TMP_DIR}" ]
	then
		rm -r "${TMP_DIR}"
	fi
	if [ -f "${TMP_FILE}" ]
	then
		rm "${TMP_FILE}"
	fi
	if [ ${#} -eq 0 ]
	then
		redcon "Signal received! Abort all and exit!"
	else
		redcon "${*}"
	fi
	exit -1
}
trap handlesignal SIGHUP SIGINT SIGTERM


# CHECKING...
if [ ${#} -eq 0 ]
then
	echo "Error. MergeCrunch needs a input URL as parameter."
	echo "Syntaxis:"
	echo "	${0} -i URL [-f format] [-s force] [-c] [-o output]"
	exit -1
fi

if [ -z "$(which fc-list)" ]
then
	echo "Please, first install fontconfig package."
	echo "Run 'sudo apt-get install fontconfig' and try again."
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
	echo "Run 'sudo apt-get install mkvtoolnix' and try again."
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
			if [ "${2:0:1}" = "/" ]
			then
				OUTPUT="${2}"
			else
				OUTPUT="${DEST_DIR}/${2}"
			fi
			if [ -z "$(echo ${OUTPUT##*/} | grep "\.")" ] # Output given is a directory.
			then
				DEST_DIR="$(readlink -f "${OUTPUT}")"
				unset OUTPUT
			fi
			shift
		;;
		-u|--username)
			USERNAME="${2}"
			shift
		;;
		-p|--password)
			PASSWORD="${2}"
			shift
		;;
		-c|--cookies)
			COOKIES="$(readlink -f "${2}")"
			sed -i 's/^#HttpOnly_//' "${COOKIES}"
			shift
		;;
		-x|--crc32)
			if [ -z "$(which rhash)" ]
			then
				echo "Using ${1} argument, it needs rhash installed."
				echo "Run 'sudo apt-get install rhash' and try again."
				exit -1
			fi
			CRC32="YES"
		;;
		-f|--format)
			if [ -z "${FORMAT_SUP["${2,,}"]}" ]
			then
				echo "Error. Format specification for ${2} not found."
			        echo "Edit this script and add it in FORMAT_SUP array."
			        exit -1
			fi
			FORMAT="${2,,}"
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
		-g|--geo)
			if [ -z "${SUB_LANG["${2}","geo"]}" ]
			then
				echo "Error. Geolocation specification for ${2} not found."
				echo "Edit this script and add it in SUB_LANG array."
				exit -1
			fi
			GEO_COUNTRY="${2}"
			shift
		;;
		--ua|--user-agent)
			USER_AGENT="${2}"
			shift
		;;
		--one)
			ONE_SUBTITLE="YES"
		;;
		--hard)
			HARD_SUBTITLE="YES"
		;;
		*)
			echo "Error. Unexpected argument: ${1}"
			exit -1
		;;
	esac
	shift
done
if [ -n "${USERNAME}" ]
then
	USERNAME="-u ${USERNAME}"
fi
if [ -n "${PASSWORD}" ]
then
	PASSWORD="-p ${PASSWORD}"
fi
if [ -n "${COOKIES}" ]
then
	WGET_COOKIES="--load-cookies \"${COOKIES}\""
	COOKIES="--cookies '${COOKIES}'"
else
	yellowcon "Warning. Crunchyroll will enable future restrictions soon. If there is any problem while downloading, try to specify a cookies file (for example, -c cookies.txt). More info at README.md"
fi
if [ -n "${HARD_SUBTITLE}" ] && [ -z "${SUB_DEFAULT}" ]
then
	echo "Error. If you use --hard option, then you must specify the default subtitle language using -s option"
	exit -1
fi
if [ -n "${FORMAT}" ]
then
	if [ -n "${HARD_SUBTITLE}" ]
	then
		FORMAT="-f '${FORMAT_SUP["hard-${FORMAT}"]}[format_id *= -${SUB_DEFAULT}-]'"
	else
		FORMAT="-f '${FORMAT_SUP["${FORMAT}"]}'"
	fi
else
	if [ -n "${HARD_SUBTITLE}" ]
	then
		FORMAT="-f '[format_id *= -${SUB_DEFAULT}-]'"
	fi
fi
if [ -n "${SUB_DEFAULT}" ]
then
	HEADER="--add-header Accept-Language:${SUB_DEFAULT}"
fi
if [ -n "${GEO_COUNTRY}" ]
then
	GEO_COUNTRY="--geo-bypass-country ${SUB_LANG["${GEO_COUNTRY}","geo"]}"
	FAKE_IP="$(youtube-dl -s -v ${GEO_COUNTRY} "${INPUT}" 2>&1 | grep -m1 'fake IP' | xargs | cut -d' ' -f5)"
	WGET_GEO_COUNTRY="--header \"X-Forwarded-For:${FAKE_IP}\""
	yellowcon "Using fake ip: $FAKE_IP"
fi
if [ -n "${USER_AGENT}" ]
then
	WGET_USER_AGENT="--user-agent \"${USER_AGENT}\""
	USER_AGENT="--user-agent '${USER_AGENT}'"
else
	yellowcon "Warning. Crunchyroll will enable future restrictions soon. If there is any problem while downloading, try to specify an user-agent (for example, --ua 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0'). More info at README.md"
fi
if [ -n "${ONE_SUBTITLE}" ]
then
	if [ -z "${SUB_DEFAULT}" ]
	then
		echo "Error. If you use --one option, then you must specify the default subtitle language using -s option"
		exit -1
	fi
fi

# MAIN...
# Check playlist...
TMP_FILE="/tmp/${$}-check"
eval wget \"${INPUT}\" ${WGET_USER_AGENT} ${WGET_COOKIES} ${WGET_GEO_COUNTRY} -qO \"${TMP_FILE}\"
if [ -z "$(cat "${TMP_FILE}" | grep '"type":"error"')" ] # Check URL errors
then
if [ -z "$(cat "${TMP_FILE}" | grep 'link rel="index"')" ] # Input URL is a playlist
then
	greencon "[Analyze] INPUT URL IS A PLAYLIST. ENQUEUING..."
	if [ -n "${OUTPUT}" ]
	then
		handlesignal "Output argument must be a directory when input argument is a playlist URL."
	fi
	SEGMENT="${INPUT##*#}"
	if [ -n "${SEGMENT}" ] && [ "${INPUT}" != "${SEGMENT}" ]
	then
		while read -r line
		do
			if [ -n "$(echo "${line}" | grep "-")" ]
			then
				SELECTION+="$(seq -s " " ${line/-/ }) "
			else
				SELECTION+="${line} "
			fi
		done <<< "$(echo -e "${SEGMENT//,/\\n}")"
		greencon "---> SELECTED ID ITEMS FROM THIS PLAYLIST: ${SELECTION} <---"
	fi
	c=0
	while read -r line
	do
		c=$((c+1))
		inputs+=("http://www.crunchyroll.com${line}")
		if [ -z "${SELECTION}" ] || [ -n "$(echo -e "${SELECTION// /\\n}" | grep "^${c}$")" ]
		then
			echo -en "\e[1m[Selected] \e[42m"
		else
			echo -n "[Not Selected] "
		fi
		echo -e "ID: ${c}, URL: http://www.crunchyroll.com${line}\e[0m"
	done <<< "$(tac "${TMP_FILE}" | grep -A1 --no-group-separator 'portrait-element block-link titlefix episode' | grep -v 'portrait-element block-link titlefix episode' | cut -d'"' -f2)"
else
	greencon "[Analyze] INPUT URL IS A SIMPLE URL. ENQUEUING..."
	inputs+=("${INPUT}")
	echo "${INPUT} ready!"
fi
else
	eval youtube-dl -s ${USERNAME} ${PASSWORD} ${COOKIES} ${USER_AGENT} ${FORMAT} ${HEADER} ${GEO_COUNTRY} ${INPUT}
	handlesignal "Exitting due to an error in input URL..."
fi
rm -r "${TMP_FILE}"

# LOOP FOR PLAYLIST
c=0
for INPUT in "${inputs[@]}"
do
	c=$((c+1))
	if [ -z "${SELECTION}" ] || [ -n "$(echo -e "${SELECTION// /\\n}" | grep "^${c}$")" ]
	then
	(
	# A line extra for to format console output :P
	echo 

	# Prepare temp dir
	mkdir -p "${TMP_DIR}"
	cd "${TMP_DIR}"

	# Get Crunchyroll file
	greencon "STEP 0. QUEUE INPUT URL #${c}."
	echo "${INPUT}"
	greencon "STEP 1. GET CRUNCHYROLL STREAMING DOWNLOAD."
	echo youtube-dl --no-warnings --no-continue --no-part --all-subs ${USERNAME} ${PASSWORD} ${COOKIES} ${USER_AGENT} ${FORMAT} ${HEADER} ${GEO_COUNTRY} ${INPUT}
	eval youtube-dl --no-warnings --no-continue --no-part --all-subs ${USERNAME} ${PASSWORD} ${COOKIES} ${USER_AGENT} ${FORMAT} ${HEADER} ${GEO_COUNTRY} ${INPUT}
	if [ ${?} -ne 0 ]
	then
		handlesignal "Failed to get streaming! Exitting..."
	fi

	# Prepare output filename
	DL_NAME="$(ls *.flv *.mp4 2>/dev/null)"
	if [ -z "${OUTPUT}" ]
	then
		OUTPUT="${DEST_DIR}/${DL_NAME%-*}.mkv"
	fi

	# Prepare subtitles downloaded for will merge to output file
	greencon "STEP 2. CHECKING AVAILABLE SUBTITLES."
	if ls *.ass >/dev/null 2>/dev/null
	then
		if [ -n "${HARD_SUBTITLE}" ]
		then
			yellowcon "Hard subtitle enabled. Skip this step."
		else
		for each in *.ass
		do
			sl=${each%.ass}
			sl=${sl##*.}
			if [ -z "${SUB_LANG["${sl}","tag"]}" ] || [ -z "${SUB_LANG["${sl}","cty"]}" ]
			then
				yellowcon "WARNING: UNABLE TO UNDERSTAND <<< ${sl} >>>. EDIT THIS SCRIPT AND ADD IT IN SUB_LANG ARRAY. WHILE I WILL IGNORE IT."
				continue
			fi
			unset def
			if [ "${SUB_DEFAULT}" = "${sl}" ]
			then
				def="--default-track 0:yes --forced-track 0:yes"
			elif [ -n "${ONE_SUBTITLE}" ]
			then
				continue
			fi
			echo "Found ${SUB_LANG["${sl}","cty"]} subtitle!... Ready."
			SUB_MKV+=("--language \"0:${SUB_LANG["${sl}","tag"]}\" --track-name \"0:${SUB_LANG["${sl}","cty"]}\" ${def} '(' \"${each}\" ')'")
		done
		fi
	else
		yellowcon "Not found any subtitle track."
	fi

	# Searching for fonts attachments
	greencon "STEP 3. CHECKING AVAILABLES ATTACHMENT FONTS TEXT."
	if ls *.ass >/dev/null 2>/dev/null
	then
		if [ -n "${HARD_SUBTITLE}" ]
		then
			yellowcon "Hard subtitle enabled. Skip this step."
		else
		for each in *.ass
		do
			while read -r line
			do
			        fonts+=("${line}")
			done <<< "$(cat "${each}" | grep "^Style:" | cut -d"," -f2 | sort -u)"
		done

		while read -r line
		do
			queryfc="$(fc-match "${line}")"
			foundName="$(echo ${queryfc} | cut -d'"' -f2)"
			foundStyle="$(echo ${queryfc} | cut -d'"' -f4)"
			if [ "${foundName,,}" = "${line,,}" ] || [ "$(echo "${foundName,,} ${foundStyle,,}" | xargs)" = "$(echo "${line,,}" | xargs)" ]
			then
			        echo "Found ${line} font!... Ready."
			else
				yellowcon "WARNING: REQUEST FONT <<< ${line} >>> IS NOT INSTALLED IN YOUR SYSTEM. PLEASE, INSTALL IT AND TRY AGAIN. WHILE I WILL BE USE <<< ${foundName} >>>."
			fi
			FONT_MKV+=("--attach-file \"$(fc-match -v "${line}" | grep "file:" | cut -d'"' -f2)\"")
		done <<< "$(printf "%s\n" "${fonts[@]}" | sort -u)"
		fi
	else
		yellowcon "Not required any attachment."
	fi

	# Launch mkvmerge
	greencon "STEP 4. TIME FOR MERGING ALL TO MKV FILE."
	MKVCOMMAND="mkvmerge --output \"${OUTPUT}\" --language 0:jpn --track-name \"0:${DL_NAME%-*}\" --language 1:jpn --track-name \"1:${DL_NAME%-*}\" '(' \"${DL_NAME}\" ')' ${SUB_MKV[*]} ${FONT_MKV[*]} --title \"${DL_NAME%-*}\" -q"
	eval "${MKVCOMMAND//\`/\\\`}"
	case "${?}" in
		0) echo "Merge completed!";;
		1) yellowcon "Merge completed with WARNINGS!";;
		2) handlesignal "Merge failed! Exitting...";;
	esac

	# Create sum if crc32 is actived by parameter
	if [ -n "${CRC32}" ]
	then
		greencon "STEP 5. CALCULATING CRC32 HASH."
		echo "CRC32 sum value is: $(rhash --simple -Ce "${OUTPUT}" | cut -d" " -f1)"
	fi

	# Final message
	greencon "FINISH!\e[0m\e[1m Output file generated: $(ls -t "${OUTPUT%.mkv}"* | head -n1)"

	# Delete temp dir
	rm -r "${TMP_DIR}"
	)
	fi
done

