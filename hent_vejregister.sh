#! /usr/bin/env bash
clear
ZIP_FILENAME="vejregister.zip"
URL="https://cpr.dk/kunder/gratis-download/vejregister-og-udtraeksbeskrivelse"
FILE_URI=$(wget -q -O - $URL | grep -o -E "/Media.*?"$(date "+%y")".*?\.zip" | sed 's/^/https:\/\/cpr.dk\//')

if [[ ! -z "$FILE_URI" ]]
then
  echo "1. Henter $FILE_URI ($HOME/$ZIP_FILENAME)."
  rm -f $HOME/$ZIP_FILENAME
  wget -q $FILE_URI -O $HOME/$ZIP_FILENAME
  FILENAME=$(zipinfo -1 $HOME/$ZIP_FILENAME)
  echo "2. Udpakker $HOME/$FILENAME ($HOME/$ZIP_FILENAME)."
  unzip -qq -o $HOME/$ZIP_FILENAME -d $HOME
  echo "3. Fjerner $HOME/$ZIP_FILENAME."
  rm -f $HOME/$ZIP_FILENAME
  echo
  tput bold
  echo "TODO:"
  tput sgr0
  echo "  1. Tjek at datostemplet på .zip-filen rigtigt ud."
  echo "  2. HUSK TMUX!"
  echo "  3. Indlæs filen med '/app/cprmirror/cprdbimport/cprdbimport.rb -t vejregister -o import -e -f $(realpath $HOME/$FILENAME)'"
  echo "  4. Evt. slet $HOME/$FILENAME"
else
  echo "Kunne ikke finde filen :-("
  exit 1
fi
