defmodule Identicon do
  def main(input) do
    input
    |> hash_string
    |> pick_color
    |> build_grid
    |> filter_odd_squares
  end

  def build_grid(%Identicon.Image{bytes: bytes} = image) do
    grid =
      bytes
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({value, _index}) ->
      rem(value, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
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
