#!/bin/bash 
filenames=`ls ./*.ex`
for file in $filenames
do
   elixirc $file
done

elixir game_engine.ex