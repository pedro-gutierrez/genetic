defmodule Genetic.Toolbox.Selection do
  @doc """
  Natural selection is the simplest and most common selection strategy.

  The idea is simple: choose the best n chromosomes to reproduce.
  Natural selection is also sometimes referred to as elitism because it
  gives preference to the most elite chromosomes.

  The problem with natural selection is it doesn’t factor genetic
  diversity into the mix at all. It’s common with natural selection
  that your algorithms will converge onto a strong solution quickly
  but fail to improve from that point on because your population
  is too similar. Fortunately, you can counteract the lack of diversity
  with mutation, large populations, and even large chromosomes.

  The algorithm behind natural selection is straightforward.
  Given a population of sorted chromosomes, select the n best.
  """
  def natural(population, n) do
    population
    |> Enum.take(n)
  end

  @doc """
  Random selection, when compared to natural selection, lies on
  the opposite end of balancing genetic diversity and fitness.
  Random selection pays no mind to a chromosome’s fitness and
  instead selects a completely random sample of chromosomes from the population.

  Random selection can be useful if your problem absolutely requires
  genetic diversity. This is an uncommon requirement, but it can pop up
  in certain cases. For example, novelty search is the search for new,
  different solutions. Rather than rewarding solutions for being strong,
  novelty search rewards solutions for being different.

  One unique application of novelty search is scenario generation.
  In scenario generation, you’re trying to come up with different,
  valid scenarios from a set of starting scenarios. For example,
  you could use novelty search to generate different starting configurations
  for Sudoku or crossword puzzles.

  In novelty search, you could also design a fitness function that
  evaluates chromosomes based on how different they are; however,
  this could also overcomplicate your problem. Perhaps you want fitness
  to reflect a different aspect of your problem, like the difficulty of the puzzle.
  You could then use random selection to ensure you’re maintaining
  your population’s genetic diversity.

  Random selection, like natural selection, is straightforward.
  You can think of random selection like picking cards out of a shuffled
  deck or choosing names out of a hat.
  """
  def random(population, n) do
    population
    |> Enum.take_random(n)
  end

  @doc """
  Tournament selection is a strategy that pits chromosomes against
  ne another in a tournament. While selections are still based on fitness,
  tourna-ment selection introduces a strategy to choose parents that
  are both diverse and strong.

  Tournament selection works like this:

  1. Choose a pool of n chromosomes where n is the “tournament size.”
  2. Choose the fittest chromosome from the tournament.
  3. Repeat.

  The beauty of tournament selection is that it’s simple, yet it effectively
  balances genetic diversity and fitness. The strongest
  solutions will still get selected, but they’ll be mixed in with
  weak solutions that might otherwise have not been picked.

  In tournament selection, tournaments can be any n-way:
  the tournament size can be any number from 1 to the size
  of the population. Notice, however, a 1-way tournament
  is equivalent to random selection, and a tournament the
  size of your population is equivalent to natural selection.

  Tournament selection works well in parallel and can effectively
  balance genetic diversity and fitness. One drawback of tournament
  selection is that it might not be appropriate for smaller populations.

  You can implement tournament selection with two approaches: with
  duplicates and without duplicates. If you allow duplicate parents to
  be selected, you risk allowing your population to become less
  genetically diverse; however, you greatly simplify and speed up your algorithm.
  If you don’t allow duplicates, your algorithm is slower, but genetic
  diversity will increase.

  Allowing duplicates simplifies tournament selection. This implementation u
  uses a range to create and then map over a list of size n.
  A tournament is conducted at every iteration where the
  strongest individual is selected from the tournament pool.
  The result is a list of selected chromosomes—some of which will be identical.
  """
  def tournament(population, n, tournsize) do
    0..(n - 1)
    |> Enum.map(fn _ ->
      population |> Enum.take_random(tournsize) |> Enum.max_by(& &1.fitness)
    end)
  end

  def roulette(chromosomes, n) do
    # calculates the total fitness of the population.
    # This step is necessary to determine the proportion
    # of the roulette wheel that each chromosome will occupy.
    sum_fitness = chromosomes |> Enum.map(& &1.fitness) |> Enum.sum()

    0..(n - 1)
    |> Enum.map(fn _ ->
      # calculates a random value u, which represents one spin of the wheel.
      u = :rand.uniform() * sum_fitness

      # use Enum.reduce_while/3 to loop over individuals in the
      # population until we’re within the selected area. Once we
      # reach the selected area, stop the reduction and
      # return the selected individual.
      chromosomes
      |> Enum.reduce_while(0, fn x, sum ->
        if x.fitness + sum > u do
          {:halt, x}
        else
          {:cont, x.fitness + sum}
        end
      end)
    end)
  end
end
