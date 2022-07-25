#ifndef TEMPLATE_PROJECT_RTC_H
#define TEMPLATE_PROJECT_RTC_H

#include <Arduino.h>
#include <uRTCLib.h>
#include "DateTime.h"

class Rtc {
private:
    static uRTCLib rtc;

public:
    static void setup();

    static DateTime read();

    static DateTime now();

    static void adjust(DateTime time);
};

#endif //TEMPLATE_PROJECT_RTC_H
