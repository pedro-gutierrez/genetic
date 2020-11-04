defmodule OneMax do
  alias Genetic.Types.Chromosome
  @behaviour Genetic.Problem

  @impl true
  def genotype() do
    genes = for _ <- 1..42, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 42}
  end

  @impl true
  def fitness_function(chromosome) do
    IO.inspect(chromosome)

    IO.gets("Rate from 1 to 10 ")
    |> String.trim()
    |> String.to_integer()
  end

  @impl true
  def terminate?(population, _generation, _temperature) do
    hd(population).fitness == 42
  end
end

soln = Genetic.run(OneMax)
IO.write("\n")
IO.inspect(soln)
