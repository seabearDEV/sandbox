data = %{name: "Howard", email: "howard@example.com"}

display_data = %{name: name} = data

IO.puts("Name: #{display_data.name}")
