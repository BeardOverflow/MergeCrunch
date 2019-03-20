# MergeCrunch

## What is MergeCrunch?

An application for easily download video content from Crunchyroll combining youtube-dl and mkvmerge. Build a fancy-mkv file with subtitles and fonts attached

## Features

 - Choose between softsub or hardsub (no transcoding!)
 - Choose as you want to download: individual episode, several episodies or full series
 - Choose which quality you want to get (from 240p to 1080p)
 - On softsubbing, attach only one subtitle track or all subtitles track
 - On softsubbing, attach your own fonts to the mkv file
 - On softsubbing, warn if there are fonts missing
 - Spoof your user-agent and cookies file for logging with your account

## How to use this image?

Before starting, you must get your cookies file (to export your Crunchyroll authentication) and know which is your user agent (even if you haven't an account, just for bypassing Cloudflare).

To next, you must prepare a volume where you will place your future downloads. In this folder, you must put your cookies file too. The container path for the downloads will be /downloads

Additionally, you could prepare a volume where you will place custom fonts. (A warning appears while downloading a video when a font is missing). The container path for the fonts will be /fonts

### Examples

    # For first time or receiving updates
    sudo docker pull beardoverflow/mergecrunch

    # Example
    sudo docker run--rm -it \
                -v /home/beardoverflow/downloads:/downloads \
                -v /home/beardoverflow/.fonts:/fonts \
                beardoverflow/mergecrunch \
                -i https://www.crunch... \
                --ua 'PUT HERE YOUR USER AGENT' \
                -c /downloads/cookies.txt \
                -f 720p -s esES

### Configuration

        -i          Input single video URL or playlist URL
        -c          Container path to the cookies file
        -x          Renames the file appending its CRC32 hash at the end of filename
        -f          Video quality. Accepted values: worst, 240p, 360p, 480p, 720p, 1080p, best
        -s          Set the default subtitle track. Required on: --one, --hard. Accepted values: enUS, esES,esLA, frFR, itIT, ptBR, ptPT, deDE, arME, ruRU, jaJP
        --one       On softsubing, it merges only the default subtitle track. If it absents, then all available subtitles track will be merged
        --hard      Forces hardsubing, any subtitle track will be omitted

## How to get your cookies file? (For using your premium account)

Install cookies.txt extension in your browser 

[Firefox](https://addons.mozilla.org/en-US/firefox/addon/cookies-txt/) 

[Chrome](https://chrome.google.com/webstore/detail/cookiestxt/njabckikapfpffapmjgojcnbfjonfjfg)

Enter to the Crunchyroll's website and press the extension's cookie button. Place the file in the same folder where you will put your downloads

## How to know your user agent? (For bypassing CloudFlare)

Ask to google from the same browser

https://www.google.com/search?q=what+is+my+user+agent

## Advance configuration / More information

At https://github.com/BeardOverflow/MergeCrunch

![](https://raw.githubusercontent.com/BeardOverflow/MergeCrunch/master/logo.png)

*Update at Mar 20, 2019*
