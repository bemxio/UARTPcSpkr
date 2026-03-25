#define BUZZER_PIN 8
#define SERIAL_BAUD 9600

void setup() {
  pinMode(BUZZER_PIN, OUTPUT);
  Serial.begin(SERIAL_BAUD);
}

void loop() {
  if (!Serial.available())
    return;

  uint32_t frequency = Serial.parseInt();
  uint32_t duration = Serial.parseInt();

  if (frequency < 31)
    return;

  //Serial.println("Received beep request!");

  //Serial.print("Frequency: ");
  //Serial.println(frequency);

  //Serial.print("Duration: ");
  //Serial.println(duration);

  tone(BUZZER_PIN, frequency, duration);
}