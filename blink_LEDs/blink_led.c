#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/mman.h>

#include "hps_0.h"

#define LW_BRIDGE_BASE 0xFF200000UL
#define LED_PIO_PHYS_ADDR (LW_BRIDGE_BASE + LED_PIO_COMPONENT_0_BASE)

#define MAP_SPAN 4096UL   // one page is enough for a single PIO register
#define LED_width 8

struct blink_led
{
    volatile uint32_t led_reg;
};


int main(void)
{
    struct blink_led  *map_base = NULL;

    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) {
        perror("open /dev/mem failed");
        return 1;
    }

    map_base = (struct blink_led *)mmap(NULL, MAP_SPAN, PROT_READ | PROT_WRITE,
                           MAP_SHARED, fd, LED_PIO_PHYS_ADDR);
    if (map_base == MAP_FAILED) {
        perror("mmap failed");
        close(fd);
        return 1;
    }
    
    map_base[0].led_reg = 0x18; // Initialize LEDs to (0b00011000)
    int shift_count = 0;
    int direction = 1; // 1 for expanding, -1 for shrinking

    printf("Blinking LEDs - press Ctrl+C to stop\n");

    while (1) {
        if (direction == 1) {
            map_base[0].led_reg = map_base[0].led_reg | (0x10 << shift_count) | (0x08 >> shift_count);
            shift_count++;
            if (shift_count == LED_width / 2) {
                direction = -1;
            }
        } else {
            map_base[0].led_reg = map_base[0].led_reg & ~((0x10 << shift_count) | (0x08 >> shift_count));
            shift_count--;
            if (shift_count == 0) {
                direction = 1;
            }
        }
        usleep(200000); // 200 ms delay
    }

    // Unreachable in this simple loop, but good practice to show:
    munmap((void *)map_base, MAP_SPAN);
    close(fd);
    return 0;
}
