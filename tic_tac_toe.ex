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
    y_set = current_state[:y]
    # Draw board
    IO.puts(GameBoard.draw(free_set, x_set, y_set))
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
      :y => MapSet.new,
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
  def draw(free_set, x_set, y_set) do
    draw_set = set_union(free_set, x_set, y_set)

    create_board_string(draw_set, "")
  end

  defp create_board_string(draw_set, board_string) do 
    new_board_string = board_string
    if MapSet.size(draw_set) == 0 do
      board_string
    else
      {num, character} = Enum.at(draw_set, 0)
      draw_set = MapSet.delete(draw_set, {num, character})
      value = !character && num || character
      if rem(num, 3) != 0 do
        new_board_string = board_string <> "#{value}" <> "|"
        create_board_string(draw_set, new_board_string)
      else
        if num == final_square_number do 
          new_board_string = board_string <> "#{value}"
          create_board_string(draw_set, new_board_string)
        else
          new_board_string = board_string <> "#{value}" <> "\n"
          create_board_string(draw_set, new_board_string)
        end
      end
    end
  end

  defp set_union(free_set, x_set, y_set) do
    MapSet.union(MapSet.union(free_set, x_set), y_set)
  end

  defp final_square_number do
    @final_square_number
  end
end

GameEngine.initiate()