# Transaltor cod morse

## 🛠 Tehnologii Folosite
Limbaje de asamblare
Hardware: arhitectura 8086


## 📋 Descrierea Proiectului
Proiectul își propune dezvoltarea unei aplicații software la nivel de limbaj de asamblare, destinată arhitecturii pe Intel 8086. Scopul principal este realizarea unui sistem de comunicare și traducere bidirecțională între codul ASCII și Codul Morse.
Aplicația este concepută pentru a demonstra manipularea directă a resurselor procesorului (registre, memorie, stivă) și utilizarea întreruperilor software (în mod specific setul de instrucțiuni DOS INT 21h) pentru gestionarea intrărilor și ieșirilor de date.

La prima vedere aplicația prezinta ca o consolă interactivă care permite utilizatorului să efectueze conversii de text. Sistemul este structurat pe baza unui Meniu Principal, care oferă acces la patru funcții distincte:
1. Traducere ASCII -> Morse:
- utilizatorul introduce un text format din litere (A-Z).
- sistemul analizează fiecare caracter în timp real.
- pentru fiecare literă validă, se afișează secvența corespunzătoare de puncte și linii (ex: .- pentru 'A').
- in caz de introducere a altor caractere decat cele mentionate, acestea sunt ignorate sau semnalate ca eroare.
2. Traducere Morse -> ASCII:
- utilizatorul introduce o succesiune de simboluri Morse (puncte . și linii -), separate prin spații.
- sistemul compară secvența introdusă cu baza de date internă și reconstruiește cuvântul în format lizibil (text).
- in caz de introducere a altor caractere decat cele mentionate, acestea sunt ignorate sau semnalate ca eroare.
3. Index (Baza de Date):
- această funcție afișează pe ecran "dicționarul" complet utilizat de program.
- se generează un tabel formatat care arată corespondența dintre fiecare literă (A-Z) și codul său Morse, util pentru verificarea manuală sau învățare.
4. Ieșire (Exit):
- permite terminarea controlată a programului și returnarea controlului către sistemul de operare, eliberând resursele procesorului.