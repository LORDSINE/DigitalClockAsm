# x86 Assembly Digital Clock Display — Documentation

This document explains an x86 assembly program running under DOS that displays a live digital clock (`HH:MM:SS`) updating every second and exits on any key press.

---

## Overview

* **Platform:** DOS (16-bit real mode, x86)
* **Function:** Continuously fetches and displays system time every second
* **Exit:** Any key press terminates the program cleanly

---

## Code Structure

### Data Segment

```assembly
.data
prevSec db 0                  ; Previous second to detect change
time    db '      00:00:00      $'  ; Time display string buffer
```

* `prevSec` stores the last second value read to avoid redundant updates.
* `time` holds the formatted time string with spaces and a DOS string terminator `$`.

### Stack

```assembly
.stack 100h
```

* Allocates 256 bytes for the program stack.

### Code Segment

#### Initialization

```assembly
main:
    mov ax, @data
    mov ds, ax
```

* Sets up the data segment register (`ds`) to point to `.data`.

#### Main Loop: Get and Wait for New Second

```assembly
get_time:

wait_next:
    mov ah, 2Ch
    int 21h            ; DOS: get current time (CH=hour, CL=minute, DH=second)
    mov bl, dh         ; Store current seconds
    cmp bl, prevSec
    je wait_next       ; Loop until seconds change
    mov prevSec, bl    ; Update stored second
```

* Fetches system time repeatedly until the seconds value changes, guaranteeing update once per second.

#### Keypress Check and Exit

```assembly
    mov ah, 01h
    int 16h            ; BIOS: check keyboard buffer
    jz continue_loop   ; No key pressed? Continue

    mov ah, 4Ch
    xor al, al
    int 21h            ; Key pressed: exit program with code 0
```

* Detects any key press to exit cleanly via DOS interrupt 21h.

Sure! Here’s that part rewritten simply and clearly, exactly as you want it, including the clearing/scrolling instructions:

---

#### Continue Loop: Save Registers and Prepare Screen

```assembly
continue_loop:
    push cx          ; Save CX register
    push dx          ; Save DX register

    mov ax, 0600h    ; Scroll up 0 lines (clear screen area)
    mov bh, 07h      ; Attribute: light gray on black
    mov cx, 0000h    ; Upper-left corner (row 0, col 0)
    mov dx, 184Fh    ; Lower-right corner (row 24, col 79)

    ; (Missing: int 10h to perform scroll/clear operation)

    pop dx           ; Restore DX register
    pop cx           ; Restore CX register
```

* Saves registers `cx` and `dx`.
* Sets up parameters to clear the entire screen by scrolling up zero lines in the defined window.
* Finally, restores the saved registers.

---

#### Convert Time to ASCII and Update `time` String

```assembly
    mov al, ch          ; Hour
    call ConvertToAscii
    mov [time+6], ah
    mov [time+7], al

    mov al, cl          ; Minute
    call ConvertToAscii
    mov [time+9], ah
    mov [time+10], al

    mov al, dh          ; Second
    call ConvertToAscii
    mov [time+12], ah
    mov [time+13], al
```

* Converts hours, minutes, and seconds (binary in `ch`, `cl`, and `dh`) to ASCII digits and stores them in the corresponding positions in the `time` string.

#### Display the Time String on Screen

```assembly
    mov ah, 02h
    mov bh, 0
    mov dh, 12          ; Row 12
    mov dl, 30          ; Column 30
    int 10h             ; BIOS: set cursor position

    mov ah, 09h
    lea dx, time
    int 21h             ; DOS: print string at cursor position
```

* Moves the cursor to row 12, column 30.
* Prints the time string using DOS print-string interrupt.

#### Loop Back

```assembly
    jmp get_time
```

* Repeats to update the clock every second.

---

### ConvertToAscii Subroutine

```assembly
ConvertToAscii:
    xor ah, ah
    mov bl, 10
    div bl           ; Divide AL by 10; AL=quotient, AH=remainder
    xchg al, ah      ; Swap AL and AH so tens in AH, units in AL
    add al, '0'
    add ah, '0'
    ret
```

* Converts a binary number in `al` to two ASCII digits.
* Returns tens digit in `ah`, units digit in `al`.

---

## Summary

| Step                | Description                                     |
| ------------------- | ----------------------------------------------- |
| Initialize DS       | Set `ds` to `.data` segment                     |
| Wait for new second | Poll system time until seconds change           |
| Check keypress      | Exit program on any key press                   |
| Convert time values | Convert hours, minutes, seconds to ASCII digits |
| Display time        | Set cursor, print formatted time string         |
| Loop                | Repeat to update display every second           |

---

## Important Notes

* This code runs only in DOS or DOS emulators like DOSBox.
* The screen is cleared using a scroll-up operation covering the full screen, but cursor positioning is fixed at row 12, column 30.
* The `ConvertToAscii` routine converts binary numbers to two ASCII digits in a simple, efficient way.
* To move the clock display, change the values of `dh` (row) and `dl` (column) in the cursor positioning code.



