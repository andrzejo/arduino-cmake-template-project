#ifndef TEMPLATE_PROJECT_CURRENTSENSOR_H
#define TEMPLATE_PROJECT_CURRENTSENSOR_H

#include <ACS712.h>

class CurrentSensor {
private:
    static ACS712 sensor;
public:
    static float read();

    static void setup();
};


#endif //TEMPLATE_PROJECT_CURRENTSENSOR_H
