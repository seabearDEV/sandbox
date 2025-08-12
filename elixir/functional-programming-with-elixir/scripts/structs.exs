defmodule User do
  defstruct username: "", email: "", age: nil

  def run do
    %User{username: "Bob", email: "bob@whatabout.com", age: 43}
  end
end

user1 = User.run
IO.inspect(user1)

%{username: username} = user1
IO.inspect(username)

user1 = %{user1 | age: 34}
IO.inspect(user1)
