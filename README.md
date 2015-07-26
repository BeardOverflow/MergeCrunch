# MergeCrunch

***

## Description

MergeCrunch is a small bash script that combine youtube-dl and mkvmerge for get anime.

The main feature is to generate a mkv file with soft-sub and font attachment of downloaded files from **Crunchyroll** streaming.

Tested in Ubuntu 14.04

## Dependencies

You must have installed youtube-dl and mkvmerge, as minimum.

Rhash is recommended for can calculate CRC32 hash sum.

For get this dependencies, execute the classic sudo apt-get install.

```sh
sudo apt-get install youtube-dl
sudo apt-get install mkvtoolnix
sudo apt-get install rhash
```

## Usage

For this section, I ilustrate how to use it with examples:

**Basic example (argument -i):**
```sh
./mergecrunch.sh -i URL_CRUNCH_HERE
```
Episode will be downloaded with max resolution in the current directory

**CRC32 example (argument -c):**
```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -c
```
Same top, but now CRC32 will be calculated and stored in the filename.

**Format example (argument -f):**
```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -c -f 720p
```
Same top, but now resolution will be 1280x720. Be careful with this argument. Check before your available resolution with:
```sh
 youtube-dl -F URL_CRUNCH_HERE
```

**Prefered subtitle language (argument -s):**

This script download all availables subtitles and merged in the file. So, if you want to set a prefered language, you will specific by command line.
```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -c -f 720p -s esES
```
Same top, but now I set Spanish subtitle as prefered.
Argument -s only admit this values:
- "enUS" for  English.
- "esES" for Spanish Castillian.
- "esLA" for Spanish Mejicano.
- "fre" for Français.
- "ita" for Italiano.
- "por" for Português.

**Output file name (argument -o):**
```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -c -f 720p -s esES -o 'Sket Dance 01.mkv'
```
Same top, but now output file will renamed as "Sket Dance 01 [CRC32_HERE].mkv"

## FEEDBACK, BUGS OR CONTRIBUTION
- If you need help, I will be glad to help.
- Report errors is great! Do it, please.
- If you want help with something, I will hear you :)

## LICENSE
GNU General Public License v2.0
