# = Cromosome.rb
#
# Autors::   Jhon Jairo Pantoja - 1125572
#            Bryan Steven Tabarez - 1131782
#            John Freidy Lourido - 1124153
#
# == Definición
#
# Clase encargada de ...
#
# === Clase Cromosome
#
# La clase _Cromosome_ está compuesta por
# * metodo initialize
# * metodo mutate
# === Imports
require 'rubygems'
require 'bundler/setup'

class Chromosome
  
  attr_accessor :size, :mutation_prob, :genes, :fitness
  
  # => Metodo constructor encargado de llenar el cromosoma con valores en los genes al azar y sin repeticiones.
  def initialize(n)
    @size = n
    @genes = Array.new
    @fitness = nil
    (0..n-1).each {|i| @genes[i] = i}
    @genes.shuffle!
  end
  
# => Funcion encargada de mutar los geness del cromosoma de acuerdo a una probabilidad.
  def mutate(mutation_prob)
   r = Random
    if r.rand < mutation_prob
      geneA =  r.rand(0..@genes.size-1)
      geneB =  r.rand(0..@genes.size-1)
      while geneB == geneA do geneB =  r.rand(0..@genes.size-1) end
      @genes[geneA], @genes[geneB] = @genes[geneB], @genes[geneA]
    end
  end
  
  def uniform_crossover(cromosome)
    child = Chromosome.new(@size)
    child_genes = Array.new
    (0..@size-1).each do |i|
      if rand(0..1) == 0
        child_genes << @genes[i]
      else
        child_genes << cromosome.genes[i]
      end
    end
    child.genes = child_genes
    child
  end
    
end