defmodule Identicon do
  def main(input) do
    input
    |> hash_string
  end

  def hash_string(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end
end
