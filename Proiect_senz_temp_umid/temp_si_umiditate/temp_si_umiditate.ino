#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <DHT.h>

#define DHTPIN 2          // Pin conectat la senzor DHT11
#define DHTTYPE DHT11

DHT dht(DHTPIN, DHTTYPE);

// Inițializare LCD I2C (adresa 0x27 sau 0x3F, în funcție de modulul tău)
LiquidCrystal_I2C lcd(0x27, 16, 2); 

void setup() {
  Serial.begin(9600);
  dht.begin();
  lcd.init();         // Inițializează LCD
  lcd.backlight();    // Pornește iluminarea LCD
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Initializing...");
  delay(2000);
}

void loop() {
  float h = dht.readHumidity();
  float t = dht.readTemperature();

  if (isnan(h) || isnan(t)) {
    Serial.println("Eroare la citirea de la DHT11!");
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Eroare senzor!");
    delay(2000);
    return;
  }

  // Trimite date prin serial pentru MATLAB
  Serial.print(t);
  Serial.print(",");
  Serial.println(h);

  // Afișare pe LCD
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Temp: ");
  lcd.print(t, 1);
  lcd.print(" C");

  lcd.setCursor(0, 1);
  lcd.print("Umid: ");
  lcd.print(h, 1);
  lcd.print(" %");

  delay(1000); // actualizare la 1 sec
}
