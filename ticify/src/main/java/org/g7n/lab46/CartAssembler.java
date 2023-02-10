package org.g7n.lab46;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

public class CartAssembler {
    private static final byte CHUNK_CODE = 5;
    private static final byte CHUNK_TILES = 1;
    private static final byte CHUNK_SPRITES = 2;
    private static final byte CHUNK_DEFAULT = 17;
    private static final List<Byte> ASSET_TYPES = Arrays.asList(CHUNK_SPRITES, CHUNK_TILES);
    public static void main(String[] args) {
        Path workingDirectory = Paths.get(".").toAbsolutePath().normalize();
        Path codeDirectory = workingDirectory.resolve("code");
        Path assetDirectory = workingDirectory.resolve("assets");
        Path output = workingDirectory.resolve("tunnels.tic");
        List<Byte> code = cat(codeDirectory);
        List<List<Byte>> chunks = new ArrayList<>();
        List<Byte> defaultChunk = compileChunk((byte) 0, CHUNK_DEFAULT, null);
        List<Byte> codeChunk = compileChunk((byte) 0, CHUNK_CODE, code);
        chunks.add(defaultChunk);
        chunks.add(codeChunk);
        chunks.addAll(compileAssets(assetDirectory));
        byte[] data = flatten(chunks);
        write(output, data);
    }

    private static List<List<Byte>> compileAssets(Path assetDirectory) {
        List<List<Byte>> chunks = new ArrayList<>();
        Map<Byte, AtomicInteger> indexes = new HashMap<>();
        ASSET_TYPES.forEach(type -> indexes.put(type, new AtomicInteger()));
        streamDir(assetDirectory).forEach(path -> {
            List<Byte> bytes = new ArrayList<>();
            readBytes(bytes, path);
            List<List<Byte>> newChunks = splitIntoChunks(bytes);
            for (List<Byte> chunk: newChunks) {
                byte chunkType = chunk.get(0);
                if (ASSET_TYPES.contains(chunkType)) {
                    byte bankNumber = (byte) indexes.get(chunkType).getAndIncrement();
                    List<Byte> newChunk = new ArrayList<>(chunk.subList(1, chunk.size()));
                    byte controlByte = makeControlByte(bankNumber, chunkType);
                    newChunk.add(0, controlByte);
                    chunks.add(newChunk);
                }
            }
        });
        return chunks;
    }

    private static List<List<Byte>> splitIntoChunks(List<Byte> file) {
        List<List<Byte>> chunks = new ArrayList<>();
        int index = 0;
        while (index < file.size()) {
            List<Byte> chunk;
            byte least = file.get(index + 1);
            byte most = file.get(index + 2);
            int dataSize = convertBytesToInt(most, least);
            int oldIndex = index;
            index = index + 4;
            index = index + dataSize;
            chunk = file.subList(oldIndex, index);
            chunks.add(chunk);
        }
        return chunks;
    }

    private static byte[] flatten(List<List<Byte>> chunks) {
        List<Byte> flatList = new ArrayList<>();
        chunks.forEach(flatList::addAll);
        return toByteArray(flatList);
    }

    private static void write(Path output, byte[] content) {
        try {
            Files.write(output, content);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public static byte[] toByteArray(List<Byte> list) {
        byte[] result = new byte[list.size()];
        for (int i = 0; i < list.size(); i++) {
            result[i] = list.get(i);
        }
        return result;
    }

    private static byte[] clampIntToTwoBytes(int argument) {
        byte[] bytes = new byte[2];
        bytes[0] = (byte) argument;
        bytes[1] = (byte) (argument >>> 8);
        return bytes;
    }

    public static int convertBytesToInt(byte b1, byte b2) {
        return (b1 & 0xFF) << 8 | (b2 & 0xFF);
    }

    private static List<Byte> compileChunk(byte bank, byte chunkCode, List<Byte> data) {
        if (data == null) {
            data = new ArrayList<>();
        }
        List<Byte> returnValue = new ArrayList<>();
        byte controlByte = makeControlByte(bank, chunkCode);
        byte[] size = clampIntToTwoBytes(data.size());
        returnValue.add(controlByte);
        returnValue.add(size[0]);
        returnValue.add(size[1]);
        returnValue.add((byte) 0);
        returnValue.addAll(data);
        return returnValue;
    }

    private static byte makeControlByte(byte bank, byte chunkCode) {
        int firstByteLastThreeBits = bank & 0x07;
        int secondByteLastFiveBits = chunkCode & 0x1F;
        return (byte)((firstByteLastThreeBits << 5) | secondByteLastFiveBits);
    }

    private static List<Path> streamDir(Path dir) {
        try {
            return Files.list(dir).collect(Collectors.toList());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static List<Byte> cat(Path codeDirectory) {
        List<Byte> bytes = new ArrayList<>();
        streamDir(codeDirectory).forEach(path -> readBytes(bytes, path));
        return bytes;
    }

    private static void readBytes(List<Byte> output, Path path) {
        try {
            byte[] byteArray = Files.readAllBytes(path);
            for (byte next : byteArray) {
                output.add(next);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

}