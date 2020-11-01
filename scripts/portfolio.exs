defmodule Portfolio do
  @behaviour Genetic.Problem
  alias Genetic.Types.Chromosome

  @impl true
  def genotype() do
    genes = for _ <- 1..100, do: {:rand.uniform(10), :rand.uniform(10)}

    %Chromosome{genes: genes, size: 100}
  end

  @impl true
  def fitness_function(chromosome) do
    chromosome.genes
    |> Enum.map(fn {roi, risk} -> 2 * roi - risk end)
    |> Enum.sum()
  end

  @impl true
  def terminate?(population, _generation, _temperature) do
    Enum.max_by(population, &fitness_function(&1)) == 10
  end
end

soln = Genetic.run(Portfolio)
IO.write("\n")
IO.inspect(soln)
