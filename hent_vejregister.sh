#! /usr/bin/env bash
clear
ZIP_FILENAME="vejregister.zip"
URL="https://cpr.dk/kunder/gratis-download/vejregister-og-udtraeksbeskrivelse"
HTML=$(wget -q -O - $URL)
FILE_URI=
case $OSTYPE in
  darwin*)
    FILE_URI=$(echo $HTML | grep -o -E "/Media.*?"$(date "+%y")".*?\.zip" | head -n 1 | sed 's/^/https:\/\/cpr.dk\//')
  ;;
  linux*)
    FILE_URI=$(echo $HTML | grep -o -P "/Media.*?"$(date "+%y")".*?\.zip" head -n 1 | sed 's/^/https:\/\/cpr.dk\//')
  ;;
esac

if [[ ! -z "$FILE_URI" ]]
then
  echo "1. Henter $FILE_URI ($HOME/$ZIP_FILENAME)"
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
  echo "  3. Indlæs filen med '/app/cprmirror/cprdbimport/cprdbimport.rb -t vejregister -o import -e -f $(realpath $HOME/$FILENAME)'."
  echo "  4. Slet $HOME/$FILENAME når du er færdig."
else
  echo "Kunne ikke finde filen :-("
  exit 1
fi
