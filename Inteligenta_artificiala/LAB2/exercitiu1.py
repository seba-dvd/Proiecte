#Exercitiu 1 - cifra - scalare imagine matriciala

import numpy as np
import matplotlib.pyplot as plt

# Citește fișierul 32x32 
with open("C:\\Users\\User\\OneDrive\\Desktop\\Facultate\\Anul III\\AI\\LABORATOR\\LAB2\\cifra.txt", "r") as f:
    matrice = np.array([[int(c) for c in line.strip()] for line in f], dtype=int) #transformare din caracter in int

# Scalare la 16x16
imagine_16x16 = np.zeros((16,16), dtype=int)
#selectare bloc de 2x2
for i in range(16):
    for j in range(16):
        bloc = matrice[2*i:2*i+2, 2*j:2*j+2]
        nr_zerouri = np.sum(bloc == 0)
        imagine_16x16[i,j] = 0 if nr_zerouri >= 3 else 1

# Scalare la 8x8 
imagine_8x8 = np.zeros((8,8), dtype=int)
#selectare bloc de 4x4
for i in range(8):
    for j in range(8):
        bloc = matrice[4*i:4*i+4, 4*j:4*j+4]
        nr_zerouri = np.sum(bloc == 0)
        imagine_8x8[i,j] = 0 if nr_zerouri >= 8 else 1  # jumătate sau mai mult -> 0

# Salvează fișierele 
np.savetxt("C:\\Users\\User\\OneDrive\\Desktop\\Facultate\\Anul III\\AI\\LABORATOR\\LAB2\\cifra_16x16.txt", imagine_16x16, fmt="%d")
np.savetxt("C:\\Users\\User\\OneDrive\\Desktop\\Facultate\\Anul III\\AI\\LABORATOR\\LAB2\\cifra_8x8.txt", imagine_8x8, fmt="%d")

# Afișare
plt.figure()
plt.title("Imagine scalata 16x16")
plt.imshow(imagine_16x16, cmap="gray", vmin=0, vmax=1)
plt.show()

plt.figure()
plt.title("Imagine scalata 8x8")
plt.imshow(imagine_8x8, cmap="gray", vmin=0, vmax=1)
plt.show()
    



