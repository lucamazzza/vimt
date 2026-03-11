#include "vim/StateMachine.h"

StateMachine::StateMachine() : m_currentMode(Mode::NORMAL) {}

bool StateMachine::handleKey(uint16_t keycode, uint64_t modifiers) {
    if (m_currentMode == Mode::INSERT) {
        if (keycode == 53) { // Escape key
            m_currentMode = Mode::NORMAL;
            return true;
        }
        return false;
    }else if (m_currentMode == Mode::NORMAL) {
        handleModeTransition(keycode, modifiers);
        return shouldSwallowKey(keycode, modifiers);
    }
    return false;
}

bool StateMachine::shouldSwallowKey(uint16_t keycode, uint64_t modifiers) const {
    if (m_currentMode == Mode::INSERT) {
        return false;
    }
    // TODO: Handle more complex combinations and keycodes
    // FIXME: Use enums for keycodes instead of magic numbers
    switch(keycode) {
        case 4:  // 'h'
        case 38: // 'j'
        case 40: // 'k'
        case 37: // 'l'
        case 34: // 'i'
            return true;
        default: return false;
    }
}

void StateMachine::handleModeTransition(uint16_t keycode, uint64_t modifiers) {
    // TODO: Handle more complex combinations and keycodes
    if (m_currentMode == Mode::NORMAL && keycode == 34) { // 'i' key
        m_currentMode = Mode::INSERT;
    }
}
