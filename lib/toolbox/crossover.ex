defmodule Genetic.Toolbox.Crossover do
  alias Genetic.Types.Chromosome

  @doc """
  Default strategy.

  Single-point crossover doesn’t preserve the integrity of the permutation
  """
  def single_point(p1, p2) do
    cx_point = :rand.uniform(length(p1.genes))
    {{h1, t1}, {h2, t2}} = {Enum.split(p1.genes, cx_point), Enum.split(p2.genes, cx_point)}

    {%Chromosome{genes: h1 ++ t2, size: p1.size}, %Chromosome{genes: h2 ++ t1, size: p2.size}}
  end

  @doc """
  Order-one crossover, sometimes called “Davis order” crossover,
  is a crossover strategy on ordered lists or permutations.
  Order-one crossover is part of a unique set of crossover
  strategies that will preserve the integrity of a permutation
  solution.

  Order-one crossover will maintain the integrity of the
  permutation without the need for chromosome repair.

  Order-one crossover works like this:

  1. Select a random slice of genes from Parent 1.
  2. Remove the values from the slice of Parent 1 from Parent 2.
  3. Insert the slice from Parent 1 into the same position in Parent 2.
  4. Repeat with a random slice from Parent 2.
  """
  def order_one(p1, p2) do
    lim = Enum.count(p1.genes) - 1

    # Get random range
    {i1, i2} =
      [:rand.uniform(lim), :rand.uniform(lim)]
      |> Enum.sort()
      |> List.to_tuple()

    # p2 contribution
    # Determine which elements from p1 are present in
    # p2 and eliminates them from p2’s contribution to the child.
    slice1 = Enum.slice(p1.genes, i1..i2)
    slice1_set = MapSet.new(slice1)
    p2_contrib = Enum.reject(p2.genes, &MapSet.member?(slice1_set, &1))
    {head1, tail1} = Enum.split(p2_contrib, i1)

    # p1 contribution
    slice2 = Enum.slice(p2.genes, i1..i2)
    slice2_set = MapSet.new(slice2)
    p1_contrib = Enum.reject(p1.genes, &MapSet.member?(slice2_set, &1))
    {head2, tail2} = Enum.split(p1_contrib, i1)

    # Make and return
    {c1, c2} = {head1 ++ slice1 ++ tail1, head2 ++ slice2 ++ tail2}

    {%Chromosome{genes: c1, size: p1.size}, %Chromosome{genes: c2, size: p2.size}}
  end
end
