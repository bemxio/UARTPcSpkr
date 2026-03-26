#define BUZZER_PIN 8
#define SERIAL_BAUD 115200

uint16_t frequency;

void setup() {
  pinMode(BUZZER_PIN, OUTPUT);
  Serial.begin(SERIAL_BAUD);
}

void loop() {
  if (Serial.available() < 2)
    return;

  frequency = Serial.read();
  frequency |= Serial.read() << 8;

  //Serial.print("Received beep request! Frequency: ");
  //Serial.println(frequency);

  if (frequency == 0) {
    noTone(BUZZER_PIN); return;
  } else if (frequency >= 31) {
    tone(BUZZER_PIN, frequency);
  }
}