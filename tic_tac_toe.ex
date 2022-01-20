defmodule GameEngine do
  def initiate do
    player_1 = IO.gets('First player type your name: ')
    player_2 = IO.gets('Second player type your name: ')
    # set up process to store state
    state_pid = GameState.new(player_1, player_2)
    run(state_pid)
  end

  def run(state_pid) do
    current_state = GameState.get(state_pid)
    free_set = current_state[:free]
    x_set = current_state[:x]
    o_set = current_state[:o]
    # Draw board
    IO.puts(GameBoard.draw(free_set, x_set, o_set))
    # First player picks
    player_1_square = IO.gets("#{current_state[:player_1]} pick your square: ")
    IO.puts("Player 1 number picked: #{player_1_square}")
    # Second Player picks
    # check if anyone won
    # if end state reached -> restart game
    # else repeat
    run(state_pid)
  end
end

defmodule GameLogic do
end

defmodule GameState do 
  # Free store like this: {1, nil}
  # x store like this: {1, :x}
  # y store like this: {1, :y}
  def new(player_1, player_2) do 
    spawn fn -> loop(initial_state(player_1, player_2)) end
  end

  def initial_state(player_1, player_2) do 
    %{ 
      :free => MapSet.new([{1,nil},{2,nil},{3,nil},{4,nil},{5,nil},{6,nil},{7,nil},{8,nil},{9,nil}]),
      :x => MapSet.new,
      :o => MapSet.new,
      :player_1 => player_1,
      :player_2 => player_2
    }
  end

  def set(pid, value) do
    send(pid, {:set, value, self()})
    receive do x -> x end
  end

  def get(pid) do
    send(pid, {:get, self()})
    receive do x -> x end
  end

  defp loop(state) do
    receive do
      {:get, from} ->
        send(from, state)
        loop(state)
      {:set, value, from} ->
        send(from, :ok)
        loop(value)
    end
  end
end

defmodule GameBoard do
  @final_square_number 9
  def draw(free_set, x_set, o_set) do
    draw_set = set_union(free_set, x_set, o_set)
    draw_set = chunked_draw_set(draw_set)

    create_board_string(draw_set, "")
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

  defp set_union(free_set, x_set, o_set) do
    MapSet.union(MapSet.union(free_set, x_set), o_set)
  end

  defp final_square_number do
    @final_square_number
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

  defp create_row(set, middle_line \\ "") do 
    if MapSet.size(set) == 0 do
      boundary_line <> "\n" <> middle_line <> "|" <> "\n"
    else
      { num, character } = Enum.at(set, 0)
      set = MapSet.delete(set, { num, character })
      middle_line = middle_line <> create_middle_line(num)
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

GameEngine.initiate()