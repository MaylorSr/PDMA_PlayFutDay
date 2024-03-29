package com.salesianos.triana.playfutday.data.files.service;

import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Path;
import java.util.stream.Stream;

public interface StorageService {

    void init();

    String store(MultipartFile file);

    String store(byte[] file, String filename, String contentType) throws Exception;

    Path load(String filename);

    Resource loadAsResource(String filename);

    void deleteFile(String filename);




}
