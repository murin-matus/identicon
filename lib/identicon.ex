defmodule Identicon do
  def main(input) do
    input
    |> hash_string
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
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

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
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
