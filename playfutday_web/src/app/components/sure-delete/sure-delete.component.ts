// sure-delete.component.ts
import { Component, Inject, OnInit } from "@angular/core";
import { MAT_DIALOG_DATA, MatDialogRef } from "@angular/material/dialog";
import { PostService } from "../../_services/post.service";
import { UserService } from "../../_services/user.service";
import { UserResponseInfo } from "../../interfaces/user/user_info_id";

@Component({
  selector: "app-sure-delete",
  templateUrl: "./sure-delete.component.html",
  styleUrls: ["./sure-delete.component.css"],
})
export class SureDeleteComponent implements OnInit {
  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<SureDeleteComponent>,
    private userService: UserService,
    private postService: PostService
  ) {}
  dataName: string = "";
  typeData: string = "";
  u: UserResponseInfo = {} as UserResponseInfo;

  comprobarEntidad() {
    if (this.data.dataInfo.username) {
      this.dataName = this.data.dataInfo.username;
      this.typeData = "user";
    } else if (this.data.dataInfo.tag) {
      this.typeData = "post";
    } else {
      this.typeData = "commentarie";
    }
  }

  ngOnInit(): void {
    this.comprobarEntidad();
  }

  closeDialog(): void {
    this.dialogRef.close();
  }

  deleteType() {
    if (this.data.dataInfo.username) {
      this.userService.deleteUser(this.data.dataInfo.id).subscribe(
        (response) => {
          // Aquí puedes manejar la respuesta exitosa si es necesario
          console.log("Usuario eliminado:", response);
        },
        (error) => {
          // Aquí puedes manejar el error si ocurre
          console.log(error);
        }
      );
    } else if (this.data.dataInfo.tag) {
      this.postService
        .deletePost(this.data.dataInfo.id, this.data.dataInfo.idAuthor)
        .subscribe(
          (response) => {
            // Aquí puedes manejar la respuesta exitosa si es necesario
            console.log("Post eliminado:", response);
          },
          (error) => {
            // Aquí puedes manejar el error si ocurre
            console.log(error);
          }
        );
    } else {
      this.postService.deleteCommentarie(this.data.dataInfo.id).subscribe(
        (response) => {
          console.log("Comentario eliminado");
        },
        (error) => {
          console.log(error.message);
        }
      );
    }
  }
}
