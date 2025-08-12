defmodule Universe do

  def bing_bang do
    IO.puts("Big Bang!")
    Process.sleep(1000)
    expand()
  end

  def expand(state \\ 0) do
    IO.puts("Size of Universe is: #{state}")
    Process.sleep(1000)
    expand(state + 1)
  end
end

Universe.bing_bang()
