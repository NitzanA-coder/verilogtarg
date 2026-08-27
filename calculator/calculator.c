#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mman.h>
#include <string.h>
#include <ctype.h>

#include "hps_0.h"

#define LW_BRIDGE_BASE 0xFF200000
#define CALCULATOR_PHYS_ADDR (LW_BRIDGE_BASE + CONECT_COMPONENT_0_BASE)
#define  MAP_SPAN 0x00200000

struct calculator
{
    uint32_t operation;
    int32_t num1;
    int32_t num2;
    int32_t result;
    int fd;
    void *map_base; // void* because mmap() returns a generic type
    volatile uint32_t *sender; 
};

// is_valid_number - checks if a string represents a valid integer
int is_valid_number(const char *str) {
    if (*str == '-') // skip leading minus sign, if present
        str++;
    if (*str == '\0') // empty string or just "-" is not valid
        return 0;
    while (*str) { // loop through the rest of the string
        if (!isdigit((unsigned char)*str)) // check current char is a digit
            return 0; // found a non-digit
        str++; // move to next character
    }
    return 1; // all characters were digits
}

int main(int argc, char *argv[])
{
    struct calculator calc;
    
    if (argc >= 2 && strcmp(argv[1], "H") == 0){
        printf("first number for operation: 1 for ADDITION; 2 for SUBTRACTION; 3 for MULTIPLICATION; 4 for DIVISION; 5 for MODULU \n and two more numbers to calculate\n");
        return -1;
    }
    
    if (argc != 4){
        printf("you need to put 3 inputs or 'H' for help\n");
        return -1;
    }
    
    if (!is_valid_number(argv[1]) || !is_valid_number(argv[2]) || !is_valid_number(argv[3])) {
        printf("you must enter only numbers or 'H' for help\n");
        return -1;
    }

    calc.operation = (uint32_t)atoi(argv[1]);
    if (calc.operation < 1 || calc.operation > 5) {
        printf("error: operation must be between 1 and 5\n");
        return -1;
    }

    calc.num1 = (int32_t)atoi(argv[2]);
    calc.num2 = (int32_t)atoi(argv[3]);
    
    calc.fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (calc.fd < 0) {
        perror("open /dev/mem failed");
        return 1;
    }

    calc.map_base = mmap(NULL, MAP_SPAN, (PROT_READ | PROT_WRITE), MAP_SHARED, calc.fd, CALCULATOR_PHYS_ADDR);
    if (calc.map_base == MAP_FAILED) {
        perror("mmap failed");
        close(calc.fd);
        return 1;
    }

    calc.sender = (volatile uint32_t *)(calc.map_base);

    *calc.sender = calc.operation;
    *calc.sender = calc.num1; 
    *calc.sender = calc.num2;
    calc.result = *calc.sender;
    
    if(calc.result != 0xFFFFFFFF)
        printf("the result is: %d\n", (int)calc.result);
    else
        printf("error: cant divide by 0\n");

    munmap(calc.map_base, MAP_SPAN);
    close(calc.fd);
    return 0;
} 