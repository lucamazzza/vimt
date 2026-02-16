#pragma once

#include <string>
#include <vector>

namespace vimt {

namespace core {

struct KeyMapping {
    std::string from;
    std::string to;
    std::string mode;
};

class Config {
  public:
    Config();
    ~Config();
    bool load(const std::string &path);
    inline const std::vector<KeyMapping> &get_mappings() const { return m_mappings; }
    std::vector<KeyMapping> m_mappings;
  private:
};

} // namespace core

} // namespace vimt
