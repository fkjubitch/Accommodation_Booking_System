package com.camping.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

/**
 * 日期工具类
 */
public class DateUtil {

    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /**
     * 解析日期字符串
     */
    public static LocalDate parseDate(String dateStr) {
        return LocalDate.parse(dateStr, formatter);
    }

    /**
     * 格式化日期
     */
    public static String formatDate(LocalDate date) {
        return date.format(formatter);
    }

    /**
     * 计算两个日期之间的天数
     */
    public static long daysBetween(String startDate, String endDate) {
        LocalDate start = parseDate(startDate);
        LocalDate end = parseDate(endDate);
        return ChronoUnit.DAYS.between(start, end);
    }

    /**
     * 计算入住天数
     */
    public static int calculateNights(String checkIn, String checkOut) {
        long days = daysBetween(checkIn, checkOut);
        return (int) days;
    }

    /**
     * 检查日期是否有效
     */
    public static boolean isValidDateRange(String checkIn, String checkOut) {
        try {
            LocalDate start = parseDate(checkIn);
            LocalDate end = parseDate(checkOut);
            return start.isBefore(end);
        } catch (Exception e) {
            return false;
        }
    }
}
