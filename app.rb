class Probabilities
  @iv_p          = 1.0 / 32       # Chances of an IV being 31
  @stat_p        = 1.0 / 6        # Chances of a stat being chosen
  @parent_stat_p = 1.0 / 2        # Chances of a stat from a parent being chosen
  @knot_p        = 5.0 / 6        # Chances of a stat being chosen while using Destiny Knot

  def self.breed(parents, knot = false)
    child = self.random_child

    inherited = knot ? 5 : 3

    # Choose random IVs
    selected = (0..5).to_a.sort{ rand() - 0.5 }[0..(inherited - 1)]

    # Choose a parent to inherit each IV
    selected.each do |iv|
      dominant = rand(2)
      child[iv] = parents[dominant][iv]
    end

    return child
  end

  def self.random_child
    # Generate a random child
    child = []

    for i in 0..5
      child[i] = rand(32) == 31 ? 31 : 0
    end

    return child
  end

  def self.test(parents, trials = 1000, knot = false)
    # Generate pilot child
    # child = self.random_child

    # for i in 0..(desired_ivs - 1)
    #   child[i] = 31
    # end

    # Count offsprings with desired IVs
    children = [0,0,0,0,0,0,0]

    # Breed 1000 eggs
    trials.times do
      child = self.breed(parents, knot)
      children[child.grep(31).size] += 1
    end

    return children.map{ |n| n > 0 ? (trials * 1.0 / n) : 0 }
  end

  def self.calculate(parents, trials = 1000, knot = false)
    # Run trials several times and return average result
    children = [0,0,0,0,0,0,0]

    100.times do
      children = [children, self.test(parents, trials, knot)].transpose.map {|n| n.reduce(:+)}
    end

    return children.map{ |n| n > 0 ? (n / 100.0).round(2) : 0 }
  end
end

parents = [
  [31,31,31,31,31,31],
  [0,31,31,31,31,31]
]

p Probabilities.calculate(parents, 1000, true)
