#include "hashtable.h"

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This creates a new hash table of the specified size and with
 * the given hash function and comparison function.
 */
HashTable *createHashTable(int size, unsigned int (*hashFunction)(void *),
                           int (*equalFunction)(void *, void *)) {
  int i = 0;
  HashTable *newTable = malloc(sizeof(HashTable));
  if (NULL == newTable) {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }
  newTable->size = size;
  newTable->buckets = malloc(sizeof(struct HashBucketEntry *) * size);
  if (NULL == newTable->buckets) {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }
  for (i = 0; i < size; i++) {
    newTable->buckets[i] = NULL;
  }
  newTable->hashFunction = hashFunction;
  newTable->equalFunction = equalFunction;
  return newTable;
}

void insertData(HashTable *table, void *key, void *data) {
  unsigned int hash = table->hashFunction(key) % table->size;
  HashBucketEntry *entry = malloc(sizeof(HashBucketEntry));
  if (NULL == entry) {
    fprintf(stderr, "malloc failed \n");
    exit(1);
  }

  entry->key = key;
  entry->data = data;

  entry->next = table->buckets[hash];
  table->buckets[hash] = entry;
}

void *findData(HashTable *table, void *key) {
  unsigned int hash = table->hashFunction(key) % table->size;
  HashBucketEntry* p = table->buckets[hash];
  while (p != NULL) {
    if (table->equalFunction(p->key, key)) {
      return p->data;
    }
    p = p->next;
  }
  return NULL;
}

unsigned int stringHash(void *s) {
  unsigned int hash = 0;
  char* c = s;
  while (*c != '\0') {
    hash += *c;
    c++;
  }
  return hash;
}

int stringEquals(void *s1, void *s2) {
  char* c1 = s1;
  char* c2 = s2;

  while (*c1 != '\0' && *c2 != '\0') {
    if (*c1 != *c2) return 0;
    c1++;
    c2++;
  }

  return *c1 == *c2;
}
