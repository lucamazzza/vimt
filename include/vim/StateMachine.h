#pragma once

#include <cstdint>
enum class Mode {
    NORMAL,
    INSERT,
    VISUAL,
    COMMAND
};

class StateMachine {
public:
    StateMachine();
    bool handleKey(uint16_t keycode, uint64_t modifiers);
    inline Mode getMode() const { return m_currentMode; };
private:
    Mode m_currentMode;

    bool shouldSwallowKey(uint16_t keycode, uint64_t modifiers) const;
    void handleModeTransition(uint16_t keycode, uint64_t modifiers);
};
