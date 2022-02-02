defmodule GameLogic do
  def game_end_state?(free_set, player_set) do 
    horizontal_win(player_set, 0, false)
    # vertical_win(player_set)
    # diagonal_win_1(player_set)
    # diagonal_win_2(player_set)
    # tie(free_set)
  end

  defp horizontal_win(player_set, index, row_length) do 
    if MapSet.size(player_set) == 0 do
      false
    else
      {num, char} = Enum.at(player_set, index)
      {num2, char2} = Enum.at(player_set, index - 1)

      cond do
        row_length == 2 -> 
          true
        index == MapSet.size(player_set) - 1 -> 
          false
        rem(num, 3) == 1 ->
          horizontal_win(player_set, index + 1, 1)
        num - 1 == num2 ->
          horizontal_win(player_set, index + 1, row_length + 1)
        true -> 
          horizontal_win(player_set, index + 1, 0)
      end
    end
  end

  defp vertical_win(player_set) do 
  end

  defp diagonal_win_1(player_set) do
  end

  defp diagonal_win_2(player_set) do
  end

  defp tie(free_set) do 
  end
end