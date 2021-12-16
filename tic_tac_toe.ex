defmodule GameEngine do
  def initiate do
    player_1 = IO.gets('First player type your name: ')
    player_2 = IO.gets('Second player type your name: ')
    run(player_1, player_2)
  end

  def run(player_1, player_2) do
    # set up process to store state
    # Draw board
    GameBoard.draw

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
  def new do 
    spawn fn -> loop(initial_state()) end
  end

  def initial_state do 
    %{ 
      :free => MapSet.new([{1,nil},{2,nil},{3,nil},{4,nil},{5,nil},{6,nil},{7,nil},{8,nil},{9,nil}]),
      :x => MapSet.new,
      :o => MapSet.new 
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
  def draw(str \\ "_|_|_\n", times, new_str \\ '') do 
    if times != 0 do
      run(str, times - 1, "#{new_str}#{str}")
    else
      new_str
    end
  end
end

GameEngine.initiate