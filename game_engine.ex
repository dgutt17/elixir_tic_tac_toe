defmodule GameEngine do
  import GameBoard
  import GameState
  import GameLogic
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

GameEngine.initiate()