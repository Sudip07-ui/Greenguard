package com.greenguard.util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class JsonUtil {

    private static final Gson GSON = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd'T'HH:mm:ss")
            .serializeNulls()
            .create();

    public static void sendSuccess(HttpServletResponse resp, Object data) throws IOException {
        Map<String, Object> body = new HashMap<>();
        body.put("success", true);
        body.put("data", data);
        send(resp, 200, body);
    }

    public static void sendError(HttpServletResponse resp, int code, String message) throws IOException {
        Map<String, Object> body = new HashMap<>();
        body.put("success", false);
        body.put("message", message);
        send(resp, code, body);
    }

    private static void send(HttpServletResponse resp, int status, Object obj) throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(GSON.toJson(obj));
    }

    public static <T> T fromJson(String json, Class<T> clazz) {
        return GSON.fromJson(json, clazz);
    }

    public static String toJson(Object obj) {
        return GSON.toJson(obj);
    }
}
