#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* GetInput() { // считывние строчки
    int size = 0; // размер строки
    int capacity = 1; // возможный размер
    char* str = calloc(capacity, sizeof(*str)); // резервируем память
    char now; // символ сейчас
    while ((now = getchar()) != EOF) { // считвание до конца строки
	if (size + 1 > capacity) { // если строка уже не помещается
	    capacity *= 2; // увеличиваем возможный размер
	    str = realloc(str, capacity * sizeof(*str)); // перезаписываем и резервируем память
	}
	str[size] = now; // добавили char
	++size; // увеличили размер строки
	}
	if (size + 1 > capacity) { // если строка уже не помещается
	    capacity *= 2; // увеличиваем возможный размер
	    str = realloc(str, capacity * sizeof(*str)); // перезаписываем и резервируем память
	}
	str[size] = 0; // символ конца строки
    return str; // вернули строку
}


int CheckPalindrome(char *str) { // проверка на палиндром
    int l = 0; // указатель на начало строки
    int r = strlen(str) - 2; // указатель на конец
    while (l < r && str[l] == str[r]) { // пока равны
        ++l; // сдвигаем левый
        --r; // сдвигаем правый
    }
    return l >= r; // условие на то, что строка палиндром
}


int main(int argc, char** argv) {
    char* str = GetInput(); // считывание

    if (CheckPalindrome(str)) { // проверка
        printf("It's palindrome\n");
    } else {
        printf("It isn't palindrome\n");
    }

    free(str); // очистка
    return 0;
}
