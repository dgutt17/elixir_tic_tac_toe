defmodule GameBoard do
  def draw(free_set, x_set, o_set) do
    draw_set = set_union(free_set, x_set, o_set)
    draw_set = chunked_draw_set(draw_set)

    create_board_string(draw_set, "")
  end

  defp set_union(free_set, x_set, o_set) do
    MapSet.union(MapSet.union(free_set, x_set), o_set)
  end
  
  defp chunked_draw_set(draw_set) do
    chunked_draw_set_helper(draw_set, MapSet.new([]))
  end

  defp chunked_draw_set_helper(draw_set, new_set) do
    space_tuple = Enum.at(draw_set, 0)
    if is_tuple(space_tuple) do
      draw_set = MapSet.delete(draw_set, space_tuple)
      new_set = MapSet.put(new_set, space_tuple)
      num = elem(space_tuple, 0)
      if rem(num, 3) == 0 do
        draw_set = MapSet.put(draw_set, new_set)
        new_set = MapSet.new([])
        chunked_draw_set_helper(draw_set, new_set)
      else
        chunked_draw_set_helper(draw_set, new_set)
      end
    else
      draw_set
    end
  end

  defp create_board_string(draw_set, board_string) do 
    if MapSet.size(draw_set) == 0 do
      board_string <> boundary_line <> "\n"
    else
      set = Enum.at(draw_set, 0)
      draw_set = MapSet.delete(draw_set, set)
      new_board_string = board_string <> create_row(set)
      create_board_string(draw_set, new_board_string)
    end
  end

  defp create_row(set, middle_line \\ "") do 
    if MapSet.size(set) == 0 do
      boundary_line <> "\n" <> middle_line <> "|" <> "\n"
    else
      { num, character } = Enum.at(set, 0)
      set = MapSet.delete(set, { num, character })
      new_middle_line = if character == nil, do: create_middle_line(num), else: create_middle_line(character)
      middle_line = middle_line <> new_middle_line
      create_row(set, middle_line)
    end
  end

  defp boundary_line do 
    "+---+---+---+"
  end

  defp create_middle_line(num) do 
    "| #{num} "
  end
end