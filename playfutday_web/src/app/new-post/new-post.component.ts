import { Component, ElementRef, ViewChild } from "@angular/core";
import { PostService } from "../_services/post.service";

@Component({
  selector: "app-new-post",
  templateUrl: "./new-post.component.html",
  styleUrls: ["./new-post.component.css"],
})
export class NewPostComponent {
  @ViewChild("tag") tagInput: ElementRef; // Referencia local para el campo de etiqueta
  @ViewChild("description") descriptionInput: ElementRef;
  @ViewChild("fileInput") fileInput: ElementRef; // Referencia local para el campo de archivo de imagen

  // Referencia local para el campo de descripción

  hide = false;
  errorMessage = "MUESTRAME EL ERROR";

  constructor(private postService: PostService) {}
  /**
   * Se crea una archivo file y una imagenUrl para el cambio dinámico de la imágen que tenemos por defecto
   */
  file: any;
  imageUrl: string;
  /**
   * Una vez recibe la imagen, se coge la primera, se crea un FileReader que es que simplemente sirve para leer archivos.
   * el metodo onload lo que hace es decirle a ese reader que el valor de la imagen es el resultado de la imagen seleccionada,
   * una vez asiganada a imageUrl el valor file, lo que hace es que lo lee en data url.
   * @param event Recibe un evento ya sea click o drag and drop
   */
  getFile(event: any) {
    this.file = event.target.files[0];
    const reader = new FileReader();
    reader.onload = (e: any) => {
      this.imageUrl = e.target.result;
    };
    reader.readAsDataURL(this.file);
  }

  updatePost() {
    const tag = this.tagInput.nativeElement.value;
    const description = this.descriptionInput.nativeElement.value;
    const fileInput = this.fileInput.nativeElement;

    if (fileInput.files && fileInput.files.length > 0) {
      const file = fileInput.files[0];
      this.postService.requestPost(tag, description, file).subscribe({
        next(_) {
          this.hide = false;
          window.location.reload();
        },
        error(error) {
          this.hide = true;
          this.errorMessage = error.message;
        },
      });
  
    } else {
      this.hide = true;
      this.errorMessage = "No file selected";
    }
  }
}
