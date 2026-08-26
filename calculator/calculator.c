#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mman.h>
#include <ctype.h>

#include "hps_0.h"

#define LW_BRIDGE_BASE 0xFF200000
#define CALCULATOR_PHYS_ADDR (LW_BRIDGE_BASE + CONECT_COMPONENT_0_BASE)
#define  MAP_SPAN 0x00200000

struct calculator
{
    uint32_t operation;
    uint32_t num1;
    uint32_t num2;
    uint32_t result;
    int fd;
    void *map_base;
    volatile uint32_t *sender; 
};

int is_valid_number(const char *str) {
    if (*str == '-') str++;
    if (*str == '\0') return 0;
        while (*str) {
        if (!isdigit((unsigned char)*str))
            return 0;
        str++;
    }
    return 1;
}

int main(int argc, char *argv[])
{
    struct calculator calc;
    
    if (argc != 4){
        printf("you need to put 3 inputs or 'H H H' for help\n");
        return -1;
    }
    else if (strcmp(argv[1], "H") == 0 && strcmp(argv[2], "H") == 0 && strcmp(argv[3], "H") == 0){
        printf("first number for operation: 1 for ADDITION; 2 for SUBTRACTION; 3 for MULTIPLICATION; 4 for DIVISION; 5 for MODULU \n and two more numbers to calculate\n");
        return -1;
    }

    if (!is_valid_number(argv[1]) || !is_valid_number(argv[2]) || !is_valid_number(argv[3])) {
        printf("you must enter only numbers or 'H H H' for help\n");
        return -1;
    }

    calc.operation = (uint32_t)atoi(argv[1]);
    calc.num1 = (uint32_t)atoi(argv[2]);
    calc.num2 = (uint32_t)atoi(argv[3]);

    if (calc.operation < 1 || calc.operation > 5) {
        printf("error: operation must be between 1 and 5\n");
        return -1;
    }
    
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