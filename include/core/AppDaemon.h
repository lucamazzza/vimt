#pragma once

#include <string>
#include <thread>
#include <atomic>

class AppDaemon {
public:
    AppDaemon();
    ~AppDaemon();

    void run();
    static void sendCommand(const std::string &command);
private:
    void startSocketListener();
    void cleanupSocket();
    std::atomic<bool> m_isRunning;
    int m_serverSocket;
    const std::string m_socketPath = "/tmp/vimt_daemon.sock";
};
