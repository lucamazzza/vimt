#pragma once

#include <ApplicationServices/ApplicationServices.h>

class EventTap {
public:
    EventTap();
    ~EventTap();
    bool start();
    void stop();
    bool checkPermissions();
private:
    static CGEventRef eventCallback(CGEventTapProxy proxy, CGEventType type,
                                    CGEventRef event, void *refcon);
    CFMachPortRef m_eventTap;
    CFRunLoopSourceRef m_runLoopSource;
    bool m_isRunning;
};
