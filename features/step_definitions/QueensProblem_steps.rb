# language: en
# encoding: utf-8
# File: TestNQueensGA.rb
# Autors:   Jhon Jairo Pantoja - 1125572
#            Bryan Steven Tabarez - 1131782
#            John Freidy Lourido - 1124153

# =>  Testing chromosome with genes unrepeatable.

Given(/^a size: (\d+) , we create chromosome with that many genes$/) do |sizeChromosome|
  @chromosome = Chromosome.new(sizeChromosome.to_i) 
  @genes = @chromosome.genes.clone
end

When(/^i see the new chromosome size$/) do
  @sizeChromosome= @chromosome.size 
end

Then(/^it must say (\d+)$/) do |chromosomeSize|
  expect(@sizeChromosome).to eq chromosomeSize.to_i 
end

When(/^i check all the genes$/) do
    @differents = (@genes.detect{ |e| @genes.count(e) > 1 } != nil)
end

Then(/^it must say that they are differents$/) do
  expect(@differents).to be false
end

# => Testing mutation in chromosomes.

When(/^a chromosome is mutated with probability (\d+)$/) do |mutation_prob|
  @chromosome.mutate(mutation_prob.to_f)
  @genesMutated = @chromosome.genes
end

Then(/^there is one gene which is interchanged with another one$/) do
  @exchanges = 0
  n = @chromosome.size
  if @genesMutated != nil 
    @mutation = true
    (0..n-1).each { |i| if @genes[i] != @genesMutated[i] then @exchanges += 1 end}
  else
    @mutation = false
  end

end

Then(/^the number of exchanges would be equal to (\d+)$/) do |noMutations|
  expect(@exchanges).to eq noMutations.to_i
end

# => Testing uniform crossover


When(/^another chromosome of size (\d+) is created$/) do |sizeChromosomeParent|
  @chromosomeParent = Chromosome.new(sizeChromosomeParent.to_i)
  @parentGenesChromosome = @chromosomeParent.genes
  @sizeChromosomeMother = @chromosome.size
  @sizeChromosomeParent = @chromosomeParent.size
end

And(/^this one have the same size of his mother chromosome$/) do 
  expect(@sizeChromosomeMother).to eq @sizeChromosomeParent 
end
Then(/^we cross the chromosomes$/) do
  @sonChromosome = @chromosome.uniform_crossover(@chromosomeParent)
  @genesSonChromosome = @sonChromosome.genes
end

Then(/^the result of crossing is a son with genes of both$/) do
  n = @sonChromosome.size
  @motherGenetic = false
  @fatherGenetic = false
  @parentsGenetic = true
  (0..n-1).each do |i|
    if @genesSonChromosome[i] == @genes[i]
      @motherGenetic = true
      break
    end
  end
  
  (0..n-1).each do |i|
    if @genesSonChromosome[i] == @parentGenesChromosome[i]
      @fatherGenetic = true
      break
    end
  end
  # p @motherGenetic
  # p @fatherGenetic
  expect(@motherGenetic && @fatherGenetic).to eq @parentsGenetic
  
end

# => Queens' attack

Given(/^these chromosome:$/) do |chromosomeTable|
 data = chromosomeTable.raw
 p data
 chromosomeIn = Chromosome.new(data.size)
 population = N_QueensGA.new(1,data.size)
 (0..data.size-1).each do |column|
   (0..data.size-1).each do |row|
     if(data[column][row] == 'x')
       chromosomeIn.genes[column] = row
       break
     end
   end
 end
 p chromosomeIn.genes 
 @attacks = population.evaluate_chromosome(chromosomeIn) * -1
 
end

Then(/^if we evaluate the chromosome, it will return (\d+) conflicts$/) do |attacks|
  expect(@attacks).to eq attacks.to_i
end