#include "Arduino.h"
#include "sensors/CurrentSensor.h"
#include "rtc/Rtc.h"

void setup() {
    Serial.begin(9600);
    CurrentSensor::setup();
    Rtc::setup();
}

void loop() {
    const DateTime &time = Rtc::read();
    Serial.print("Time: ");
    Serial.println(time.format());


    float current = CurrentSensor::read();
    Serial.print("Current: ");
    Serial.print(current);
    Serial.println(" A");

    delay(3000);
}