
#include "DateTime.h"

DateTime::DateTime(uint8_t sec, uint8_t min, uint8_t hour, uint8_t day, uint8_t month, uint16_t year) {
    this->_sec = sec;
    this->_min = min;
    this->_hour = hour;
    this->_day = day;
    this->_month = month;
    this->_year = year;
    this->_dow = calculateDow(year, month, day);
}

DateTime::DateTime(uint8_t sec, uint8_t min, uint8_t hour, uint8_t day, uint8_t month, uint16_t year, uint8_t dow) {
    this->_sec = sec;
    this->_min = min;
    this->_hour = hour;
    this->_day = day;
    this->_month = month;
    this->_year = year;
    this->_dow = dow;
}

uint8_t DateTime::second() const {
    return _sec;
}

uint8_t DateTime::minute() const {
    return _min;
}

uint8_t DateTime::hour() const {
    return _hour;
}

uint8_t DateTime::day() const {
    return _day;
}

uint8_t DateTime::month() const {
    return _month;
}

uint16_t DateTime::year() const {
    return _year;
}

uint8_t DateTime::dayOfWeek() const {
    return _dow;
}

String DateTime::dayOfWeekText() const {
    return dayOfWeekToText(_dow);
}

String DateTime::date() const {
    return String(zeroPad(yearShort()) + "." + zeroPad(month()) + "." + zeroPad(day()));
}

String DateTime::time() const {
    return String(zeroPad(hour()) + ":" + zeroPad(minute()) + ":" + zeroPad(second()));
}

String DateTime::format() const {
    return String(date() + "(" + dayOfWeekText() + ") " + time());
}

String DateTime::zeroPad(uint16_t num) {
    const String &numValue = String(num, DEC);
    if (num > 9) {
        return numValue;
    }
    return String("0" + numValue);
}

uint8_t DateTime::yearShort() const {
    if (_year > 100) {
        return _year - 2000;
    }
    return _year;
}

String DateTime::timeShort(bool showColon) const {
    String separator = showColon ? ":" : " ";
    return String(zeroPad(hour()) + separator + zeroPad(minute()));
}

bool DateTime::operator==(const DateTime &rhs) const {
    return _sec == rhs._sec &&
           _min == rhs._min &&
           _hour == rhs._hour &&
           _day == rhs._day &&
           _month == rhs._month &&
           _year == rhs._year &&
           _dow == rhs._dow;
}

bool DateTime::operator!=(const DateTime &rhs) const {
    return !(rhs == *this);
}

String DateTime::dayOfWeekToText(uint8_t dow) {
    char *days[7] = {
            "ND", "PO", "WT", "SR", "CZ", "PT", "SO"
    };
    return days[dow];
}

uint8_t DateTime::calculateDow(unsigned int y, unsigned int m, unsigned int d) {
    m = (m + 9) % 12;
    y -= m / 10;
    unsigned long i = 365 * y + y / 4 - y / 100 + y / 400 + (m * 306 + 5) / 10 + (d - 1);
    uint8_t day = i % 7;
    if (day <= 3) {
        return day + 3;
    }
    return day - 4;
}

DateTime DateTime::fromUtc(uint8_t sec, uint8_t min, uint8_t hour, uint8_t day, uint8_t month, unsigned int year) {
    uint8_t dow = calculateDow(year, month, day);
    uint8_t h = isDst(day, month, dow) ? hour + CET_OFFSET : hour + CEST_OFFSET;
    return {sec, min, h, day, month, year, dow};
}

bool DateTime::isDst(uint8_t day, uint8_t month, uint8_t dow) {
    if (month < 3 || month > 10) {
        return false;
    }
    if (month > 3 && month < 10) {
        return true;
    }
    uint8_t prevSunday = day - dow;
    if (month == 3) {
        return prevSunday >= 25;
    }

    if (month == 10) {
        return prevSunday < 25;
    }

    return false;
}



