# PLAYFUTDAY



## **:warning: :warning: :warning: MENSAJE IMPORTANTE DEL PROYECTO!** :warning: :warning: :warning: 

Esta se trata de una versión beta de el producto final, por ende haz de tener en cuenta los siguientes errores que se pueden producir para facilitarte el "porque no funcicona" , posteriormente en las siguientes versiones se corrigirán dichos errores, se presenta:
- Se ha detectado fallo, en EditProfile, realiza la petición correctamente pero para poder ver los cambios tienes que navegar a otra pagina (con el BottomCurveNavigationBar) y volver al ProfileScreen, además al entrar en EditProfile una vez realizado los cambios sigue observandose los valores iniciales del usuario, el estado no ha cambiado aunque en el ProfileScreen si se vean los cambios de la manera mencionada anteriormente.
- Fallo al querer comentar desde el buscador, fallo de padre en widget.
- El contador de comentarios no sube cuando comentas, pero si puedes ver visualmente el comentario nuevo añadido de manera dinámica.
- Puede que al querer borrar un post si este no tiene imagen se niegue la petición, tendrás que hacerlo dos veces para poder confirmar el borrado.
- Al borrar un post, si navegas al ProfileScreen seguirás viendo la imágen de tu post (en la forma cuadricular)

Nuevas implementaciones como: ser capaz de subir un post, placeholder, visualizar perfil, editar perfil (mencionado anteriormente de que manera), onRefresh en HomePage donde obtienes todos los post, mantener el me gusta activo aunque sigas bajando la lista, etc. 

La documentación la encontrarás en la carpeta [PlanEmpresa](https://github.com/MaylorSr/PDMA_PlayFutDay/blob/release_1.0/PlanEmpresa/PlayFutDay.pdf) .

Se te proporcionará usuarios para que puedas probarlos:<br>
 ### ADMIN - NO AFECTA A NIVEL DE INTERFÁZ
 - username: wbeetham0
 - password: QUE1chC2Jv
 ### USER
 - username: bmacalester1
 - password: 8dNbnHaX

___
## **DESCRIPCIÓN DEL PROYECTO** :speech_balloon:
Se trata de una red social la cual se encuentra enfocada en un único tema como lo es el **fútbol**, por ello el objetivo del proyecto es realizar una red social donde puedas ver los post de los demás usuarios, interactuar con cada uno de los post además de poder interactuar con los usuarios, entre otras funcionalidades.
El proyecto se encuentra dividido en "3 partes", la parte del Backend que es la que se dedicará a recibir la peticiones e almacenar en la bd , la parte web que será enfocada más bien a los usuarios administradores para que puedan controlar la aplicación desde una página web y la parte mobile que es la aplicación e irá enfocada a los destinatarios finales.
Por ello ha de tener en cuenta lo siguiente:

### BACKEND - API REST con SPRING - Proyecto 2ºDAM

<img src="https://img.shields.io/badge/Spring--Framework-5.7-green"/> <img src="https://img.shields.io/badge/Apache--Maven-3.8.6-blue"/> <img src="https://img.shields.io/badge/Java-17.0-brightgreen"/>

 <img src="https://niixer.com/wp-content/uploads/2020/11/spring-boot.png" width="500" alt="Spring Logo"/>
 
___
Ha de tener en cuenta que el backend se encuentra realizado con una versiónd de java 17, para más información puedes entrar en la carpeta de [PlayFutDay](https://github.com/MaylorSr/PDMA_PlayFutDay/tree/release_1.0/playfutday)

### MOBILE - FLUTTER - Proyecto 2ºDAM

<img src="https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png" width="500" alt="Flutter Logo"/>

___
Ha de tener en cuenta que la parte del mobile se encuentra realizado con (versión de Dart de 3.0.0 y de Flutter la 3.8.0-13.0.pre.74) , para más información puedes entrar en la carpeta de [Playfutday_mobile](https://github.com/MaylorSr/PDMA_PlayFutDay/tree/release_1.0/playfutday_mobile) , donde encontrarás el PDF con el plan de empresa, historias de usuarios, modelo de datos, etc.

### WEB - ANGULAR - Proyecto 2ºDAM

<img src="https://user-images.githubusercontent.com/93126452/228478221-9fdd0b24-7755-4506-99cb-278dd1a4ee36.png" width="250" alt="Angular Logo"/>

___
Ha de tener en cuenta que la parte de web se encuentra realizado con Angular, con una versiones... Angular: 15.2.4, Nodejs: 18.15.0 , para más información puedes entrar en la carpeta de [PlayFutDay_web](https://github.com/MaylorSr/PDMA_PlayFutDay/tree/release_1.0/playfutday_web) <br>


## **EJECUCIÓN DEL PROYECTO** :speech_balloon:
Para llevar a cabo la ejecución del proyecto, necesitarás las versiones mencionadas anteriormente. En primer lugar necestirás clonarte el proyecto, abrir en Sprin Boot la carpeta de playfutday , en ella deberás iniciar el proyecto, una vez iniciado la parte del backend, podrás realizar en tu terminarl, "flutter pub get" para obtener las dependencias necesarias y porteriormente "flutter run".

