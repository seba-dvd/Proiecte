#Exercitiu 1

import pandas as pd
import numpy as np

# citire fisier iris
df = pd.read_csv('iris.data', header = None)
df.columns = ['sepal_l', 'sepal_w', 'petal_l', 'petal_w', 'species'] #definire coloane date
df.numeric = df.select_dtypes( include=[np.number])

# afiseaza primele 5 linii
print (df.head())
print ()

print ("Valori generale ale tabelului: ")
print (df.describe())
print ()

print ("Valorile minime ale setului de date sunt: ")
minim = np.min(df.numeric, axis = 0)
print (minim)
print()

print ("Valorile maxime ale setului de date sunt: ")
maxim = np.max(df.numeric, axis = 0)
print (maxim)
print ()

print ("Valorile medii ale setului de date sunt: ")
media = np.mean(df.numeric, axis = 0)
print (media)
print ()

print ("Valorile mediane ale setului de date sunt: ")
mediana = np.median(df.numeric, axis = 0)
print (mediana)
print ()

normalized_df = (df.numeric - minim) / (maxim - minim)
print (normalized_df)

# definim lista de ponderi conform cerinței
ponderi = [0.2, 1.1, -0.9, 1]

# calculăm suma ponderată
# inmulțim tabelul numeric cu lista de ponderi și adunăm pe rânduri (axis=1)
df.suma_ponderata = (df.numeric * ponderi).sum(axis=1)
print (df.suma_ponderata)




