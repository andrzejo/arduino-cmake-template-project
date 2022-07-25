#include <Arduino.h>
#include "CurrentSensor.h"


ACS712 CurrentSensor::sensor = ACS712(ACS712_20A, A1);

float CurrentSensor::read() {
    return sensor.getCurrentDC();
}

void CurrentSensor::setup() {

}
