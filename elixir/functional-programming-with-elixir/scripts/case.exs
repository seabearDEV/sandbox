defmodule Post do
  defstruct(
    id: :erlang.unique_integer([:positive]),
    title: "",
    author: ""
  )

  def add_user(user_list, author, title) do
    [%Post{title: title, author: author} | user_list]
  end

  def view_users(user_list) do
    IO.puts("---")
    Enum.each(user_list, fn user ->
      IO.puts(
        "ID: #{user.id}\nTitle: #{user.title}\nAuthor: #{user.author}\n---"
      )
    end)
  end

  def update_author(post, author) do
    %{post | author: author}
  end

  def view_post(post) do
    case post do
      %{author: "Jimmy Jones"} -> IO.puts("Jimmy!")
      _ -> IO.puts("Got an email from: #{post.author}...")
    end

    IO.inspect(post)
  end

  def init() do
    []
  end
end
