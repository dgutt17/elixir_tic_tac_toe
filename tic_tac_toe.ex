defmodule GameEngine do
  def initiate do
    player_1 = IO.gets('First player type your name: ')
    player_2 = IO.gets('Second player type your name: ')
    run(player_1, player_2)
  end

  def run(player_1, player_2) do
    # set up process to store state
    state_pid = GameState.new(player_1, player_2)
    current_state = GameState.get(state_pid)
    free_set = current_state[:free]
    x_set = current_state[:x]
    y_set = current_state[:y]
    # Draw board
    GameBoard.draw(free_set, x_set, y_set)

    # First player picks
    # Second Player picks
    # check if anyone won
    # if end state reached -> restart game
    # else repeat
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
  defp draw(free_set, x_set, y_set)
    draw_set = set_union(free_set, x_set, y_set)

    create_board_string(draw_set)
  end

  defp board_string(str \\ "_|_|_\n", times, new_str \\ '') do 
    if times != 0 do
      run(str, times - 1, "#{new_str}#{str}")
    else
      new_str
    end
  end

  defp create_board_string(draw_set) do 
    board_string = ""
    last_value = Enum.at(draw_set, draw_set.size - 1)
    Enum.each(draw_set, fn {num, character} -> 
      value = !character && num || character
      if num % 3 != 0 do
        board_string = board_string <> "#{value}" <> "|"
      else
        if num == last_value do 
          board_string = board_string <> "#{value}"
        else
          board_string = board_string <> "#{value}" <> "\n" <> "___" <> "\n"
        end
      end
    )

    board_string
  end

  defp set_union(free_set, x_set, y_set)
    MapSet.union(y_set, MapSet.union(free_set, x_set))
  end
end

GameEngine.initiate