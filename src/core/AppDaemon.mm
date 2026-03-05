#include "core/AppDaemon.h"

#import <AppKit/AppKit.h>

#include <iostream>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

AppDaemon::AppDaemon() : m_isRunning(false), m_serverSocket(-1) {}

AppDaemon::~AppDaemon() {
    m_isRunning = false;
    cleanupSocket();
}

void AppDaemon::cleanupSocket() {
    if (m_serverSocket != -1) {
        close(m_serverSocket);
        m_serverSocket = -1;
    }
    unlink(m_socketPath.c_str());
}

void AppDaemon::sendCommand(const std::string &command) {
    int sock = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sock < 0) {
        std::cerr << "Failed to create socket: " << strerror(errno) << std::endl;
        return;
    }
    struct sockaddr_un server_addr;
    server_addr.sun_family = AF_UNIX;
    strncpy(server_addr.sun_path, "/tmp/vimt_daemon.sock", sizeof(server_addr.sun_path) - 1);
    if (connect(sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        std::cerr << "Failed to connect to daemon: " << strerror(errno) << std::endl;
        close(sock);
        return;
    }
    send(sock, command.c_str(), command.length(), 0);
    std::cout << "Sent command: " << command << std::endl;
    close(sock);
}

void AppDaemon::startSocketListener() {
    m_serverSocket = socket(AF_UNIX, SOCK_STREAM, 0);
    cleanupSocket();
    struct sockaddr_un server_addr;
    server_addr.sun_family = AF_UNIX;
    strncpy(server_addr.sun_path, m_socketPath.c_str(), sizeof(server_addr.sun_path) - 1);
    auto _ = bind(m_serverSocket, (struct sockaddr*)&server_addr, sizeof(server_addr));
    listen(m_serverSocket, 5);
    std::cout << "Daemon started, listening on " << m_socketPath << std::endl;
    while (m_isRunning) {
        int client_socket = accept(m_serverSocket, nullptr, nullptr);
        if (client_socket >= 0) {
            char buffer[256] = {0};
            read(client_socket, buffer, 256);
            std::string command(buffer);
            std::cout << "Received command: " << command << std::endl;
            if (command == "reload") {
                // TODO: Handle reload command
                std::cout << "Reloading vimt configuration..." << std::endl;
            } else if (command == "quit") {
                std::cout << "Quitting vimt..." << std::endl;
                m_isRunning = false;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSApp terminate:nil];
                });
                close(client_socket);
                break;
            }
        }
        close(client_socket);
    }
}

void AppDaemon::run() {
    m_isRunning = true;
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        [app setActivationPolicy:NSApplicationActivationPolicyAccessory];
        std::thread listenerThread(&AppDaemon::startSocketListener, this);
        listenerThread.detach();
        // TODO: eventTap support
        std::cout << "AppDaemon is starting..." << std::endl;
        [app run];
    }
}
