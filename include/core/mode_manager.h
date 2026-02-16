#pragma once


namespace vimt {

namespace core {

enum class Mode {
    NORMAL,
    INSERT,
    VISUAL,
    VISUAL_LINE,
    VISUAL_BLOCK
};

class ModeManager {
  public:
    ModeManager();
    ~ModeManager();
    inline Mode get_current_mode() const { return m_current_mode; }
    inline void set_mode(Mode mode) { m_current_mode = mode; }
    inline bool can_enter_insert_mode() const { return m_insert_mode_allowed; }
    inline void set_insert_mode_allowed(bool allowed) { m_insert_mode_allowed = allowed; }
  private:
    Mode m_current_mode;
    bool m_insert_mode_allowed;
};

} // namespace core

} // namespace vimt
