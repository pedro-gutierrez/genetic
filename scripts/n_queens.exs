defmodule NQueens do
  @behaviour Genetic.Problem
  alias Genetic.Types.Chromosome

  @impl true
  def genotype() do
    genes = Enum.shuffle(0..7)
    %Chromosome{genes: genes, size: 8}
  end

  @doc """
  This fitness function will return the number of
  non-conflicts or the number of pieces that don’t
  conflict with any others.
  """
  @impl true
  def fitness_function(chromosome) do
    diag_clashes =
      for i <- 0..7, j <- 0..7 do
        if i != j do
          dx = abs(i - j)

          dy =
            abs(
              chromosome.genes
              |> Enum.at(i)
              |> Kernel.-(Enum.at(chromosome.genes, j))
            )

          if dx == dy do
            1
          else
            0
          end
        else
          0
        end
      end

    length(Enum.uniq(chromosome.genes)) - Enum.sum(diag_clashes)
  end

  @doc """
  Because the fitness function returns the number of non-conflicts,
  the algorithm is complete when the maximum fitness of the population
  is 8.

  In other words, the algorithm is complete when there
  are no conflicts on the board
  """
  @impl true
  def terminate?(population, _generation, _temperature) do
    Enum.max_by(population, &NQueens.fitness_function/1).fitness == 8
  end
end

soln = Genetic.run(NQueens, crossover_fn: &Genetic.Toolbox.Crossover.order_one/2)
IO.write("\n")
IO.inspect(soln)
