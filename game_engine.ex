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
    current_state = get_state(state_pid)
    free_set = current_state[:free]
    x_set = current_state[:x]
    o_set = current_state[:o]

    IO.puts(GameBoard.draw(free_set, x_set, o_set))

    player_1_square = IO.gets("#{current_state[:player_1]} pick your square: ")
    player_1_square = elem(Integer.parse(player_1_square), 0)
    x_set = MapSet.put(x_set, {player_1_square, "X"})
    free_set = MapSet.delete(free_set, {player_1_square, nil})

    IO.puts(GameBoard.draw(free_set, x_set, o_set))

    player_2_square = IO.gets("#{current_state[:player_2]} pick your square: ")
    player_2_square = elem(Integer.parse(player_2_square), 0)
    o_set = MapSet.put(o_set, {player_2_square, "O"})
    free_set = MapSet.delete(free_set, {player_2_square, nil})
    new_state = %{
      :free => free_set,
      :x => x_set,
      :o => o_set,
      :player_1 => current_state[:player_1],
      :player_2 => current_state[:player_2]
    }
    set_state(state_pid, new_state)
    # check if anyone won
    # if end state reached -> restart game
    # else repeat
    run(state_pid)
  end

  defp get_state(state_pid) do 
    GameState.get(state_pid)
  end

  defp set_state(state_pid, state) do 
    GameState.set(state_pid, state)
  end
end

GameEngine.initiate()