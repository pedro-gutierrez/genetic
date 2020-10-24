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
    Enum.sum(chromosome.genes)
  end

  @impl true
  def terminate?(population) do
    hd(population).fitness == 42
  end

end

soln = Genetic.run(OneMax)
IO.write("\n")
IO.inspect(soln)
