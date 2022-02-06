defmodule GameLogic do
  def won_the_game?(player_set) do 
    {num, char} = Enum.at(player_set, 0)
    horizontal_win(player_set, 0) || vertical_win(player_set, 0) || diagonal_win(player_set, char)
  end

  def tie?(free_set) do 
    MapSet.size(free_set) == 0
  end

  defp horizontal_win(player_set, index) do 
    if MapSet.size(player_set) == 0 do
      false
    else
      {num, char} = Enum.at(player_set, index)
      cond do
        index == MapSet.size(player_set) - 1 -> 
          false
        rem(num, 3) != 1 ->
          false
        correct_row_length?(player_set, num, char, 1) ->
          true
        true -> 
          horizontal_win(player_set, index + 1)
      end
    end
  end

  defp correct_row_length?(player_set, num, char, row_length) do 
    cond do 
      row_length == 3 -> 
        true
      MapSet.member?(player_set, {num + 1, char}) ->
        correct_row_length?(player_set, num + 1, char, row_length + 1)
      true ->
        false
    end
  end

  defp vertical_win(player_set, index) do 
    if MapSet.size(player_set) == 0 do
      false
    else
      {num, char} = Enum.at(player_set, index)
      cond do 
        index == MapSet.size(player_set) - 1 -> 
          false
        num > 3 -> 
          false
        correct_column_length?(player_set, num, char, 1) ->
          true
        true -> 
          vertical_win(player_set, index + 1)
      end
    end
  end

  defp correct_column_length?(player_set, num, char, column_length) do
    cond do 
      column_length == 3 -> 
        true
      MapSet.member?(player_set, {num + 3, char}) ->
        correct_column_length?(player_set, num + 3, char, column_length + 1)
      true -> 
        false
    end
  end

  defp diagonal_win(player_set, char) do
    tuple_1 = MapSet.member?(player_set, {1, char})
    tuple_3 = MapSet.member?(player_set, {3, char})
    tuple_5 = MapSet.member?(player_set, {5, char})
    tuple_7 = MapSet.member?(player_set, {7, char})
    tuple_9 = MapSet.member?(player_set, {9, char})
    
    (tuple_1 && tuple_5 && tuple_9) || (tuple_3 && tuple_5 && tuple_7)
  end
end