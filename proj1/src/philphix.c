/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philphix.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
#ifndef _PHILPHIX_UNITTEST
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 1;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(0x61C, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}
#endif /* _PHILPHIX_UNITTEST */

/* Task 3 */
void readDictionary(char *dictName) {
  FILE* f = fopen(dictName, "r");
  char* line = NULL;
  size_t len = 0;

  if (f == NULL) {
    fprintf(stderr, "Open %s failed\n", dictName);
    exit(61);
  }

  while(getline(&line, &len, f) != -1) {
    char* c = line;
    char* val = NULL;
    while (*c != '\0' && *c != '\n') {
      if (*c == ' ' || *c == '\t') {
        *c = '\0';
        val = c + 1;
      }
      c++;
    }
    *c = '\0';
    insertData(dictionary, line, val);
    line = NULL;
  }
}

void replace(char* buf, int p) {
  char *tmp;
  char* data;

  tmp = malloc(sizeof(char) * (p + 1));
  strcpy(tmp, buf);
  if ((data = findData(dictionary, buf)) != NULL) {
    printf("%s", data);
  } else {
    for(int i = 1; i < p; i++) {
      buf[i] = tolower(buf[i]);
    }
    if ((data = findData(dictionary, buf)) != NULL) {
      printf("%s", data);
    } else {
      buf[0] = tolower(buf[0]);
      if ((data = findData(dictionary, buf)) != NULL) {
        printf("%s", data);
      } else {
        printf("%s", tmp);
      }
    }
  }
  free(tmp);
}

void processInput() {
  char* c;
  int p = 0;
  char* line = NULL;
  size_t len = 0;
  char tmp;
  int numch;

  while((numch = getline(&line, &len, stdin)) != -1) {
    c = line;
    while (c != line + numch) {
      if (isalnum(*c)) {
        p++;
      } else {
        tmp = *c;
        if (p != 0) {
          *c = '\0';
          replace(c - p, p);
          p = 0;
        }
        putchar(tmp);
      }
      c++;
    }

    if (p != 0) {
      replace(c - p, p);
    }

    free(line);
    line = NULL;
  }
}
