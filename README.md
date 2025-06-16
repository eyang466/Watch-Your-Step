# Watch Your Step — VGA Game on BASYS3 FPGA

## Overview

**Watch Your Step** is a hardware-based 2D arcade-style game developed using Verilog and implemented on the **BASYS3 FPGA board**. The game uses a VGA monitor to render animated gameplay where a player jumps to avoid hazards and tag objects for points.

## Gameplay Summary

- The player starts on a horizontal platform displayed on the VGA screen.
- Pressing and holding **btnU** charges a jump via a **green power bar** shown at the top-left of the screen.
- Releasing **btnU** causes the player to jump upward by **twice** the height of the power bar, then fall back to the platform.
- A **yellow coin** travels from **right to left** at random heights above the platform. Tagging the coin during a jump scores a point. The coin then flashes, disappears, and then a new one spawns.
- A **hole** in the platform also moves from right to left. If the player fails to jump over, they **fall through** and lose a life.
- Pressing **bntC** is required to start a new game if there are still lives remaining.
- When all lives are lost, **bntR** is required to reset the game.
- If no lives are set using the switches, the game defaults to 1 life.

## Controls

| Button   | Function                                                                |
|----------|-------------------------------------------------------------------------|
| **btnC** | Start the game, or restart after falling into a hole                    |
| **btnU** | Charge and perform jump                                                 |
| **btnL** | Set number of lives using **switches (SW[3:0])** in binary              |
| **btnR** | Reset the game                                                          |
| **SW[15]** | Prevents player from falling into holes (invincibility)               |
| **SW[14]** | Brings the coin down to the platform                                  |
## Features

- VGA output at **640×480 @ 60Hz**
- Real-time player control using **Verilog FSMs and counters**
- **Dynamic gameplay**:
  - Moving yellow coins with collision detection
  - Platform with holes the player must avoid
- **Jump mechanic** powered by a visual green power bar
- **Lives system**:
  - Set initial lives via **SW[7:0]** + **btnL**
  - Defaults to **1 life** if no lives are set before starting
  - Lose one life per fall
  - Game ends when lives = 0 and required **btnR** to restart the game
- **Score display** shown on the **right two digits** of the 7-segment display
- **Score display** shown on the **left two digits** of the 7-segment display
- **Cheat Switches**
  - SW[15]: Prevents player from falling into holes (invincibility).
  - SW[14]: Brings the coin down to the platform.
- Visual feedback: player changes color and coin flashs when triggered
- Modular structural Verilog design

## Requirements

- **Hardware**:
  - Digilent BASYS3 Board (Artix-7 FPGA)
  - PMOD Digital Video Interface (Optional for HDMI)
- **Software**:
  - Xilinx Vivado
  - VGA monitor (or HDMI monitor if using a PMOD Digital Video Interface)
  - USB cable (for power and programming)

## File Structure
- [README.md](./README.md)
  
**Source Files**
- [adder8.v](./src/adder8.v)
- [AddSub8.v](./src/AddSub8.v)
- [coin.v](./src/coin.v)
- [countUD4L.v](./src/countUD4L.v)
- [countUD16L.v](./src/countUD16L.v)
- [EdgeDetector.v](./src/EdgeDetector.v)
- [full_adder.v](./src/full_adder.v)
- [gameplay.v](./src/gameplay.v)
- [half_adder.v](./src/half_adder.v)
- [hex7seg.v](./src/hex7seg.v)
- [hole.v](./src/hole.v)
- [jumpBar.v](./src/jumpBar.v)
- [labVGA_clks.v](./src/labVGA_clks.v)
- [lfsr.v](./src/lfsr.v)
- [lives.v](./src/lives.v)
- [mux8bit.v](./src/mux8bit.v)
- [pixelAddress.v](./src/pixelAddress.v)
- [player.v](./src/player.v)
- [points.v](./src/points.v)
- [ringCounter.v](./src/ringCounter.v)
- [selector.v](./src/selector.v)
- [syncs.v](./src/syncs.v)
- [timeCounter.v](./src/timeCounter.v)
- [top.v](./src/top.v)
  
**Constraints File**
- [Basys3_Master_HDMI.xdc](./constraints/Basys3_Master_HDMI.xdc)
  
**Sim**
- [gameplay_tb.v](./sim/gameplay_tb.v)
- [top_tb.v](./sim/top_tb.v)

## How to Run

1. Clone or download the project.
2. Open in **Vivado**, add all source files and constraints.
3. Synthesize, implement, and generate bitstream.
4. Program the **BASYS3 board**.
5. Connect a VGA monitor (or an HDMI monitor if using a PMOD Digital Video Interface)
6. *(Optional)* Set lives using **SW[7:0]** and press **btnL**.
7. *(Optional)* Set **SW15** and **SW14** for optional gameplay cheats.
8. Press **btnC** to start.
9. Press **btnC** again after losing a life to start a new round.
10. Press **bntR** to reset the game after losing all lives
