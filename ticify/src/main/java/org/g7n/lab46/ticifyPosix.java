package org.g7n.lab46;

import jnr.posix.POSIX;
import jnr.posix.POSIXFactory;

public class ticifyPosix {
    public static void main(String[] args) {
        if (args.length == 0) {
            printUsage();
            return;
        }
        POSIX posix = POSIXFactory.getPOSIX();
        long pid = posix.getpid();
        System.out.println("Ticify started with pid: " + pid);
    }

    private static void printUsage() {
    }
}