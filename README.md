# Real-Time Clock Display in x86 Assembly (TASM)

## Overview

This program continuously fetches and displays the current system time in the format `HH:MM:SS` on the screen using 16-bit x86 assembly. It updates every second, clears the screen before each update, centers the time display, and exits cleanly when any key is pressed.

## Features

- Uses DOS and BIOS interrupts to get the system time and handle keyboard input.
- Converts binary time values to ASCII for display.
- Clears and refreshes the screen on each update.
- Centers the time display on an 80x25 text screen.
- Exits gracefully on any key press.

## Requirements

- **TASM (Turbo Assembler)** to assemble the `.asm` file.
- **DOSBox** or a compatible DOS environment to run the executable (since it uses DOS interrupts).

## How to Assemble and Run

1. Assemble the code:

   ```sh
   tasm clock.asm
   ```

2. Link the object file

    ```sh
    tlink clock.obj

    ```

3. Run the executable in a DOS environment like DOSBox
    ```sh
    clock.exe

    ```

## Code Highlights

- **System time retrieval:** Using `int 21h` with `ah=2Ch`.
- **Keyboard check:** Using `int 16h` to detect key press without waiting.
- **Screen clearing:** Intended to use BIOS scroll window function (may require fix).
- **ASCII conversion:** Custom subroutine to convert binary values to two ASCII digits.
- **Cursor positioning:** BIOS interrupt to center output.

For detailed explanation of the code, see the [Documentation](Documentation.md).
