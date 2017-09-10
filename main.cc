/**
 * @file main.cc
 * @brief Dynamic network connection forwarding through a central node
 *
 * @author Alex O'Neill <me@aoneill.me>
 * @bugs No known bugs.
 */

#include "main.h"

/**
 * @brief Output usage information for the user
 *
 * @param argc The number of command-line arguments
 * @param argv The command-line arguments
 *
 * @return An integer status code
 */
static int usage(int argc, char **argv) {
  printf(
    "usage: %s [ARG1]\n\n"
    "Dynamic network connection forwarding through a central node\n\n"
    "Args:\n"
    "  ARG1: DESCRIPTION\n",
    argv[0]);

  return 1;
}

/**
 * @brief Entry-point for stowaway
 *
 * @param argc The number of command-line arguments
 * @param argv The command-line arguments
 *
 * @return An integer status code
 */
int main(int argc, char **argv) {
  return usage(argc, argv);
}
