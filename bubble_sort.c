#include <stdio.h>
#include <stdlib.h>

void bubbleSort(int array[], int size) {
  for (int i = 0; i < size - 1; i++) {
    for (int j = 0; j < (size - i - 1); j++) {
      if (array[j] > array[j + 1]) {
        int temp = array[j];
        array[j] = array[j + 1];
        array[j + 1] = temp;
      } 
    }
  }
}

int main(void) {
  printf("Please, enter an array size: ");
  int size;
  scanf("%d", &size);

  int* array = (int*) malloc(size * sizeof(int));
  for (int i = 0; i < size; i++) {
    printf("Enter the %d element: ", i + 1);
    scanf("%d", &array[i]);
  }

  bubbleSort(array, size);

  printf("Sorted array: ");
  for (int i = 0; i < size; i++) {
    printf("%d ", array[i]);
  }
  printf("\n");
}