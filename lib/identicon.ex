defmodule Identicon do
  def main(input) do
    input
    |> hash_string
    |> pick_color
  end

  def hash_string(input) do
    bytes = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{bytes: bytes}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{bytes: [red, green, blue | _tail]} = image) do
    %Identicon.Image{image | color: {red, green, blue}}
  end
end
