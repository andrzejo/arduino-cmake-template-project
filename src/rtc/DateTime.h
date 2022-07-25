#ifndef TEMPLATE_PROJECT_DATETIME_H
#define TEMPLATE_PROJECT_DATETIME_H

static const int CET_OFFSET = 1;

static const int CEST_OFFSET = 2;

#include <stdint.h>
#include <Arduino.h>

class DateTime {
private:
    uint8_t _sec;
    uint8_t _min;
    uint8_t _hour;
    uint8_t _day;
    uint8_t _month;
    uint16_t _year;
    uint8_t _dow;

    static String zeroPad(uint16_t num);
    static uint8_t calculateDow(unsigned int y, unsigned int m, unsigned int d);
public:
    uint8_t second() const;

    uint8_t minute() const;

    uint8_t hour() const;

    uint8_t day() const;

    uint8_t month() const;

    uint16_t year() const;

    uint8_t yearShort() const;

    uint8_t dayOfWeek() const;

    String dayOfWeekText() const;

    String format() const;

    String date() const;

    String time() const;

    String timeShort(bool showColon = true) const;

public:
    static String dayOfWeekToText(uint8_t dow);

    DateTime(uint8_t sec, uint8_t min, uint8_t hour, uint8_t day, uint8_t month, uint16_t year);
    DateTime(uint8_t sec, uint8_t min, uint8_t hour, uint8_t day, uint8_t month, uint16_t year, uint8_t dow);

    bool operator==(const DateTime &rhs) const;

    bool operator!=(const DateTime &rhs) const;


    static DateTime fromUtc(uint8_t second, uint8_t minute, uint8_t hour, uint8_t day, uint8_t month, unsigned int year);

    static bool isDst(uint8_t day, uint8_t month, uint8_t dow);
};


#endif //TEMPLATE_PROJECT_DATETIME_H
