package com.example.void_url_shortner.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Date;

public class ShortCodeGenerator {
    public static String getCode(String longUrl, Integer randomInteger) throws NoSuchAlgorithmException {
        MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
        Date currentTimeStamp = new Date();
        String originalString = longUrl + Integer.toString(randomInteger) + currentTimeStamp.toString();
        byte[] byteArray = messageDigest.digest(originalString.getBytes());
        String hexString = bytesToHex(byteArray);
        return hexString.substring(0, 5);
    }

    private static String bytesToHex(byte[] hash) {
        StringBuilder hexString = new StringBuilder(2 * hash.length);
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }
}
