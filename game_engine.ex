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

  def run(state_pid, skip_player_1? \\ false) do
    {current_state, free_set, x_set, o_set} = get_state(state_pid)

    # Player 1
    unless skip_player_1? do
      IO.puts(GameBoard.draw(free_set, x_set, o_set))
      player_1_square = IO.gets("#{current_state[:player_1]} pick your square: ")
      player_1_square = elem(Integer.parse(player_1_square), 0)
      if !MapSet.member?(free_set, {player_1_square, nil}) do 
        run(state_pid)
      end
      x_set = MapSet.put(x_set, {player_1_square, "X"})
      free_set = MapSet.delete(free_set, {player_1_square, nil})
      set_state(state_pid, new_state(free_set, x_set, o_set, current_state))
      # Check if Player 1 has won
      won_the_game?(x_set, current_state[:player_1])

      tie_game?(free_set)
    end

    {current_state, free_set, x_set, o_set} = get_state(state_pid)
  
    # Player 2
    IO.puts(GameBoard.draw(free_set, x_set, o_set))
    player_2_square = IO.gets("#{current_state[:player_2]} pick your square: ")
    player_2_square = elem(Integer.parse(player_2_square), 0)
    if !MapSet.member?(free_set, {player_2_square, nil}) do 
        run(state_pid, true)
    end
    o_set = MapSet.put(o_set, {player_2_square, "O"})
    free_set = MapSet.delete(free_set, {player_2_square, nil})
    set_state(state_pid, new_state(free_set, x_set, o_set, current_state))

    won_the_game?(o_set, current_state[:player_2])

    tie_game?(free_set)

    # Recurse
    run(state_pid)
  end

  defp get_state(state_pid) do 
    current_state = GameState.get(state_pid)
    free_set = current_state[:free]
    x_set = current_state[:x]
    o_set = current_state[:o]

    {current_state, free_set, x_set, o_set}
  end

  defp set_state(state_pid, state) do 
    GameState.set(state_pid, state)
  end

  defp won_the_game?(player_set, player) do
    if GameLogic.won_the_game?(player_set) do
      IO.puts("#{player} HAS WON THE GAME HOORAY!!!")
      System.halt(0)
    end
  end

  defp tie_game?(free_set) do 
    if GameLogic.tie?(free_set) do
      IO.puts("CATS GAME....You guys suck!")
      System.halt(0)
    end
  end

  defp new_state(free_set, x_set, o_set, current_state) do 
    %{
      :free => free_set,
      :x => x_set,
      :o => o_set,
      :player_1 => current_state[:player_1],
      :player_2 => current_state[:player_2]
    }
  end
end

GameEngine.initiate()