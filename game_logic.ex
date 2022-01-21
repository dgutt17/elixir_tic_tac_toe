defmodule GameLogic do
  def game_end_state?(free_set, player_set) do 
    horizontal_win(player_set)
    vertical_win(player_set)
    diagonal_win_1(player_set)
    diagonal_win_2(player_set)
    tie(free_set)
  end

  defp horizontal_win(player_set) do
  
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