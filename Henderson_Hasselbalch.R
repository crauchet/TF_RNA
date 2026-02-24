### General Script for Henderson Hasselbalch Equation to Prepare the Buffer at a Desired pH from both the Acidic and Basic Form in 

# Christopher Rauchet
# 2/23/2026

### DESCRIPTION: To reproducibly create buffers which have acidic and conjugate base forms available, we will use the Henderson - Hasselbalch Equation


# Let us write the the Henderson-Hasselbalch Equation:

      # pH = pKa + log([Base]/[Acid])

#In this example, we will make 1 L of 1 M Tris pH 7.6 from Acid Tris-HCl and its conjugate base Tris Base

### VARIABLES

# Desired pH of solution
pH <- 7.6

# pKa of the compound

pKa <- 8.1

# Molecular Weight of the acid (g/mol), in this case: Tris-HCl
acid_mol_weight <- 157.6

# Molecular Weight of the base (g/mol), in this case: 
base_mol_weight <- 121.2

#Final Volume in L 
final_vol <- 1

#Final Concentration in M
final_conc <- 1

### SOLVE FOR ([Base]/[Acid])

## 10^(pH-pKa)=([Base]/[Acid])


base_over_acid = 10^(pH-pKa)
base_over_acid

## Recall that because these are both in the same volume concentration is the same as the mole ratio

### base + acid = total_mols
### base/acid = base_over_acid


### base = (base_over_acid)*acid
### (base_over_acid)*acid + acid = total_mols

### (base_over_acid + 1)acid = total_mols

### acid = total_mols / (base_over_acid + 1)

### base = total_mols - acid
total_mols = final_conc*(final_vol)
total_mols

mols_acid <- total_mols/(1 + base_over_acid)
mols_acid

mols_base <- total_mols - mols_acid
mols_base

### Check and you can see mols_base/mols_acid = base_over_acid

# Convert mols to grams that are necessary

grams_base <- mols_base*base_mol_weight
grams_base

grams_acid <- mols_acid*acid_mol_weight
grams_acid







