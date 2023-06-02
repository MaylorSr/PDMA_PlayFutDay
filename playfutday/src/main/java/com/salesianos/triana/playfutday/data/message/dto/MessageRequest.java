package com.salesianos.triana.playfutday.data.message.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import javax.validation.constraints.NotBlank;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class MessageRequest {

    @NotBlank(message = "{createMessageRequest.message}")
    private String bodyMessage;

}
