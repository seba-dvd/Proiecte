import numpy as np

# Exercitiu 1 - Găsiți produsul scalar dintre vectorii 𝑥 și 𝑦, lungimea lor și
# cosinusul unghiului dintre ei, unde 𝑥 = [2 1 2] și 𝑦 = [1 − 1 4].

x = np.array([2, 1, 2])
y = np.array([1, -1, 4])

def exercitiu1(x, y):
    produs_scalar = np.dot(x, y)

    lungime_x = np.linalg.norm(x)           
    lungime_y = np.linalg.norm(y)
    lungime_xy = lungime_x * lungime_y

    cosinus_unghi = produs_scalar / lungime_xy

    return{
        "produs_scalar": produs_scalar,
        "lungime_x": lungime_x,
        "lungime_y": lungime_y,
        "cosinus_unghi": cosinus_unghi
    }
rezultat1 = exercitiu1(x, y)

print(f"Rezultatele exercitiului 1  sunt:")
print(f"Produs scalar celor 2 vectori este: {rezultat1['produs_scalar']}")
print(f"Norma vectorului x este: {rezultat1['lungime_x']:.4f}")
print(f"Norma vectorului y este: {rezultat1['lungime_y']:.4f}")
print(f"Valoarea cosinusului format de cei 2 vectori este: {rezultat1['cosinus_unghi']:.4f}")
print("----------------------------------")
print()

# Exercitiu 2 - Implementați clasificatorul realizat cu o singură unitate, 
#       pentru a clasifica cele 8 puncte care reprezintă vârfurile unui cub

# Coordonatele punctelor uunui cub
lista_puncte = [np.array([-1, -1, -1]),
                np.array([-1, -1,  1]),
                np.array([-1,  1, -1]),
                np.array([-1,  1,  1]),
                np.array([ 1, -1, -1]),
                np.array([ 1, -1,  1]),
                np.array([ 1,  1, -1]),
                np.array([ 1,  1,  1]) 
                ]

pondere = np.array([1, 1, 1])

def exercitiu2(lista_puncte, pondere):
    # comenzi de formatare a textului afisat
    print(f"{'Punct':<18} | {'Suma':<5} | {'Clasa'}")
    print("-" * 35)
    for p in lista_puncte:
        # calculam suma ponderata pentru fiecare punct
        suma_ponderata = np.dot(p, pondere)

        if suma_ponderata < 0:
            clasa = -1
        elif suma_ponderata > 0:
            clasa = 1 
        else: clasa = 0

        print(f"{str(p):<18} | {suma_ponderata:<5} | {clasa}")

print("Rezultatele exercitiului 2 sunt: ")
exercitiu2(lista_puncte, pondere)
print("-" * 60 )
print()

# Exercitiu 3 - 
# se face matrice pe linie si se transforma in vector liniar 
# vector inmultit cu pondere
#output functia heavyside
#predictie

lista_matrice = [ np.array([1, 1, 1, 1, 0, 1, 1, 1, 1 ]),          #Coloana 1
                  np.array([0, 1, 0, 1, 0, 1, 0, 1, 0 ]),          #Coloana 2
                  np.array([0, 1, 0, 0, 1, 0, 0, 1, 0 ]),          #Coloana 3
                  np.array([1, 1, 0, 0, 1, 0, 0, 1, 0 ]) ]         #Coloana 4

ponderi = np.array([-0.14, 0.06, -0.28, -0.93, -0.08, 0.28, -0.64, 0.47, -0.85])    #ponderile de pe neuroni
etichete_reale = [0, 0, 0, 1]


def exercitiu3(lista_matrice, ponderi, etichete_reale):
    print(f"{'Intrare':<10} | {'Suma Ponderata':<10} | {'Predicție':<10} | {'Real':<5} | {'Status'}")
    print("-" * 55)

    corecte = 0

    for id, matrice in enumerate(lista_matrice):                                   #folosim comanda enumerate pentru id 

        suma_ponderata2 = np.dot(matrice, ponderi)

        if suma_ponderata2 > 0:
             clasa = 1
        else: 
             clasa = 0
        if clasa == etichete_reale[id]:
            status = "OK"
            corecte +=1
        else:
            status = "GRESIT"
            
        print(f"Coloana {id+1:<2} | {suma_ponderata2:<10.2f} | {clasa} | {etichete_reale[id]:<5} | {status}")
        rata =(corecte / len(lista_matrice)) * 100

    print("-" * 55)
    print(f"Rata de clasificare corectă: {rata}%")
print ("Rezultatele exercitiului 3 sunt: ")
exercitiu3(lista_matrice, ponderi, etichete_reale)
print ("-" * 55)
print ()


#Exercitiu 4
lista_puncte = [np.array([-1, -1, -1]),
                np.array([-1, -1,  1]),
                np.array([-1,  1, -1]),
                np.array([-1,  1,  1]),
                np.array([ 1, -1, -1]),
                np.array([ 1, -1,  1]),
                np.array([ 1,  1, -1]),
                np.array([ 1,  1,  1]) 
                ]

def sgn(x):
   return 1 if x >= 0 else -1

def exercitiu4(punct_start):
    # stare initiala a retelei este punctul de pornire // prima intrare
    o1 = punct_start[0]
    o2 = punct_start[1]
    o3 = punct_start[2]

    iteratii = 10   # setam o valoare de repetari pentru ca bulca sa se stabilizeze
    for _ in range (iteratii):

        # cream o copie a starilor pwntru a le putea compara 
        stare_veche = (o1, o2, o3)

        # setarea intrarilor noi
        o1_intrare = sgn((o2 * 1) + (o3 * -1))
        o2_intrare = sgn((o1 * 1) + (o3 * -1))
        o3_intrare = sgn((o2 *-1) + (o1 * -1))

        # actualiza la fiecare iteratie starea cu noile valori
        o1, o2, o3 = o1_intrare, o2_intrare, o3_intrare

        # verificam daca reteaua s-a stabilizat
        if stare_veche == (o1, o2, o3):
            break # daca cele 2 liste sunt egale atunci bucla se intrerupe

    # rezultatul final stabilizat
    return np.array([o1, o2, o3])

print ("Rezultatele exercitiului 4 sunt:")
print ()
print(f"{'Punct de pornire':<20} | {'Ieșire Stabilă'}")
print("-" * 45)

memorii_unice = []

for id, p in enumerate (lista_puncte):
    stabila = exercitiu4(p)
    # afisare
    print(f"{id+1:<4} | {str(p):<18} | {str(stabila)}")
    
    # transformăm rezultatul dintr-un vector, într-o listă normală Python
    lista_stabila = stabila.tolist()
    
    if lista_stabila not in memorii_unice:
        memorii_unice.append(lista_stabila)

# afișare memorii finale găsite
print("\nRețeaua s-a stabilizat în următoarele stări unice (Memoriile rețelei):")
for mem in memorii_unice:
    print(mem)
