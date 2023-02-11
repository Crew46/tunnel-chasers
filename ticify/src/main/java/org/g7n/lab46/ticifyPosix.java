package org.g7n.lab46;

import jnr.posix.FileStat;
import jnr.posix.POSIX;
import jnr.posix.POSIXFactory;
import jnr.posix.POSIXHandler;
import jnr.constants.platform.OpenFlags;

import java.io.IOException;
import java.util.List;

public class ticifyPosix {


//    public static List<String> scanDir(String path) {
//        POSIX posix = POSIXFactory.getPOSIX();
//        int fd = posix.open(path, OpenFlags.O_RDONLY.value(), 0);
//        DirEntry entry = posix.dir;
//        while (entry != null) {
//            System.out.println(entry.getName());
//            entry = posix.readdir(fd);
//        }
//    }

    public static void readBytes(List<Byte> bytes, String path) {
        POSIX posix = POSIXFactory.getPOSIX();
            FileStat stat = posix.stat(path);
            long fileSize = stat.st_size();
            byte[] buffer = new byte[(int) fileSize];
            int fd = posix.open(path, OpenFlags.O_RDONLY.value(), 0);
            posix.read(fd, buffer, buffer.length);
            for (byte next : buffer) {
                bytes.add(next);
            }
            posix.close(fd);
        }

}