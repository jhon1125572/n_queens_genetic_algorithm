# === Clase Algoritmo_Genetico_Para_NReinas
require_relative 'Chromosome'

class N_QueensGA
  
  # Crea la poblacion con population_size donde cada uno posee n_queens reinas
  def initialize(population_size, n_queens)
    @population = Array.new
    for i in 0..population_size-1
      @population[i] = Chromosome.new(n_queens)
    end
  end 
 
  # Retorna numero de conflictos con signo negativo para un cromosoma
  def evaluate_chromosome(chromosome)
    n = chromosome.size
    left_diag = Array.new(2*n-1,0)
    right_diag = Array.new(2*n-1,0)
    counter=0
    chromosome.genes.each_with_index do |q,i|
      left_diag[i+q]+=1
      right_diag[n-1-i+q]+=1
    end
    (0..2*n-2).each do |i|
      counter+=left_diag[i]-1 if left_diag[i] > 1
      counter+=right_diag[i]-1 if right_diag[i] > 1
    end
    -counter
  end
  
  # Algoritmo genético
  def genetic_algorithm()
    begin
    mutation_prob = 0.5
    counter_generations = 0
    counter_eval = 0
    ti = Time.now
      while true
        @population.each do |c| 
          c.fitness = evaluate_chromosome(c) # Evaluación de cromosomas
          counter_eval += 1
        end
        if @population.max_by {|x| x.fitness }.fitness == 0 
          raise Interrupt
        else
          mating_pool = Array.new 
          4.times { mating_pool << @population.sample(3).max_by {|x| x.fitness} } # Selección por torneo
          mating_pool.each { |c| c.mutate(mutation_prob) }
          @population.min_by(4) {|x| x.fitness }.each { |c|  @population.delete(c) } # Eliminación peores
          mating_pool.each { |child| @population << child }  # Reemplazo por inserción
          counter_generations+=1
        end
      end
    rescue Interrupt
      tf = Time.now 
      p @population.max_by {|x| x.fitness }
      p counter_generations
      p "Número de ejecuciones " + counter_eval.to_s
      p "segundos: " + (tf-ti).to_s
    end
  end
  
  # Algoritmo genético usando diversidad
  def genetic_algorithm_diversity()
    begin
    mutation_prob = 0.1
    counter_generations = 0
    counter_eval = 0
    ti = Time.now
      while true
        diversity_hash = Hash.new
        # Evaluación de cromosomas
        @population.each do |c|
          f = evaluate_chromosome(c)
          c.fitness = f
          counter_eval += 1
          if diversity_hash.has_key?(f)
            diversity_hash[f] += 1
          else
            diversity_hash[f] = 1
          end
        end
        if @population.max_by {|x| x.fitness }.fitness == 0 
          raise Interrupt
        else
          mating_pool = Array.new 
          # Se selecciona el cromosoma cuyo fitness (clave) este relacionado con el valor mínimo en la tabla hash 'diversity_hash'
          4.times { mating_pool << @population.sample(3).min_by {|x| diversity_hash[x.fitness] } }# Selección por torneo
          mating_pool.each { |c| c.mutate(mutation_prob) }
          @population.min_by(4) {|x| x.fitness }.each { |c|  @population.delete(c) } # Eliminación peores
          mating_pool.each { |child| @population << child }  # Reemplazo por inserción
          counter_generations+=1
        end
      end
    rescue Interrupt
      tf = Time.now 
      p @population.max_by {|x| x.fitness }
      p counter_generations
      p "Número de ejecuciones " + counter_eval.to_s
      p "segundos: " + (tf-ti).to_s
    end
  end
  
  #algoritmo genetico hibrido
  def genetic_algorithm_crossbreed()
    begin
    mutation_prob = 0.1
    counter_generations = 0
    counter_eval = 0
    ti = Time.now
      while true
        diversity_hash = Hash.new
        # Evaluación de cromosomas
        @population.each do |c|
          f = evaluate_chromosome(c)
          c.fitness = f
          counter_eval += 1
          if diversity_hash.has_key?(f)
            diversity_hash[f] += 1
          else
            diversity_hash[f] = 1
          end
        end
        if @population.max_by {|x| x.fitness }.fitness == 0 
          raise Interrupt
        else
          mating_pool = Array.new
          temp_mp = Array.new
          # Se selecciona el cromosoma cuyo fitness (clave) este relacionado con el valor mínimo en la tabla hash 'diversity_hash'
          8.times { temp_mp << @population.sample(3).min_by {|x| diversity_hash[x.fitness] } } # Selección por torneo
          temp_mp.max_by(4) {|x| x.fitness }.each {|s| mating_pool << s} #de la seleccion por torneo de diversidas se seleccionan los que tienen mejor fitness
          mating_pool.each { |c| c.mutate(mutation_prob) }
          @population.min_by(4) {|x| x.fitness }.each { |c|  @population.delete(c) } # Eliminación peores
          mating_pool.each { |child| @population << child }  # Reemplazo por inserción
          counter_generations+=1
        end
      end
    rescue Interrupt
      tf = Time.now 
      p @population.max_by {|x| x.fitness }
      p counter_generations
      p "Número de ejecuciones " + counter_eval.to_s
      p "segundos: " + (tf-ti).to_s
    end
  end

  ## --------------------------------------------------------------------------
  def writeTest()
    chromosome = @population[0]
    p chromosome.genes
    conflicts = evaluate_chromosome(chromosome).abs
    table = ""
    open('features/QueensProblemGA.feature', 'a') { |f|
      f.puts "\nScenario: Verificate attack"
      f.puts "  Given these chromosome:"
      chromosome.genes.each do |gen|
        table << "  |"
        gen.times{table << " |"}
        table << "x|"
        (chromosome.size-1-gen).times{table << " |"}
        table << "\n"
      end
      p conflicts
      p table
      f.puts table
      f.puts "  Then if we evaluate the chromosome, it will return #{conflicts} conflicts"
      }
  end
  ## --------------------------------------------------------------------------
end

if __FILE__ == $0
  #A = N_QueensGA.new 100,4
  #A = N_QueensGA.new 100, 15
  #A.genetic_algorithm
  #A.writeTest()
  a = Array.new 
  for i in 0..16
    d =   i + 4
    p d
    a[i] = N_QueensGA.new 100, d
    a[i].genetic_algorithm
    #a[i].genetic_algorithm_crossbreed
    #a[i].genetic_algorithm_diversity
  end 
end