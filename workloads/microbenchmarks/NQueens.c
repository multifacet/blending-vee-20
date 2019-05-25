/*
 *  NQueens.cpp
 *
 *  Created on: Dec 20, 2011
 *      Author: Venkat, Kooburat
 *      Adapted from: Sankar's NQueens
 */

#include "vtime.h"
#include "debug.h"

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <assert.h>
#include <string.h>

//#define PRINT_BOARD

/* Global configuration parameters */
int g_repeat = 3;
int g_nqueen_sz = 14;

uint64_t gCounter = 0;
uint64_t startTime;

char **gChessboard;
int gSolutionCount;

/* Signal handler for interrupted execution. This is the usual (and
   only) exit point of the program */
static void terminate(int sig) {
  
  uint64_t totalTime = rdtsc() - startTime;
  PINFO("%s", "Terminated with SIG INT/QUIT\n");
  PINFO("%" PRIu64 " %" PRIu64 "\n", gCounter, totalTime);

  fflush(stdout);
  exit(EXIT_SUCCESS);
}


int check(int row, int col, int n) {
  int i, j;

  /* left upper diagonal */
  for (i = row - 1, j = col - 1; i >= 0 && j >= 0; i--, j--)
    if (gChessboard[i][j] != 0)
      return 0;

  /* right upper diagonal */
  for (i = row - 1, j = col + 1; i >= 0 && j < n; i--, j++)
    if (gChessboard[i][j] != 0)
      return 0;

  /* left lower diagonal */
  for (i = row + 1, j = col - 1; i < n && j >= 0; i++, j--)
    if (gChessboard[i][j] != 0)
      return 0;

  /* right lower diagonal */
  for (i = row + 1, j = col + 1; i < n && j < n; i++, j++)
    if (gChessboard[i][j] != 0)
      return 0;

  /* check each row same column */
  for (i = 0; i < n; i++)
    if (gChessboard[i][col] != 0 && i != row)
      return 0;

  /* check same row each col */
  for (i = 0; i < n; i++)
    if (gChessboard[row][i] != 0 && i != col)
      return 0;

  return 1;
}

#ifdef PRINT_BOARD
void print_board(int n) {
  int i, j;
  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      PINFO("%c ", gChessboard[i][j]);
    }
    PINFO("%s", "\n");
  }
  PINFO("%s", "\n\n");
}
#endif /* PRINT_BOARD */

void simulate(int row, int queens_placed, int n) {
  int col;

  /* Try the placing the queen in each columns */
  for (col = 0; col < n; col++) {
    /* Search for vacancy */
    if (check(row, col, n)) {
      gChessboard[row][col] = 1;
      queens_placed++;
      if (row < n) {
        simulate(row + 1, queens_placed, n);
      }
    } else {
      continue;
    }

    if (queens_placed == n) {
      gSolutionCount++;
      #ifdef PRINT_BOARD
      print_board(n);
      #endif

    }

    gChessboard[row][col] = 0;
    queens_placed--;
  }
}

int main(int argc, char* argv[]) {
  int i;

  if (argc > 3) {
    fprintf(stderr, "Usage: %s [nqueens-size=14] [repeat=3]\n",
	    argv[0]);
    exit(EXIT_FAILURE);
  }

  if(argc >= 2) {
    g_nqueen_sz = atoi(argv[1]);
  } 

  if(argc == 3) {
    g_repeat = atoi(argv[2]);
  } 

  signal(SIGINT, terminate);
  signal(SIGQUIT, terminate);

  gChessboard = (char**) malloc(sizeof(char*) * g_nqueen_sz);
  if (gChessboard == NULL) {
    errExit("Unable to allocate memory");
  }

  for (i = 0; i < g_nqueen_sz; i++) {
    gChessboard[i] = (char*) malloc(sizeof(char) * g_nqueen_sz);
    if (gChessboard[i] == NULL) {
      errExit("Unable to allocate memory");
    }
  }

  startTime = rdtsc();
  
  while(g_repeat >= 0) {
    if(g_repeat != -1) {
      g_repeat--;
    }
    // Reset board
    for (i = 0; i < g_nqueen_sz; i++) {
      memset(gChessboard[i], 0, sizeof(char) * g_nqueen_sz);
    }
    gSolutionCount = 0;

    simulate(0, 0, g_nqueen_sz);
    gCounter++;
  }

  uint64_t totalTime = rdtsc() - startTime;
  PINFO("%" PRIu64 " %" PRIu64 "\n", gCounter, totalTime);

  return 0;
}
