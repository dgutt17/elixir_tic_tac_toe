defmodule GameLogic do
  def game_end_state?(free_set, player_set) do 
    horizontal_win(player_set, 0, false)
    # vertical_win(player_set)
    # diagonal_win_1(player_set)
    # diagonal_win_2(player_set)
    # tie(free_set)
  end

  defp horizontal_win(player_set, index, row_found) do
    IO.puts("In horizontal win")
    tuple1 = Enum.at(player_set, index)
    IO.puts("step 2")
    tuple2 = Enum.at(player_set, index + 1)
    IO.puts("step 3")
    # if rem(num1, 3) == 1 && num1 + 1 == num2 do 
    # IO.puts("step 4")
    #   horizontal_win(player_set, index + 1, true)
    # else
    #     IO.puts("step 5")
    #   if row_found && num1 + 1 == num2 do
    #       IO.puts("step 6")
    #     true
    #   else
    #         IO.puts("step 7")
    #     if index == MapSet.size(player_set) - 1 do
    #         IO.puts("step 8")
    #       false
    #     else
    #         IO.puts("step 9")
    #       horizontal_win(player_set, index + 1, false)
    #     end
    #   end
    # end
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