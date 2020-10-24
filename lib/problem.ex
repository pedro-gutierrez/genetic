defmodule Genetic.Problem do
  alias Genetic.Types.Chromosome

  @callback genotype :: Chromosome.t()
  @callback fitness_function(Chromosome.t()) :: number()
  @callback terminate?(Enum.t()) :: boolean()
end
