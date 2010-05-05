/*
  Arduino RFID Tag Reader
  
  Created 2010-05-05
  by Andrew Bowerman <bowerman.andrew@gmail.com>

*/

char uniqueId[13] = "";

void setup() {
  Serial.begin(2400);
  Serial.println("RFID Reader Ready");
}

void loop() {  
  readTag();  
  
  delay(1000);
}

void readTag() {
  //   Output from RFID reader is a 12-byte ASCII String
  //   1      => Start Byte = 0x0A or 10 - line feed
  //   2 - 11 => Unique ID Digit 1 - Digit 10
  //   12     => Stop Byte  = 0x0D or 13 - carriage return
  if (Serial.available() > 0) {
    uniqueId[0] = Serial.read();
    uniqueId[1] = Serial.read();
    uniqueId[2] = Serial.read();
    uniqueId[3] = Serial.read();
    uniqueId[4] = Serial.read();
    uniqueId[5] = Serial.read();
    uniqueId[6] = Serial.read();
    uniqueId[7] = Serial.read();
    uniqueId[8] = Serial.read();
    uniqueId[9] = Serial.read();
    uniqueId[10] = Serial.read();
    uniqueId[11] = Serial.read();
    uniqueId[12] = Serial.read();
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
    
    cardTag();
    roundTag();
    
    uniqueId[0] = '\0'; // Clear uniqueId
    return true;
  }
}

void blinkLight() {
  digitalWrite(3, HIGH);
  delay(100);
  digitalWrite(3, LOW);
  delay(100);
  digitalWrite(3, HIGH);
  delay(100);
  digitalWrite(3, LOW);
}

boolean roundTag() {
  // Round Tag = 0415DB2BE6
  if (uniqueId[1] == '0'
   && uniqueId[2] == '4'
   && uniqueId[3] == '1'
   && uniqueId[4] == '5'
   && uniqueId[5] == 'D'
   && uniqueId[6] == 'B'
   && uniqueId[7] == '2'
   && uniqueId[8] == 'B'
   && uniqueId[9] == 'E'
   && uniqueId[10] == '6'
   ){
    soundTwo();
    Serial.println("Round Tag Found!");
    
    uniqueId[0] = '\0'; // Clear uniqueId
    return true;
  }
}

boolean cardTag() {
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
    
    soundOne();
    Serial.println("Card Tag Found!");
    uniqueId[0] = '\0'; // Clear uniqueId
    return true;
  }
}

void soundOne() {
  tone(7, 698, 200);
  delay(100);
  tone(7, 784, 200);
}

void soundTwo() {
  tone(7, 392, 200);
  delay(100);
  tone(7, 294, 200);
}

