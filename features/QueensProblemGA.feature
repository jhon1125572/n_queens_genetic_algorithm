# language: en
# encoding: utf-8
# File: TestNQueensGA.feature
# Autors:   Jhon Jairo Pantoja - 1125572
#            Bryan Steven Tabarez - 1131782
#            John Freidy Lourido - 1124153

Feature: To prove the steps before the Genetic Algorithm

Background: To create a chromosome
  Given a size: 10 , we create chromosome with that many genes
  

Scenario: Verificate the new chromosome
  When i see the new chromosome size
  Then it must say 10
  
Scenario: Verificate the genes are differents
  When i check all the genes
  Then it must say that they are differents
  
Scenario: Verificate the chromosome's mutation is correct.
  When a chromosome is mutated with probability 1
  Then there is one gene which is interchanged with another one
  Then the number of exchanges would be equal to 2

Scenario: To prove that the uniform crossover works
  When another chromosome of size 10 is created
  And this one have the same size of his mother chromosome
  Then we cross the chromosomes
  Then the result of crossing is a son with genes of both
  
Scenario: Verificate attack 
  Given these chromosome: 
  |x| | | 
  | |x| |
  | | |x|
  Then if we evaluate the chromosome, it will return 2 conflicts
  
Scenario: Verificate attack 
  Given these chromosome: 
  | | |x| 
  | |x| |
  |x| | |
  Then if we evaluate the chromosome, it will return 2 conflicts

Scenario: Verificate attack 
  Given these chromosome: 
  | | | | | | | |x|  
  | | | |x| | | | |
  | | | | | |x| | |
  | | | | | | |x| | 
  | | | | |x| | | |
  | | |x| | | | | |
  |x| | | | | | | |
  | |x| | | | | | |
  Then if we evaluate the chromosome, it will return 5 conflicts
  
Scenario: Verificate attack 
  Given these chromosome: 
  | |x| | |
  |x| | | |
  | | | |x|
  | | |x| |
  Then if we evaluate the chromosome, it will return 4 conflicts

