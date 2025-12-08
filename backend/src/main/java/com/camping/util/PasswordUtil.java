package com.camping.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.UUID;

/**
 * 密码和加密工具类
 */
public class PasswordUtil {

    /**
     * 生成盐
     */
    public static String generateSalt() {
        return UUID.randomUUID().toString().replace("-", "");
    }

    /**
     * 加密密码
     */
    public static String encryptPassword(String password, String salt) {
        try {
            String combined = password + salt;
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] messageDigest = md.digest(combined.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : messageDigest) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("密码加密失败", e);
        }
    }

    /**
     * 验证密码
     */
    public static boolean verifyPassword(String password, String salt, String encryptedPassword) {
        String encrypted = encryptPassword(password, salt);
        return encrypted.equals(encryptedPassword);
    }
}
