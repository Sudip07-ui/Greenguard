package com.greenguard.util;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.UUID;

public class FileUploadUtil {

    private static final long MAX_SIZE = 5 * 1024 * 1024; // 5 MB
    private static final String[] ALLOWED = {"image/jpeg", "image/png", "image/gif", "image/webp"};

    public static String savePhoto(Part part, String uploadDir) throws IOException {
        if (part == null || part.getSize() == 0) return null;

        if (part.getSize() > MAX_SIZE) throw new IOException("File too large (max 5 MB)");

        String contentType = part.getContentType();
        boolean valid = false;
        for (String a : ALLOWED) {
            if (a.equalsIgnoreCase(contentType)) { valid = true; break; }
        }
        if (!valid) throw new IOException("Only JPEG, PNG, GIF, WEBP images are allowed");

        String ext = contentType.substring(contentType.lastIndexOf('/') + 1);
        String fileName = UUID.randomUUID() + "." + ext;

        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        try (InputStream in = part.getInputStream()) {
            Files.copy(in, Paths.get(uploadDir, fileName));
        }

        return "/uploads/violations/" + fileName;
    }
}
