# PLAYFUTDAY
### Front con FLUTTER - Proyecto 2ºDAM

<img src="https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png" width="500" alt="Flutter Logo"/>
 
___

## **Documentación**
:point_right: [Dirección API](https://github.com/MaylorSr/PDMA_PlayFutDay/tree/main/playfutday)<br>
:point_right: [Dirección WEB](https://github.com/MaylorSr/PDMA_PlayFutDay/tree/main/playfutday_web)<br>

## **DESCRIPCIÓN DEL PROYECTO** :speech_balloon:

Este es un proyecto práctico que consiste en el desarrollo **Fronted** con Flutter (versión de Dart de 3.0.0 y de Flutter la 3.0.0-109.0.dev < 4.0.0) del consumo de una **API REST** en lenguaje java desarrollada con Spring Boot.

Se ha puesto en práctica el uso de los Bloc, Cubit con Flutter, Widgets, manejos de estados, uso de librerías externas y consumo de una Api Rest.<br>
Para iniciar el proyecto una vez descargado deberás ejecutar el comando flutter run<br>

El proyecto trata de una red social para personas amantes al fútbol, donde estos podrán crear un post, comentar un post, dar like a un post, ver sus favoritos... Entre otras funcionalidades comúnes... Por ello, se ha inspirado en redes sociales actuales para implementar el nivel visual de estas para el lector, tales como **Instagram   <img src="https://simpleicons.org/icons/instagram.svg" alt="Instagram Icon" width="30" height="30" style="fill: #E4405F;">
 y Twitter <img src="https://simpleicons.org/icons/twitter.svg" alt="Instagram Icon" width="30" height="30" style="fill: #E4405F;"> **. <br>
 Además de incluír una lógica de negocio de una mezcla entre ambas. <br>
 -Se te proporcionará usuarios para que puedas probarlos:<br>
```
ADMINS: usuario: marta - password: M1n2345 || usuario: david  - password: D1a2345
USERS: usuario: alejandro  - password: A1b2345 || usuario: laura  - password: L1u2345
```
<br>En el import.sql encontrarás más usuarios si así deseas probar más, las contraseñas de cada usuario se econtrará comentada por encima del insert de cada uno de estos.<br>
 ___
## **EJECUCIÓN DEL PROYECTO** :speech_balloon:
Deberás ingresar en la carpeta **playfutday_mobile** , una vez dentro deberás de abrir el terminal en dicha raíz y escribir **flutter pub get** para instalar todas las dependencias necesarias y posteriormente deberás realizar **flutter run** con un dispositivo seleccionado.<br>

**ACCIONES QUE SERÁS CAPAZ DE REALIZAR :**
* Obtener todos los posts:
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/all_post.gif"/>
</p>

* Cambiar contraseña
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/change_password.gif"/>
</p>

* Comentar y dar like a un todos los posts (excepto desde search)
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/comment_like_all_post.gif"/>
</p>

* Eliminar mi cuenta de usuario
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/delete_account.gif"/>
</p>

* Eliminar mi post
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/delete_post.gif"/>
</p>

* Editar mi fecha de cumpleaños y número de teléfono
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/edit_phone_birthday.gif"/>
</p>

* Editar foto de perfil y bio
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/edit_photo_bio.gif"/>
</p>

* Follow / unFollow y enviar mensaje a un usuario
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/follow_send_message.gif"/>
</p>

* Ver Followers y Follows tanto mios como de otro usuario
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/follower_follow.gif"/>
</p>

* Ver mis chats
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/get_chats.gif"/>
</p>

* Ir al perfil de un usuario, ver sus posts, y refrescar la lista de post del usuario
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/go_to_profile_view_post_refres_post.gif"/>
</p>

* Logearte
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/login.gif"/>
</p>

* Ver mis post a los que le di fav
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/my_fav_post.gif"/>
</p>

* Ver mi perfil
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/my_profile.gif"/>
</p>


* Subir un post
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/new_post.gif"/>
</p>


* Refrescar la lista de todos los posts
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/refresh_all_post.gif"/>
</p>


* Buscar post por tag, ya sea en minúscula o mayúscula
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/search_by_tag.gif"/>
</p>


* Buscar post por tag, ya sea en minúscula o mayúscula
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/search_by_tag.gif"/>
</p>

* Registrarse con código de verificación
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/sing_up_email.gif"/>
</p>


* Código de verificación
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/verify_code.gif"/>
</p>

* Lógin luego de código de verificación
<p>
  <img src="https://github.com/MaylorSr/PDMA_PlayFutDay/blob/main/PlanEmpresa/screen_flutter_mobile/login_after_sing_up.gif"/>
</p>

























