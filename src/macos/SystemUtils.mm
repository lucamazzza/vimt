#include "macos/SystemUtils.h"
#include <CoreGraphics/CoreGraphics.h>

void SystemUtils::simulateKey(uint16_t keycode) {
    CGEventRef keyDown = CGEventCreateKeyboardEvent(nullptr, keycode, true);
    CGEventRef keyUp = CGEventCreateKeyboardEvent(nullptr, keycode, false);
    if (keyDown && keyUp) {
        CGEventPost(kCGHIDEventTap, keyDown);
        CGEventPost(kCGHIDEventTap, keyUp);
        CFRelease(keyDown);
        CFRelease(keyUp);
    }
}
