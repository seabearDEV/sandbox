defmodule Player do
  defstruct [
    username: nil,
    email: nil,
    score: nil
  ]

  def create_player(username, email) do
    %Player{username: username, email: email, score: 0}
  end
end

# Now call it
player = Player.create_player("Bobby", "bobby@hill.com")

IO.inspect(player)
IO.inspect(Map.get(player, :email))

IO.puts(player.username)
