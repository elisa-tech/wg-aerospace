// SPDX-License-Identifier: MIT

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <inttypes.h>
#include <stdbool.h>

#include "elisa-v2.h"

#define PORT 12345    // Port number to listen on

/*
 * Structure being received from the network.
 */
struct Packet {
    bool lights_on;
    bool light_switch;
};
struct Packet my_packet;

/*
 * Globals needed by the monitors to know the status of the system.
 */
bool lights = false;
bool lightSwitch = false;

/*
 * Fault handler: the light switch didn't turn on or took too long.
 */
void violation1 () {
  printf("Violation type 1\n");
}

/*
 * Fault handler: the light switch didn't turn off or took too long.
 */
void violation2 () {
  printf("Violation type 2\n");
}

// Function to set up the UDP socket to listen on all available interfaces.
int setup_udp_socket() {
    int sockfd;
    struct sockaddr_in server_addr;

    // Create socket
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("Error creating socket");
        exit(EXIT_FAILURE);
    }

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // Bind the socket to the port
    if (bind(sockfd, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0)
    {
        perror("Error binding socket");
        close(sockfd);
        exit(EXIT_FAILURE);
    }

    return sockfd;
}

// Main function
int main() {
    int sockfd;
    struct sockaddr_in client_addr;
    socklen_t addr_len = sizeof(client_addr);
    ssize_t recv_len;

    // Set up UDP socket
    sockfd = setup_udp_socket();
    printf("Listening for UDP packets on port %d...\n", PORT);

    // Process each packet received and re-run the monitors.
    while (1) {
        // Receive a single packet of data from the UDP socket
        recv_len = recvfrom(sockfd,
                            &my_packet,
                            sizeof(my_packet),
                            0,
                            (struct sockaddr*)&client_addr, &addr_len);

        if (recv_len < 0) {
            perror("Error receiving data");
            close(sockfd);
            exit(EXIT_FAILURE);
        }

        // Print the sender's address and port
        printf("Received packet from %s:%d\n",
               inet_ntoa(client_addr.sin_addr),
               ntohs(client_addr.sin_port));

        // Make data available to Copilot
        lights      = my_packet.lights_on;
        lightSwitch = my_packet.light_switch;

        // Re-evaluate the monitors
        step();
    }

    // Close the socket. Presumably, this is never reached.
    close(sockfd);
    return 0;
}
