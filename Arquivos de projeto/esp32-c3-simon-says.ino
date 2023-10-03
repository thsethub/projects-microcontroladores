/**
   Simon Game for ESP32-C3 with Score display

   Copyright (C) 2023, Uri Shaked

   Released under the MIT License.
*/

#include "pitches.h"

/* Define pin numbers for LEDs, buttons and speaker: */
const uint8_t buttonPins = 2;
#define SPEAKER_PIN 10
int campainha = 0;
/**
   Set up the Arduino board and initialize Serial communication
*/
void setup() {

  pinMode(buttonPins, INPUT_PULLUP);
  pinMode(SPEAKER_PIN, OUTPUT);

}
/**
    Waits until the user pressed one of the buttons,
    and returns the index of that button
*/
byte readButtons() {
  while (true) {
      byte buttonPin = buttonPins;
      if (digitalRead(buttonPin) == LOW) {
        return buttonPin;
      }
    delay(1);
  }
}

/**
  Play the game over sequence, and report the game score
*/
void mariobros() {
  //Mario main theme melody
int melody[] = {
  NOTE_E7, NOTE_E7, 0, NOTE_E7,
  0, NOTE_C7, NOTE_E7, 0,
  NOTE_G7, 0, 0,  0,
  NOTE_G6, 0, 0, 0,

  NOTE_C7, 0, 0, NOTE_G6,
  0, 0, NOTE_E6, 0,
  0, NOTE_A6, 0, NOTE_B6,
  0, NOTE_AS6, NOTE_A6, 0,

  NOTE_G6, NOTE_E7, NOTE_G7,
  NOTE_A7, 0, NOTE_F7, NOTE_G7,
  0, NOTE_E7, 0, NOTE_C7,
  NOTE_D7, NOTE_B6, 0, 0,

  NOTE_C7, 0, 0, NOTE_G6,
  0, 0, NOTE_E6, 0,
  0, NOTE_A6, 0, NOTE_B6,
  0, NOTE_AS6, NOTE_A6, 0,

  NOTE_G6, NOTE_E7, NOTE_G7,
  NOTE_A7, 0, NOTE_F7, NOTE_G7,
  0, NOTE_E7, 0, NOTE_C7,
  NOTE_D7, NOTE_B6, 0, 0
};
//Mario main them tempo
int tempo[] = {
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  9, 9, 9,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,

  9, 9, 9,
  12, 12, 12, 12,
  12, 12, 12, 12,
  12, 12, 12, 12,
};
int size = sizeof(melody) / sizeof(int);
    for (int thisNote = 0; thisNote < size; thisNote++) {

      // to calculate the note duration, take one second
      // divided by the note type.
      //e.g. quarter note = 1200 / 4, eighth note = 1200/8, etc.
      int noteDuration = 1500 / tempo[thisNote];

      tone(SPEAKER_PIN, melody[thisNote], noteDuration);

      // to distinguish the notes, set NOTE_A4 minimum time between them.
      // the note's duration + 30% seems to work well:
      int pauseBetweenNotes = noteDuration * 1.30;
      delay(pauseBetweenNotes);

      noTone(SPEAKER_PIN);
    }
}

/**
   Plays NOTE_A4 hooray sound whenever the user finishes NOTE_A4 level
*/
void marcha_imperial() {
  

    tone(SPEAKER_PIN, NOTE_A4, 600);
    tone(SPEAKER_PIN, NOTE_A4, 600);
    tone(SPEAKER_PIN, NOTE_A4, 600);
    tone(SPEAKER_PIN, NOTE_F4, 450);
    tone(SPEAKER_PIN, NOTE_C5, 250);

    tone(SPEAKER_PIN, NOTE_A4, 600);
    tone(SPEAKER_PIN, NOTE_F4, 450);
    tone(SPEAKER_PIN, NOTE_C5, 250);
    tone(SPEAKER_PIN, NOTE_A4, 1200);
    //first bit

    tone(SPEAKER_PIN, NOTE_E5, 600);
    tone(SPEAKER_PIN, NOTE_E5, 600);
    tone(SPEAKER_PIN, NOTE_E5, 600);
    tone(SPEAKER_PIN, NOTE_F5, 450);
    tone(SPEAKER_PIN, NOTE_C5, 250);

    tone(SPEAKER_PIN, NOTE_GS4, 600);
    tone(SPEAKER_PIN, NOTE_F4, 450);
    tone(SPEAKER_PIN, NOTE_C5, 250);
    tone(SPEAKER_PIN, NOTE_A4, 1200);
    //second bit.
}

/**
   The main game loop
*/
void loop() {

  if (digitalRead(buttonPins) == LOW && campainha == 0) {
    mariobros();
    campainha = 1;
  }
  if(digitalRead(buttonPins) == LOW && campainha == 1){
    marcha_imperial();
    campainha = 0;
  }

  delay(300);

}

