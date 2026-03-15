#include "macos/EventTap.h"

#import <AppKit/AppKit.h>

#include <iostream>

EventTap::EventTap() : m_eventTap(nullptr), m_runLoopSource(nullptr), m_isRunning(false) {}

EventTap::~EventTap() {
    stop();
}

bool EventTap::checkPermissions() {
    if (!AXIsProcessTrusted()) {
        std::cerr << "Accessibility permissions error" << std::endl;
        std::cerr << "Please enable Accessibility permissions for \"vimt\" in:" << std::endl;
        std::cerr << "\tSystem Preferences > Security & Privacy > Privacy > Accessibility" << std::endl;
        NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
        AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
        return false;
    }
    std::cout << "Accessibility permissions granted" << std::endl;
    return true;
}

CGEventRef EventTap::eventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *userInfo) {
    if (type == kCGEventKeyDown) {
        EventTap *eventTap = static_cast<EventTap*>(userInfo);
        CGKeyCode keyCode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
        CGEventFlags flags = CGEventGetFlags(event);
        
        std::cout << "Key DOWN: " << keyCode << " with flags: 0x" << std::hex << flags << std::dec << std::endl;
        
        bool swallowed = eventTap->m_stateMachine.handleKey(keyCode, flags);
        if (swallowed) {
            std::cout << "Key swallowed by state machine" << std::endl;
            return nullptr;
        }
    }
    return event;
}

bool EventTap::start() {
    if (!checkPermissions()) return false;
    if (m_isRunning) {
        std::cerr << "Event tap is already running" << std::endl;
        return true;
    }
    CGEventMask eventMask = (1 << kCGEventKeyDown) | (1 << kCGEventKeyUp) | (1 << kCGEventFlagsChanged);
    m_eventTap = CGEventTapCreate(
        kCGSessionEventTap, 
        kCGHeadInsertEventTap,
        kCGEventTapOptionDefault,
        eventMask,
        eventCallback,
        this
    );
    if (!m_eventTap) {
        std::cerr << "Failed to create event tap" << std::endl;
        return false;
    }
    m_runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, m_eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), m_runLoopSource, kCFRunLoopCommonModes);
    CGEventTapEnable(m_eventTap, true);
    m_isRunning = true;
    std::cout << "Event tap started" << std::endl;
    return true;
}

void EventTap::stop() {
    if (!m_isRunning) return;
    if (m_eventTap) {
        CGEventTapEnable(m_eventTap, false);
        CFRelease(m_eventTap);
        m_eventTap = nullptr;
    }
    if (m_runLoopSource) {
        CFRunLoopRemoveSource(CFRunLoopGetCurrent(), m_runLoopSource, kCFRunLoopCommonModes);
        CFRelease(m_runLoopSource);
        m_runLoopSource = nullptr;
    }
    m_isRunning = false;
    std::cout << "Event tap stopped" << std::endl;
}
