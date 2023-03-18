package com.salesianos.triana.playfutday.data.files.controller;

import com.salesianos.triana.playfutday.data.files.service.StorageService;
import com.salesianos.triana.playfutday.data.files.utils.MediaTypeUrlResource;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class FileController {

    private final StorageService storageService;

    @Operation(summary = "Este obtiene la imagen de posts por su nombre")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Sa han devuelto la imagen correctamente",
                    content = {@Content(mediaType = "application/json"
                    )}),
            @ApiResponse(responseCode = "405",
                    description = "Estas intentado hacer la petición de GET a otra distinta, ejemplo POST",
                    content = @Content),
            @ApiResponse(responseCode = "400", description = "Estas intentando pasar cuerpo a la petición que no lo requiere", content = @Content),
            @ApiResponse(responseCode = "404", description = "No se ha encontrado la imagen", content = @Content),
            @ApiResponse(responseCode = "401", description = "No estas logeado", content = @Content),
    })
    @GetMapping("/download/{filename:.+}")
    public ResponseEntity<Resource> getFile(@PathVariable String filename) {
        MediaTypeUrlResource resource =
                (MediaTypeUrlResource) storageService.loadAsResource(filename);

        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", resource.getType())
                .body(resource);
    }

}
