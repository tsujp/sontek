#!/bin/bash

# based on code by Alexander Klimetschek at
# https://unix.stackexchange.com/a/415155/310780
# and Tom at https://github.com/l3laze/sind

# Renders a text based list of options that can be selected by the
# user using up, down, and enter keys and returns the chosen option.
# Then pages through options, e.g. choice A leads to a submenu.

get_row_structure ()
{
  local c=0
  local p="$#"

  for ae in "$@"; do
    while IFS=':' read -ra aes; do
      ((c++))

      while IFS=',' read -ra aesi; do
        ((c+="${#aesi[@]}"))
      done <<< "${aes[1]}"
    done <<< "$ae"
  done

  # as long as these values never contain spaces we're
  # fine and they wont as they are (small) numbers
  echo $((c+p-1)) 5
}

function select_option
{
  # echo "$PWD"
  for f in "$PWD"/meta-config/*; do
    echo "tis $f"
  done
  # for host in "${!menu[@]}"; do
  #   echo "$host" "${menu[$host]}"
  # done
}

function select_options
{
  local esc=$'\033'
  cursor_blink_on ()  { printf "$esc[?25h"; }
  cursor_blink_off () { printf "$esc[?25l"; }
  cursor_to ()        { printf "$esc[$1;${2:-1}H"; }
  print_section ()    { printf "%s $1" '--'; }
  print_option ()     { printf "     $1 "; }
  print_selected ()   { printf "    $esc[7m $1 $esc[27m"; }
  get_cursor_row ()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }

  key_input () {
    local key

    while true; do
      read -rsN 1
      key=$REPLY

      if [[ "$key" == $'\n' ]]; then echo "enter"; break; fi
      if [[ "$key" == "j" ]]; then echo "up"; break; fi
      if [[ "$key" == "k" ]]; then echo "down"; break; fi

      if [[ "$key" == "${esc}" ]]; then
        # read 2 more bytes in case it's an escape sequence
        read -rsN 2 -t 0.01

        [[ "$REPLY" != "" ]] && key+="$REPLY"
        if [[ "$key" == "${esc}[A" ]]; then echo "up"; break; fi
        if [[ "$key" == "${esc}[B" ]]; then echo "down"; break; fi
        if [[ "$key" == "${esc}" ]]; then echo "esc"; break; fi

        key=;
      fi
    done
  }

  # instructions
  printf "%s\t%s\n\n" "Select option..." "(↑/j or ↓/k, Enter to choose)"

  # initially print empty new lines (scroll down if at bottom of screen)
  # for ae; do printf "\n"; done
  local args
  read -ra args <<< "$@"

  # need start before we start padding and printing
  local startrow=`get_cursor_row`

  read trc test <<< "$(get_row_structure ${args[@]})"
  for ((n=0; n < "$trc"; n++)); do
    printf "\n"
  done

  # record last position as per padding via get_row_structure
  local lastrow=`get_cursor_row`

  # po: print offset
  # oi: option index
  # selected: selected item index
  # vsi: valid selection indices
  local po
  local oi
  local selected=1
  local vsi=()

  # ensure cursor and input echoing back on upon a ctrl+c during read -s
  trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
  cursor_blink_off

  while true; do
    # print options by overwriting the last lines
    # only update option index when we actually print one
    po=0
    oi=1

    # for each array element passed
    for ae in "${args[@]}"; do
      cursor_to $(($startrow + $po))

      # split at `:` giving the category, and options
      while IFS=':' read -ra aise; do
        for i in "${!aise[@]}"; do
          # first index is always the category
          if [ "$i" -eq 0 ]; then
            print_section "$po ${aise[$i]}"
          else
            # split options at `,` giving individual options
            while IFS=',' read -ra aio; do
              for j in "${!aio[@]}"; do
                if [ "$po" -eq "$selected" ]; then
                  print_selected "$po ${aio[$j]}"
                else
                  print_option "$po ${aio[$j]}"
                fi
                ((po++))
                ((oi++))
                cursor_to $(($startrow + $po))
              done
            done <<< "${aise[$i]}"
          fi
          ((po++))
          cursor_to $(($startrow + $po))
        done
      done <<< "$ae"
    done

    # user key control
    case $(key_input) in
      enter)
        break
      ;;
      up)
        ((selected--));
        if [ "$selected" -lt 1 ]; then selected=$(($#)); fi
      ;;
      down)
        ((selected++));
        if [ "$selected" -gt "$trc" ]; then selected=1; fi
      ;;
      *)
      ;;
    esac
  done

  # cursor position back to normal
  cursor_to $lastrow
  printf "\n"
  cursor_blink_on

  return $selected
}
#
