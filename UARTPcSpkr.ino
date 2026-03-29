#define BUZZER_PIN 8
#define BAUD_RATE 115200

uint16_t frequency;

void setup() {
  pinMode(BUZZER_PIN, OUTPUT);
  Serial.begin(BAUD_RATE);
}

void loop() {
  if (Serial.available() < 3)
    return;

  if (Serial.read() != 0xB6)
    return;

  frequency = Serial.read() | (Serial.read() << 8);

  //Serial.print("Received beep request! Frequency: ");
  //Serial.println(frequency);

  if (frequency == 0) {
    noTone(BUZZER_PIN);
  } else {
    tone(BUZZER_PIN, frequency);
  }
}