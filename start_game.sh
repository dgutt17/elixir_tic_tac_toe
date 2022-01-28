#!/bin/bash 
# filenames=`ls ./*.ex`
# for file in $filenames
# do
#    elixirc $file
# done

elixirc game_board.ex
elixirc game_state.ex
elixirc game_logic.ex
elixir game_engine.ex