/*
  Arduino RFID Tag Reader
  
  Created 2010-05-05
  by Andrew Bowerman <bowerman.andrew@gmail.com>

*/

#include <SoftwareSerial.h>
#include <LiquidCrystal.h>

LiquidCrystal lcd(7, 8, 9, 10, 11, 12);

char uniqueId[13] = "";

#define rxPin 2
#define txPin 3

void setup() {
  Serial.begin(2400);
  
  lcd.begin(16, 2);
    
  pinMode(5, OUTPUT);
  digitalWrite(5, LOW); // Activate RFID Reader
  
  LCDreadyMessage();
  Serial.println("RFID Reader Ready");
}

void loop() {
  SoftwareSerial RFID = SoftwareSerial(rxPin, txPin);
  RFID.begin(2400);
  
  readTag(RFID); 
  
  delay(1000);
}

void readTag(SoftwareSerial RFID) {
  //   Output from RFID reader is a 12-byte ASCII String
  //   1      => Start Byte = 0x0A or 10 - line feed
  //   2 - 11 => Unique ID Digit 1 - Digit 10
  //   12     => Stop Byte  = 0x0D or 13 - carriage return
  if (true) {
    uniqueId[0] = RFID.read();
    uniqueId[1] = RFID.read();
    uniqueId[2] = RFID.read();
    uniqueId[3] = RFID.read();
    uniqueId[4] = RFID.read();
    uniqueId[5] = RFID.read();
    uniqueId[6] = RFID.read();
    uniqueId[7] = RFID.read();
    uniqueId[8] = RFID.read();
    uniqueId[9] = RFID.read();
    uniqueId[10] = RFID.read();
    uniqueId[11] = RFID.read();
    uniqueId[12] = RFID.read();
  }
  
  Serial.flush();
  
  validTag();
  uniqueId[0] = '\0'; // Clear uniqueId
}

boolean validTag() {
  if (uniqueId[0] == 10 && uniqueId[11] == 13){ // Check for Start & Stop Bytes
    blinkLight();
    Serial.print("Valid RFID Tag :) ");
    Serial.println(uniqueId);
    
    soundOne();
    LCDprintTag();
    
    andrewTag();
    
    uniqueId[0] = '\0'; // Clear uniqueId
    return true;
  } else {
    soundTwo();
  }
}

void LCDreadyMessage(){
  lcd.setCursor(0, 0);
  lcd.print("-[RFID  Reader]-");
  lcd.setCursor(0, 1);
  lcd.print("Ready");
  lcd.blink();
}

void LCDprintTag(){
  lcd.setCursor(0, 1);
  lcd.print(" ");
  lcd.setCursor(0, 1);
  lcd.print(uniqueId);
  delay(2000);
  lcd.clear();
  LCDreadyMessage();
}

// Blink LED
void blinkLight() {
  digitalWrite(4, HIGH);
  delay(100);
  digitalWrite(4, LOW);
  delay(100);
  digitalWrite(4, HIGH);
  delay(100);
  digitalWrite(4, LOW);
}

// Tones
void soundOne() {
  tone(6, 698, 200);
  delay(100);
  tone(6, 784, 200);
}

void soundTwo() {
  tone(6, 392, 200);
  delay(100);
  tone(6, 294, 200);
}

void soundThree() {
  tone(6, 1200, 200);
  delay(100);
  tone(6, 1600, 200);
}

boolean andrewTag() {
  // Card Tag = 0F03039CFA
  if (uniqueId[1] == '0'
   && uniqueId[2] == 'F'
   && uniqueId[3] == '0'
   && uniqueId[4] == '3'
   && uniqueId[5] == '0'
   && uniqueId[6] == '3'
   && uniqueId[7] == '9'
   && uniqueId[8] == 'C'
   && uniqueId[9] == 'F'
   && uniqueId[10] == 'A'
   ){
    
    soundThree();
    
    lcd.setCursor(0, 1);
    lcd.print(" ");
    lcd.setCursor(0, 1);
    lcd.print("Hi Andrew! :)");
    delay(2000);
    lcd.clear();
    LCDreadyMessage();
    
    Serial.println("Andrew Tag Found!");
    uniqueId[0] = '\0'; // Clear uniqueId
    return true;
  }
}


