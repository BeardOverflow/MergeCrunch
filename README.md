![](/logo.png)

***
## What is MergeCrunch?

An application for easily download video content from Crunchyroll combining youtube-dl and mkvmerge. Build a fancy-mkv file with subtitles and fonts attached.

## Docker image

==This is the recommended way to use this application==

Find this project on DockerHub. Its latest release is working fully at March 20th, 2019

**Zero-configuration, for any operating system (Windows, MacOS and Linux). Just pull and run**

More information at https://hub.docker.com/r/beardoverflow/mergecrunch

## Features

 - Choose between softsub or hardsub (no transcoding!)
 - Choose as you want to download: individual episode, several episodies or full series
 - Choose which quality you want to get (from 240p to 1080p)
 - On softsubbing, attach only one subtitle track or all subtitles track
 - On softsubbing, attach your own fonts to the mkv file
 - On softsubbing, warn if there are fonts missing
 - Spoof your user-agent and cookies file for logging with your account

## Usage

In this section, I will illustrate how to use the application with examples:

**Basic example (argument -i):**

Input URL using argument -i. Episode will be downloaded with max resolution in the current directory.

```sh
./mergecrunch.sh -i URL_CRUNCH_HERE
```

**Playlist selection (append # character in input URL):**

For playlist selection, you must append the # character in input URL. After, use selection syntax:

- "N-M" for selecting inclusive range from N to M.
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

**Output file name (argument -o):**

In this example, output file will renamed as "Sket Dance 01 [CRC32_HERE].mkv"

```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -o 'Sket Dance 01.mkv'
```

**CRC32 example (argument -x):**

In this example, CRC32 will be calculated and stored in the filename.

```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x
```

**Format example (argument -f):**

In this example, resolution will be 1280x720. Be careful with this argument, some resolution are availabled for premium users only.

```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p
```

Format | Description
------ | -----------
worst  | The worst resolution available (generally 240p, 360p or 480p)
240p   | 320x240 or 420x240
360p   | 480x360 or 640x360
480p   | 640x360 or 848x480
720p   | 1280x720
1080p  | 1920x1080
best   | The best resolution available (generally 480p, 720p or 1080p)

**Preferred language (argument -s) + Only one language (argument --one):**

Using a preferred language, you set a default subtitle track in your mkv. In this example, set spanish subtitle track as preferred. If you append the --one argument, then esES subtitle track will merged exclusively.

```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p --one -s esES
```

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

**Hardsubbing switch (argument --hard):**

If you wish download a hardsub video instead of merging a soft subtitle track, you can append the --hard argument. Require -s argument and implies --one argument.

```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p --hard -s esES
```

**Account access (argument --cookies and --ua):**

You must get your cookies file (to export your Crunchyroll authentication) and know which is your user agent (bypassing Cloudflare). 

In order to get your cookie file (argument --cookies or -c), I would recommend to use an extension navigator such as [cookies.txt from Chrome Store](https://chrome.google.com/webstore/detail/cookiestxt/njabckikapfpffapmjgojcnbfjonfjfg) or [cookies.txt from Firefox Add-Ons](https://addons.mozilla.org/en-US/firefox/addon/cookies-txt/).
```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p -s esES -o 'Sket Dance 01.mkv' -c cookies.txt
```

In order to get your user agent, [ask to google for getting it using the same browser where you downloaded the cookie file](https://www.google.com/search?q=what+is+my+user+agent)
```
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p -s esES -o 'Sket Dance 01.mkv' -c cookies.txt --ua 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0'
```

## For manual install without docker: Dependencies

==Manual install is not recommended way. Only for Debian an derivates. Just for testing purposes==

Install youtube-dl, python3, fontconfig, mkvmerge and rhash

For getting this dependencies, execute the classic sudo apt-get install.

```sh
sudo apt-get install youtube-dl python3 fontconfig mkvtoolnix rhash
```

Note 1. Latest version of youtube-dl on [all-in-on binary](https://ytdl-org.github.io/youtube-dl/download.html)

Note 2. Latest version of mkvmerge on [custom Bunkus' repository](https://mkvtoolnix.download/downloads.html#debian)

Fontconfig is the engine to search for fonts in your system. If the applicationg warns you about missing fonts, create a folder in your home path called ~/.fonts and put in here the missing fonts

## DEPRECATED OPTIONS

**Premium account (argument -u and -p):**

In this example, I am logging in my premium account. **Deprecated by Crunchyroll’s new verifications.** The console will prompt for username's password.

```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p -s esES -o 'Sket Dance 01.mkv' -u BeardOverflow
```

However, you may specific your password by command line.

```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p -s esES -o 'Sket Dance 01.mkv' -u BeardOverflow -p mysecretpassword
```

**Spoof location (argument -g):**

Similar to choose your preferred language, you can spoof your location in order to download videos from foreign locations. The following example shows a spoof location to Russia and preferred language to American Spanish. **Deprecated by Crunchyroll's new verifications.**

```sh
./mergecrunch.sh -i URL_CRUNCH_HERE -x -f 720p -s esLA -g ruRU
```

## FEEDBACK, BUGS OR CONTRIBUTION

Open an issue in this repository or fork this

## LICENSE
GNU General Public License v2.0
