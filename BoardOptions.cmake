#setup Arduino board

#set(ARDUINO_BOARD "Arduino Micro [avr.micro]") # Arduino Micro
set(ARDUINO_BOARD "Arduino Uno [avr.uno]") # Arduino Uno
#set(ARDUINO_BOARD "Arduino Mega or Mega 2560 [avr.mega]") # Arduino Mega or Mega 2560

#setup programmer
set(ARDUINO_PROGRAMMER "AVRISP mkII [avr.avrispmkii]") # AVRISP mkII
#add_compile_definitions(__AVR_ATmega2560__)

add_compile_definitions(__AVR_ATmega32U4__)
#

#setup Arduino serial port
set(SERIAL_PORT /dev/ttyUSB0)
