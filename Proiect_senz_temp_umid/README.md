# Monitorizare Temperatură și Umiditate DHT11


## 🛠 Tehnologii Folosite
Limbaje: Sketch Arduino, Script MATLAB: dht11_main.m
Alte unelte: Arduino IDE, MATLAB
Hardware:   •	Arduino UNO (echivalent)
            •	Senzor DHT11 (temperatură și umiditate)
            •	LCD 1602 cu modul I2C (opțional, pentru afișare locală)
            •	Cabluri de conexiune
            •	Cablu USB pentru alimentare și comunicare serial


## 📋 Descrierea Proiectului
Acest proiect constă într-un sistem de achiziție și afișare a valorilor de temperatură și umiditate preluate de la un senzor DHT11 conectat la un Arduino. Datele sunt transmise prin USB către un script MATLAB care aplică un filtru de medie mobilă și afișează valorile în timp real într-o interfață grafică.

