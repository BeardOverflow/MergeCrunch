# MergeCrunch

***

## Description

MergeCrunch is a small bash script (/ironic off) that combines youtube-dl and mkvmerge for getting anime.

The main feature is to generate a pretty mkv file with all availables soft-subtitles from **Crunchyroll** site and after required fonts are attached from fontconfig.

Now support to premium users!!

Now support to playlist URLs and playlist selection!!

Now support to cookies file!!

Now support to spoof your location!!

Now support to spoof your user-agent!!

Now support for hardsub or softsub both!!

==Tested in Ubuntu 16.04 Xenial, 18.04 Bionic and Debian 9 Stretch, 10 Buster==

## Dependencies

You must have installed youtube-dl, fontconfig and mkvmerge, as minimum.

Rhash is recommended for calculating CRC32 hash sum.

For getting this dependencies, execute the classic sudo apt-get install.

Note 1. For youtube-dl, I would recommend to use [nilarimogard's ppa](https://launchpad.net/~nilarimogard/+archive/ubuntu/webupd8).

Note 2. For mkvtoolnix, I would recommend to use [custom Bunkus' repository](https://www.bunkus.org/videotools/mkvtoolnix/downloads.html#ubuntu).

```sh
sudo apt-get install youtube-dl
sudo apt-get install fontconfig
sudo apt-get install mkvtoolnix
sudo apt-get install rhash
```

For solving fonts text dependencies, create a folder in your home dir called ~/.fonts and put here any font text missing.
When you run this script, mkvmerge needs fonts text installed previous in your system for adding it as attachment.

## Usage

For this section, I will ilustrate how to use it with examples:

**Basic example (argument -i):**
```sh
./mergecrunch.sh -i URL_CRUNCH_HERE
```
Episode will be downloaded with max resolution in the current directory

**CRC32 example (argument -x):**
```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x
```
Same top, but now CRC32 will be calculated and stored in the filename.

**Format example (argument -f):**
```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p
```
Same top, but now resolution will be 1280x720. Be careful with this argument, some resolution are availabled for premium users only.

Format | Description
------ | -----------
worst  | The worst resolution available (generally 360p or 480p)
360p   | 480x360 or 640x360
480p   | 640x360 or 848x480
720p   | 1280x720
1080p  | 1920x1080
best   | The best resolution available (generally 480p or 1080p)

**Preferred language (argument -s) + Only one language (argument --one):**

Using a preferred language, you set a default subtitle track in your mkv. Also, title description and default output filename are set according to this language.

```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p --one -s esES
```
Same top, but now I set spanish subtitle track as preferred. If you append the --one argument, then esES subtitle track will merged exclusively.

Language | Description
-------- | -----------
enUS     | Forces American English
esES     | Forces European Spanish
esLA     | Forces American Spanish
frFR     | Forces Français
itIT     | Forces Italiano
ptBR     | Forces Brazilian Português
ptPT     | Forces European Português
deDE     | Forces Deutsch
arME     | Forces العربية
ruRU     | Forces Русский
jaJP     | Forces 日本語

**Hardsub switch (argument --hard):**

If you wish download a hardsub video instead of merging a soft subtitle track, you can append the --hard argument. Require -s argument and implies --one argument.

```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p --hard -s esES
```

**Spoof location (argument -g):**

Similar to choose your preferred language, you can spoof your location in order to download videos from foreign locations. The following example shows a spoof location to Russia and preferred language to American Spanish.

Also, default output filename will be in russian.

```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p -s esLA -g ruRU
```

**Output file name (argument -o):**
```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p -s esES -o 'Sket Dance 01.mkv'
```
Same top, but now output file will renamed as "Sket Dance 01 [CRC32_HERE].mkv"


**Premium account (argument -u and -p OR argument -c):**
```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p -s esES -o 'Sket Dance 01.mkv' -u BeardOverflow
```
Same top, but I am logging in my premium account. The console will prompt for username's password.

However, you may specific your password by command line.
```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p -s esES -o 'Sket Dance 01.mkv' -u BeardOverflow -p mysecretpassword
```

Sometimes, the login access could fail using argument -u (because youtube-dl is outdated). In this case, you could use a cookie file. In order to get your cookie file, I would recommend to use an extension navigator such as [cookies.txt from Chrome Store](https://chrome.google.com/webstore/detail/cookiestxt/njabckikapfpffapmjgojcnbfjonfjfg) or [cookies.txt from Firefox Add-Ons](https://addons.mozilla.org/en-US/firefox/addon/cookies-txt/).
```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p -s esES -o 'Sket Dance 01.mkv' -c cookies.txt
```

With the latest changes in CR, you must set your user-agent (argument --ua) and cookies file together. [Ask to google for getting it using the same browser where you downloaded the cookie file](https://www.google.com/search?q=what+is+my+user+agent)
```
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p -s esES -o 'Sket Dance 01.mkv' -c cookies.txt --ua 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0'
```

**Playlist selection (append # character in input URL):**

For playlist selection, you must append the # character in input URL. After, according to selection syntaxis:
- "N-M" for select range from N to M.
- "N" for simple selection.
- "," as separator for multiple selections.

Example #1. Select IDs items from 12 to 20.
```sh
./mergecrunch.sh -i URL_PLAYLIST_CRUNCH_HERE#12-20
```

Example #2. Select ID item 5.
```sh
./mergecrunch.sh -i URL_PLAYLIST_CRUNCH_HERE#5
```

Example #3. Select IDs items from 12 to 20 and also 2, 5, 23 to 30.
```sh
./mergecrunch.sh -i URL_PLAYLIST_CRUNCH_HERE#12-20,2,5,23-30
```


## FEEDBACK, BUGS OR CONTRIBUTION
- If you need some help, I will be glad to help you.
- Please report all errors, getting them is great.
- If you want to help me with something please create a pull request :)

## LICENSE
GNU General Public License v2.0



