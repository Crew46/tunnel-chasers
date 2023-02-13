Once your code is finished and ready, you must use the **Cartridge Data Assembler (CDA)** to integrate it with the rest of the project. This process is referred to as "tic-ify". Most assets of the project are stored in their own separate files, the CDA assembles all the assets together into **one catridge file**.

Please follow the next steps:
1. Copy your entire code into a text editor, such as VIM or Notepad.
2. Once copied, you will declare two new functions at the very end of the code. The name of these functions will depend on the system you're working on. 
    1. The first function will include `_init` as a suffix __after the name of the system__. E.g. `[SYSTEM_NAME]_init()`. 
        - You will move all the code outside of the main `tic()` function inside the `[SYSTEM_NAME]_init()` function. This includes variable declarations, function declarations, classes, etc.
    2. The second function will have the suffix `_loop` after the system's name. E.g. `[SYSTEM_NAME]_loop()`.
        - You will move all the code inside the `tic()` function inside the `[SYSTEM_NAME]_loop()` function.
    3. Enter a new line.
    4. On the next line (two lines away from the end of `[SYSTEM_NAME]_loop()`), you will call `make_system("[SYSTEM_NAME]",[SYSTEM_NAME]_init,[SYSTEM_NAME]_loop)`
    5. Leave a trailing new line.
3. Save this file with the name `[SYSTEM_NAME].lua`.
4. Include the file in the `code/` directory of the repo.
5. Optionally you could "tic-ify" the current version of the game by running the assembler with the command `java -jar ./ticify.jar` at the root of the repo.