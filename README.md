# PLAYFUTDAY
<img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/playfutday/uploads/logo_app-removebg.png" width="225" alt="Logo"/>

***

## **DESCRIPCIÓN DEL PROYECTO** :speech_balloon:
El proyecto se trata principalmente de una red social enfocada en un único tema: el **fútbol**. El objetivo del proyecto es crear una plataforma donde los usuarios puedan ver y interactuar con los posts de otros usuarios, además de interactuar con el usuario dueño del post los cuales podrán disfrutar de otras funcionalidades relacionadas.

## **INSTALACIÓN PRE-REQUISITOS :bookmark:**
```
FLUTTER Versión de Dart de 3.0.0 y de Flutter la 3.0.0-109.0.dev <4.0.0
SPRING BOOT Versión de Java 17
ANGULAR Versión de node v16.17.1
DOCKER (recomendada última versión)
```

## DIVISIÓN DEL PROYECTO Y TECNOLOGÍAS EMPLEADAS :hammer_and_wrench:

### Divisón del proyecto

* Backend: Esta parte se encarga de recibir las solicitudes y almacenar los datos en la base de datos.

* Web: Enfocada principalmente en los usuarios administradores, esta parte permite controlar la aplicación a través de una interfaz web.

* Mobile: Esta parte consiste en una aplicación móvil dirigida a los usuarios finales.
___

## **EJECUCIÓN DEL PROYECTO** :speech_balloon:
Para llevar a cabo la ejecución del proyecto, necesitarás las versiones mencionadas anteriormente. 
Una vez clonado el repositorio, tienes dos opciones para iniciar el proyecto:
* MODO "DESPLIEGUE"
* MODO "LOCAL"

<br>

Para ejecutar el proyecto en modo despliegue tendrás en la raíz del proyecto un archivo tipo docker-compose.yml. De modo que necesitarás abrir primeramente **Docker** , posteriormente deberás abrir tu terminal y en la raíz del proyecto escribir el comando "**docker-compose up -d**" y esto levantará la **API REST** junto con el db Posgretsql y levantará Angular en el puerto **4200**. <br>

Por otro lado para ejecutar el proyecto en Flutter necesitarás irte a la carpeta **playfutday_mobile**, abrir un terminal y en dicha raíz hacer un **flutter pub get** para instalar las dependencias, una vez instalada puedes seleccionar tu dispositivo y ejecutar el comando **flutter run** .<br>

Para ejecutar el proyecto en modo local o usando la bd de H2, deberás irte a la carpeta  **playfutday** , tener el Docker abierto, y deberás seguir las siguientes instruccinoes:<br>
- En la properties general de Spring Boot, deberás cambiar el environment de prod a **dev**.
```
 spring.profiles.active=dev
 
```
**DEBERÁ VERSE DE LA SIGUIENTE MANERA:**<br>
<img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/install_help/properties.png" alt="Captura de pantalla de como debe verse las properties"/>

- En el archivo DOCKERFILE que se encuentra en la raíz del proyecto, deberás comentar cualquier línea que no coíncida con la siguiente **(se recomienda no cambiar el puerto, debido que lo tendrás que cambiar tanto en Angular, Postman, Flutter...)**: <br>
```
FROM openjdk:17-jdk-alpine
COPY "./target/playfutday-0.0.1-SNAPSHOT.jar" "app.jar"
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]

```
<br>Una vez realizado los pasos anteriores deberemos abrir nuestro terminal en dicha raíz y ejecutar los siguientes comandos de forma ordenada, esto servirá para crear la imágen y levantar la API_REST en bd h2.<br>
```
docker build --tag=message-server:latest .  
docker build -t "playfutday-h2-docker" .
docker run --name playfutday-h2-docker -p 8080:8080 playfutday-h2-docker:latest 
```
<img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/install_help/docker_h2%20(1).png" alt="Captura de pantalla de como debe verse los comandos"/>

<img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/install_help/docker_h2%20(2).png" alt="Captura de pantalla de como debe verse los comandos"/>

El resultado final debe quedar en el Docker de la siguiente manera:<br>

<img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/install_help/docker_h2%20(3).png" alt="Captura de pantalla de como debe verse el Docker"/>

<br>

Una vez finalizado, tendrás que ingresar a cada uno de los proyectos y ejecutarlos manualmente, ya sea Angular con **ng run -o** o Flutter con **flutter run**.

### Tecnologías empleadas
* [Spring Boot - Java](https://docs.spring.io/spring-boot/docs/current/reference/html/getting-started.html) : Versión 17 
* [Angular](https://angular.io/) : Versión 15.2.4
* [Flutter](https://flutter.dev/) : Versión de Dart de 3.0.0 y de Flutter la 3.0.0-109.0.dev < 4.0.0
***
# **Algunas consideraciones importantes:** :red_circle:
### USUARIOS
```
ADMINS: usuario: marta - password: M1n2345 || usuario: david  - password: D1a2345
USERS: usuario: alejandro  - password: A1b2345 || usuario: laura  - password: L1u2345
```
LAS FUNCIONALIDADES LAS ENCONTRARÁS DENTRO DE CADA CARPETA CON SU RESPECTIVA DOCUMENTACIÓN, EN EL CASO DE FLUTTER, PODRÁS VER CAPTURAS DE PANTALLAS DE LAS ACCIONES QUE SERÁS CAPAZ DE REALIZAR.
***
### BACKEND - API REST :pushpin:

<img src="https://img.shields.io/badge/Spring--Framework-5.7-green"/> <img src="https://img.shields.io/badge/Apache--Maven-3.8.6-blue"/> <img src="https://img.shields.io/badge/Java-17.0-brightgreen"/>

 <img src="https://niixer.com/wp-content/uploads/2020/11/spring-boot.png" width="500" alt="Spring Logo"/>

Puedes encontrar toda la información necesaria en: [PlayFutDay](https://github.com/MaylorSr/PDMA_PlayFutDay/tree/develop_api/playfutday)
___
### MOBILE - FLUTTER :pushpin:

![Flutter Version](https://img.shields.io/badge/Flutter-v4.0.0-blue) ![Dart Version](https://img.shields.io/badge/Dart-v3.0.0-blue)


<img src="https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png" width="500" alt="Flutter Logo"/>

Puedes encontrar toda la información necesaria en: [Playfutday_mobile](https://github.com/MaylorSr/PDMA_PlayFutDay/tree/develop_mobile/playfutday_mobile)
___
### WEB - ANGULAR :pushpin:
![Angular Compiler Version](https://img.shields.io/badge/Angular_Compiler-v13.2.6-blue)
<img src="https://user-images.githubusercontent.com/93126452/228478221-9fdd0b24-7755-4506-99cb-278dd1a4ee36.png" width="250" alt="Angular Logo"/>

Puedes encontrar toda la información necesaria en: [PlayFutDay_web](https://github.com/MaylorSr/PDMA_PlayFutDay/tree/develop_web/playfutday_web) <br>
___


