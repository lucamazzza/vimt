#include "vim/StateMachine.h"
#include "vim/KeyCode.h"

StateMachine::StateMachine() : m_currentMode(Mode::NORMAL) {}

bool StateMachine::handleKey(uint16_t keycode, uint64_t modifiers) {
    if (m_currentMode == Mode::INSERT) {
        if (keycode == static_cast<uint16_t>(KeyCode::ESCAPE)) {
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
    switch(keycode) {
        case static_cast<uint16_t>(KeyCode::H):
        case static_cast<uint16_t>(KeyCode::J):
        case static_cast<uint16_t>(KeyCode::K):
        case static_cast<uint16_t>(KeyCode::L):
        case static_cast<uint16_t>(KeyCode::I):
            return true;
        default: return false;
    }
}

void StateMachine::handleModeTransition(uint16_t keycode, uint64_t modifiers) {
    if (m_currentMode == Mode::NORMAL && keycode == static_cast<uint16_t>(KeyCode::I)) {
        m_currentMode = Mode::INSERT;
    }
}
