# doomwatch
 This is my final project for my Advanced Reverse Engineering class, a source port for DOOM to WatchOS.

This project implements a framebuffer renderer and custom input system to run classic DOOM on watchOS using SwiftUI and SpriteKit, with input handled via touchscreen and Digital Crown.

I have included my final paper I wrote with a more in-depth explanation of my implementation, and a demo of the final product can be seen here:

# Swift/DOOM Engine Interoperability
Objective-C was used for interop between the Swift frontend and the DOOM Engine backend. doomgeneric_bridge handles the create/tick process and data exchange from the DOOM Engine to the frontend, and doomgeneric_watchos implements most of the required doomgeneric functions (DG_Init, DG_SleepMs, _GetTicksMs, and DG_GetKey) as well as other functions required for data exchange from the frontend to the DOOM Engine. 

# Controls
Controls are implemented and can be adjusted in doomController.swift. It uses the digital crown for forward/backward movement, and touchscreen controls are used for everything else (with fire/action replaced with backspace/enter during menu navigation):
                           | run  |
  left    |   right        |______|
----------------------     | walk |
  left    |   right        |______|
----------------------     | none |
fire | pause | action      |______|  
----------------------     | back |


