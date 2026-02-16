#pragma once

#include "mode_manager.h"

#include <memory>
#include <string>

namespace vimt {

namespace core {

struct KeyEvent {
    std::string key;
    bool shift;
    bool ctrl;
    bool alt;
    bool cmd;
};

enum class Action {
    MOVE_LEFT, MOVE_RIGHT, MOVE_UP, MOVE_DOWN,
    MOVE_WORD_FORWARD, MOVE_WORD_BACKWARD,
    MOVE_LINE_START, MOVE_LINE_END,
    ENTER_INSERT_MODE, ENTER_NORMAL_MODE,
    NONE
};

class KeyHandler {
  public:
    KeyHandler(ModeManager &mode_manager);
    ~KeyHandler();
    Action handle_key(const KeyEvent &event);
  private:
    ModeManager &m_mode_manager;
};

} // namespace core

} // namespace vimt
