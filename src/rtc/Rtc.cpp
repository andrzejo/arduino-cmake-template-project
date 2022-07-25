#include "Rtc.h"

uRTCLib Rtc::rtc = uRTCLib(0x68);

void Rtc::setup() {
    URTCLIB_WIRE.begin();
}

void Rtc::adjust(DateTime time) {
    uint16_t year = time.year();
    if (year > 100) {
        year = year - 2000;
    }
    rtc.set(time.second(), time.minute(), time.hour(), time.dayOfWeek(), time.day(), time.month(), year);
}

DateTime Rtc::read() {
    return now();
}

DateTime Rtc::now() {
    rtc.refresh();
    uint16_t year = rtc.year();
    if (year < 100) {
        year += 2000;
    }
    return {rtc.second(), rtc.minute(), rtc.hour(), rtc.day(), rtc.month(), year, rtc.dayOfWeek()};
}
