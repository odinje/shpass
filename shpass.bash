#! /bin/bash

gpg_cmd="/usr/bin/gpg2"
db_path="/tmp/test.gpg"
view_pass=1

declare -a passwords

function import_gpg_db {
  local i=0

  for pass in $(gpg < $db_path 2>/dev/null) ; do
    passwords[$i]=$pass
    ((i++))
  done
}

function export_gpg_db {
  echo test

}

function return_pass {
  pass_name=$1
   local i=0
   for pass in "${passwords[@]}"; do
     if [[ $pass =~ ^$pass_name/(.+)$ ]]; then
       if [[ $view_pass -eq 1 ]]; then
        echo "${BASH_REMATCH[1]}"
      else
        echo "Copy to clipboard"
      fi
     fi
   done
}

function main {
  import_gpg_db
  return_pass "pass"
  echo $lol
}

main
