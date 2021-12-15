defmodule GameEngine do
  def initiate do
    player_1 = IO.gets('First player type your name: ')
    player_2 = IO.gets('Second player type your name: ')
    run(player_1, player_2)
  end

  def run(player_1, player_2) do
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

defmodule GameBoard do
  def draw(str \\ "_|_|_\n", times, new_str \\ '') do 
    if times != 0 do
      run(str, times - 1, "#{new_str}#{str}")
    else
      new_str
    end
  end

  def current_board
    [[], [], []]
  end
end

GameEngine.initiate
