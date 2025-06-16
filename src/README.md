# Watch Your Step — VGA Game on BASYS3 FPGA

## Overview

**Watch Your Step** is a hardware-based 2D arcade-style game developed using Verilog and implemented on the **BASYS3 FPGA board**. The game uses a VGA monitor to render animated gameplay where a player jumps to avoid hazards and tag objects for points.

## Gameplay Summary

- The player starts on a horizontal platform displayed on the VGA screen.
- Pressing and holding **btnU** charges a jump via a **green power bar** shown at the top-left of the screen.
- Releasing **btnU** causes the player to jump upward by **twice** the height of the power bar, then fall back to the platform.
- A **yellow ball** travels from **right to left** at random heights above the platform. Tagging the ball during a jump scores a point. The ball then flashes and disappears; a new one spawns.
- A **hole** in the platform also moves from right to left. If the player is above it and doesn't jump, they **fall through** and lose a life.
- When all lives are lost:
  - The player **falls to the bottom**, flashes, and the **hole stops moving**.
  - The game enters a **game-over** state.
  - Pressing **btnC** again will **start a new game** from the beginning (with the same or updated lives if `btnL` is used).

## Controls

| Button  | Function                                                                 |
|---------|--------------------------------------------------------------------------|
| **btnC** | Start the game, or restart after falling into a hole                    |
| **btnU** | Charge and perform jump                                                 |
| **btnL** | Set number of lives using **switches (SW[3:0])** in binary              |
| **btnR** | Reset the game to the initial screen/state                              |

## Features

- VGA output at **640×480 @ 60Hz**
- Real-time player control using **Verilog FSMs and counters**
- **Dynamic gameplay**:
  - Moving yellow balls with collision detection
  - Platform with holes the player must avoid
- **Jump mechanic** powered by a visual green power bar
- **Lives system**:
  - Set initial lives via **SW[3:0]** + **btnL**
  - Defaults to **1 life** if no lives are set before starting
  - Lose one life per fall
  - Game restarts when lives = 0 and **btnC** is pressed again
- **Score display** shown on the **right two digits** of the 7-segment display
- Visual feedback: player and balls flash when triggered
- Modular structural Verilog design

## Requirements

- **Hardware**: Digilent BASYS3 Board (Artix-7 FPGA)
- **Software**:
  - Xilinx Vivado
  - VGA monitor
  - USB cable (for power and programming)

## File Structure

adder8.v - 8-bit adder module
AddSub8.v - 8-bit adder/subtractor module
coin.v - Coin (yellow ball) module
countUD4L.v - 4-bit up/down counter
countUD16L.v - 16-bit up/down counter
EdgeDetector.v - Edge detection module
full_adder.v - Full adder module
gameplay.v - Main gameplay module
gameplay_tb.v - Testbench for gameplay
half_adder.v - Half adder module
hex7seg.v - 7-segment display decoder
hole.v - Hole module
jumpBar.v - Jump bar module
labVGA_clks.v - VGA clock generation
lfsr.v - Linear feedback shift register (random number generator)
lives.v - Lives management module
mux8bit.v - 8-bit multiplexer
pixelAddress.v - VGA pixel addressing
player.v - Player module
README.md - Project documentation


## How to Run

1. Clone or download the project.
2. Open in **Vivado**, add all source files and constraints.
3. Synthesize, implement, and generate bitstream.
4. Program the **BASYS3 board**.
5. Connect a **VGA monitor**.
6. (Optional) Set lives using **SW[3:0]** and press **btnL**.
7. Press **btnC** to start.
8. If the player falls and loses all lives, press **btnC** again to restart.

## Future Improvements

- Display remaining lives on-screen
- Add sound/audio feedback
- Difficulty scaling over time
- Obstacles, multiple levels, or enemies

## Authors

Developed as part of a hardware design course using **structural Verilog** and the **BASYS3 FPGA board**.
