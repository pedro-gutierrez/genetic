defmodule Speller do
  alias Genetic.Types.Chromosome
  @behaviour Genetic.Problem

  @impl true
  def genotype() do
    genes =
      Stream.repeatedly(fn -> Enum.random(?a..?z) end)
      |> Enum.take(34)

    %Chromosome{genes: genes, size: 34}
  end

  @impl true
  def fitness_function(chromosome) do
    target = "supercalifragilisticexpialidocious"
    guess = List.to_string(chromosome.genes)
    String.bag_distance(target, guess)
  end

  @impl true
  def terminate?(population, _termination, _temperature) do
    hd(population).fitness == 1
  end
end

soln = Genetic.run(Speller)
IO.write("\n")
IO.inspect(soln)
