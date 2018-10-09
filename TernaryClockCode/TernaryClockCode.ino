#include <FastLED.h>

/////////////////////////////////////////////////////
// Definitions

#define LED_PIN 3

#define HOUR_BUTTON_PIN 6
#define MINUTE_BUTTON_PIN 7
#define SECOND_BUTTON_PIN 8
#define BASE_PIN 9

#define MODE_SWITCH_PIN 10

#define DIGIT_BUFFER_SIZE 5

#define ARRAY_LENGTH(array) (sizeof(array) / sizeof(array[0]))

/////////////////////////////////////////////////////
// Display Configuration

// Defines the colors used for each number
CRGB digitColors[] = {
  CRGB(  0,   0,   0),  // 0
  CRGB(255,   0,   0),  // 1
  CRGB(255, 255,   0),  // 2
  CRGB(  0, 255,   0),  // 3
  CRGB(  0, 255, 255),  // 4
  CRGB(  0,   0, 255),  // 5
  CRGB(255,   0, 255),  // 6 
};

#define MAX_BASE ARRAY_LENGTH(digitColors)

/////////////////////////////////////////////////////
// Current State

uint8_t hourDigits[DIGIT_BUFFER_SIZE];
uint8_t minuteDigits[DIGIT_BUFFER_SIZE];
uint8_t secondDigits[DIGIT_BUFFER_SIZE];

uint8_t currentBase = 3;
uint32_t timeAdjustmentMs = 0;

/////////////////////////////////////////////////////
// Setup and Loop

void setup() {
  // Load the stored time offets from flash memory
  // Setup the LEDs
}

void loop() {
  // Check for button inputs; update settings and save to flash
  handleButtons();
  
  // Read the current time
  uint64_t absoluteTimeMs = readCurrentTimeMs();
  
  // Apply the offets
  uint64_t adjustedTimeMs = absoluteTimeMs + timeAdjustmentMs;
  
  // Convert it to ternary
  computeDigitsForNum(secondDigits, (adjustedTimeMs / 1000) % 60);
  computeDigitsForNum(minuteDigits, (adjustedTimeMs / 1000 / 60) % 60);
  computeDigitsForNum(hourDigits,   (adjustedTimeMs / 1000 / 60 / 60) % 24);
  
  // Write the digits to the LED array
  
  // Output the LEDs
}


/////////////////////////////////////////////////////
// Helper Functions

void handleButtons() {
  // TODO: Handle Button Stuff
}

uint64_t readCurrentTimeMs() {
  // TODO: Read the current time from the RTC
  return millis();
}

void computeDigitsForNum(
  uint8_t* digitBuffer,
  uint8_t digitValue
) {
  // Zero the buffer
  for (uint8_t i=0; i<DIGIT_BUFFER_SIZE; i++) {
    digitBuffer[i] = 0;
  }

  // Perform the algorithm
  
}
