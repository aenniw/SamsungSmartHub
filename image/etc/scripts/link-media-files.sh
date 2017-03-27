#!/bin/sh

case $1 in
"-a" | "--add" )
    for dir in ${2%/}/* ; do
        if [ ! -d ${dir} ]; then
            continue;
        fi
        DIR=`echo ${dir} | awk '{print toupper($0)}'`
        case "${DIR#/*/*/}" in
        "FILMS" | "MOVIES")
            test -d /media/Movies/ || mkdir /media/Movies/
            chmod 777 /media/Movies/
            ln -s ${dir}/* /media/Movies/
          ;;
        "SERIES")
            test -d /media/Series/ || mkdir /media/Series/
            chmod 777 /media/Series/
            ln -s ${dir}/* /media/Series/
          ;;
        "MP3" | "MUSIC")
            test -d /media/Music/ || mkdir /media/Music/
            chmod 777 /media/Music/
            ln -s ${dir}/* /media/Music/
          ;;
        "PHOTOS")
            test -d /media/Photo/ || mkdir /media/Photo/
            chmod 777 /media/Photo/
            ln -s ${dir}/* /media/Photo/
          ;;
        "NEW" | "DOWNLOADED")
            test -d /media/Downloaded/ || mkdir /media/Downloaded/
            chmod 777 /media/Downloaded/
            ln -s ${dir}/* /media/Downloaded/
          ;;
        *)
            echo "Skip linking ${dir}";
          ;;
        esac
    done
  ;;
"-r" | "--remove" )
    for dir in /media/Downloaded /media/Photo /media/Music /media/Series /media/Movies ; do
        for x in ${dir}/* ${dir}/.[!.]* ${dir}/..?*; do
            if [ -L "$x" ] && ! [ -e "$x" ]; then
                rm -- "$x";
            fi;
        done
    done
  ;;
* )
    echo "Usage:: options PATH
            -a --add        -- adds new links
            -r --remove     -- removes used links
         "
  ;;
esac