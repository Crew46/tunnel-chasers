package org.g7n.lab46;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class CartAssembler {
    private static final byte CHUNK_CODE = 5;
    private static final byte CHUNK_TILES = 1;
    private static final byte CHUNK_SPRITES = 2;
    private static final Byte CHUNK_FLAGS = 6;
    private static final byte CHUNK_MAP = 4;
    private static final byte CHUNK_PALETTE = 12;
    private static final byte CHUNK_DEFAULT = 17;
    private static final byte CHUNK_MUSIC = 14;
    private static final byte CHUNK_MUSIC_PATTERNS = 15;
    private static final byte CHUNK_SFX = 9;
    private static final byte CHUNK_WAVEFORM = 10;
    private static final List<Byte> ASSET_TYPES = Arrays.asList(CHUNK_TILES, CHUNK_MAP, CHUNK_MUSIC);
    private static final String[] LABELS = {"0", "Tiles", "Sprites", "3", "Map", "Code", "Flags", "7", "8", "SFX", "Waveform", "11", "Palette", "13", "Music", "Music Pattern", "16", "Default"};
    private static final Map<Byte,List<Byte>> LINKED_TYPES = generateLinkedTypes();

    private static Map<Byte, List<Byte>> generateLinkedTypes() {
        Map<Byte,List<Byte>> linkedTypes = new HashMap<>();
        linkedTypes.put(CHUNK_TILES, Arrays.asList(CHUNK_DEFAULT, CHUNK_PALETTE, CHUNK_SPRITES, CHUNK_FLAGS));
        linkedTypes.put(CHUNK_MUSIC, Arrays.asList(CHUNK_MUSIC_PATTERNS, CHUNK_SFX, CHUNK_WAVEFORM));
        return linkedTypes;
    }

    public static void main(String[] args) {
        Path workingDirectory = Paths.get(".").toAbsolutePath().normalize();
        Path codeDirectory = workingDirectory.resolve("code");
        Path assetDirectory = workingDirectory.resolve("assets");
        Path output = workingDirectory.resolve("tunnels.tic");
        List<List<Byte>> chunks = new ArrayList<>();
        List<Byte> codeChunk = compileCodeChunk(codeDirectory);
        chunks.add(codeChunk);
        chunks.addAll(compileAssets(assetDirectory));
        for (List<Byte> chunk: chunks) {
            Byte controlByte = chunk.get(0);
            int bank = (controlByte & 0xE0) >> 5;
            int type = controlByte & 0x1f;
            System.out.println("Bank " + bank + ", type " + LABELS[type]);
        }
        byte[] data = flatten(chunks);
        write(output, data);
    }

    private static List<Byte> compileCodeChunk(Path codeDirectory) {
        List<Byte> code = cat(codeDirectory, true);
        List<Byte> codeChunk = compileChunk((byte) 0, CHUNK_CODE, code);
        return codeChunk;
    }

    private static List<List<Byte>> compileAssets(Path assetDirectory) {
        List<List<Byte>> chunks = new ArrayList<>();
        Map<Byte, AtomicInteger> indexes = new HashMap<>();
        ASSET_TYPES.forEach(type -> indexes.put(type, new AtomicInteger()));
        streamDir(assetDirectory).forEach(path -> {
            List<Byte> bytes = new ArrayList<>();
            readBytes(bytes, path, false);
            List<List<Byte>> newChunks = splitIntoChunks(bytes);
            for (List<Byte> chunk: newChunks) {
                byte chunkType = chunk.get(0);
                if (ASSET_TYPES.contains(chunkType)) {
                    byte bankNumber = (byte) indexes.get(chunkType).getAndIncrement();
                    List<Byte> newChunk = bankifyChunk(chunk, bankNumber);
                    chunks.add(newChunk);
                    if (LINKED_TYPES.containsKey(chunkType)) {
                        List<Byte> linkedTypes = LINKED_TYPES.get(chunkType);
                        for (Byte linkedType: linkedTypes) {
                            for (List<Byte> comparedChunk: newChunks) {
                                byte comparedChunkType = comparedChunk.get(0);
                                if (comparedChunkType == linkedType) {
                                    List<Byte> newComparedChunk = bankifyChunk(comparedChunk, bankNumber);
                                    chunks.add(newComparedChunk);
                                }
                            }
                        }
                    }
                }
            }
        });
        return chunks;
    }

    private static List<Byte> bankifyChunk(List<Byte> chunk, byte bankNumber) {
        byte chunkType = chunk.get(0);
        List<Byte> newChunk = new ArrayList<>(chunk.subList(1, chunk.size()));
        byte controlByte = makeControlByte(bankNumber, chunkType);
        newChunk.add(0, controlByte);
        return newChunk;
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

    private static List<Byte> compileChunk(byte bank, byte chunkType, List<Byte> data) {
        if (data == null) {
            data = new ArrayList<>();
        }
        List<Byte> returnValue = new ArrayList<>();
        byte controlByte = makeControlByte(bank, chunkType);
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
        try (Stream<Path> stream = Files.list(dir)) {
            return stream.sorted().collect(Collectors.toList());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private static List<Byte> cat(Path codeDirectory, boolean newlinesRequired) {
        List<Byte> bytes = new ArrayList<>();
        streamDir(codeDirectory).forEach(path -> readBytes(bytes, path, newlinesRequired));
        return bytes;
    }

    private static void readBytes(List<Byte> output, Path path, boolean newlinesRequired) {
        try {
            byte[] byteArray = Files.readAllBytes(path);
            if (newlinesRequired) {
                byte last = byteArray[byteArray.length - 1];
                if (last != 10) {
                    throw new IllegalArgumentException("File does not contain trailing newline: " + path);
                }
            }
            for (byte next : byteArray) {
                output.add(next);
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

}