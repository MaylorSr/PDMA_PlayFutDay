import { Component, OnInit } from "@angular/core";
import { TokenStorageService } from "../_services/token-storage.service";
import { UserService } from "../_services/user.service";
import { ChangePasswordResponse } from "../interfaces/user/changePassword";
import { environment } from "../../environments/environment.prod";
import { UserResponseInfo } from "../interfaces/user/user_info_id";
import { ErrorResponse } from "../interfaces/error/general_error";

@Component({
  selector: "app-settings",
  templateUrl: "./settings.component.html",
  styleUrls: ["./settings.component.css"],
})
export class SettingsComponent implements OnInit {
  file: any;
  imageUrl: string;
  bio: string = "";
  phone: string = "";
  oldPassword: string = "";
  newPassword: string = "";
  verifyPassword: string = "";
  showSuccesUpload: boolean = false;

  //****UserResponseInfo */
  user: UserResponseInfo = {} as UserResponseInfo;

  /**SHOW MESSAGE */
  showMessageUpdate = false;
  showErrorPhone: string = "";
  showErrorPhoneBool: boolean = false;
  showErrorBio: string = "";
  showErrorBioBool: boolean = false;

  showErrorPasswordBool: boolean = false;
  showErrorMessagePassword: string = "";

  ngOnInit(): void {
    this.uploadInfoUser();
  }
  getFile(event: any) {
    this.file = event.target.files[0];
    const reader = new FileReader();
    reader.onload = (e: any) => {
      this.imageUrl = e.target.result;
    };
    reader.readAsDataURL(this.file);
    console.log("the file is: ", this.file);
  }

  constructor(
    private userService: UserService,
    private tokenService: TokenStorageService
  ) {}

  sendForm() {
    if (this.bio != this.tokenService.getUser().biography) {
      this.userService.changeBio(this.bio).subscribe({
        next: (updateBio) => {
          this.bio == updateBio;
          this.showErrorBioBool = false;
          this.showSuccesUpload = true;
          setTimeout(() => {
            this.showSuccesUpload = false;
          }, 1500);
        },
        error: (err) => {
          this.showErrorBio = err.error.message;
          this.showErrorBioBool = true;
        },
      });
    }
    if (this.phone != "" && this.phone != this.tokenService.getUser().phone) {
      this.userService.changePhone(this.phone).subscribe({
        next: (updatePhone) => {
          this.phone == updatePhone;
          this.showErrorPhoneBool = false;
          this.showSuccesUpload = true;
          setTimeout(() => {
            this.showSuccesUpload = false;
          }, 1500);
        },
        error: (err) => {
          const error: ErrorResponse = {
            statusCode: err.error.statusCode,
            date: Date(),
            message: err.error.message,
            path: err.error.path,
            status: err.error.status,
            subErrors: err.error.subErrors ?? [],
          };

          if (error.subErrors) {
            for (let index = 0; index < error.subErrors.length; index++) {
              const errorMessage = error.subErrors[index].message;
              if (this.showErrorPhone != errorMessage) {
                this.showErrorPhone += errorMessage + " ";
              }
            }
          } else {
            this.showErrorPhoneBool = err.error.message;
          }

          this.showErrorPhoneBool = true;
        },
      });
    }
    if (
      this.oldPassword != "" &&
      this.newPassword != "" &&
      this.verifyPassword != ""
    ) {
      const changePassword: ChangePasswordResponse = {
        oldPassword: this.oldPassword,
        newPassword: this.newPassword,
        verifyNewPassword: this.verifyPassword,
      };
      this.userService.changePassword(changePassword).subscribe({
        next: (updatePassword) => {
          console.log(changePassword);
          this.showSuccesUpload = true;
          setTimeout(() => {
            this.showSuccesUpload = false;
          }, 1500);
        },
        error: (err) => {
          const error: ErrorResponse = {
            statusCode: err.error.statusCode,
            date: Date(),
            message: err.error.message,
            path: err.error.path,
            status: err.error.status,
            subErrors: err.error.subErrors ?? [],
          };

          if (error.subErrors) {
            for (let index = 0; index < error.subErrors.length; index++) {
              const errorMessage = error.subErrors[index].message;
              if (this.showErrorMessagePassword != errorMessage) {
                this.showErrorMessagePassword += errorMessage + " ";
              }
            }
          } else {
            this.showErrorMessagePassword = err.error.message;
          }

          this.showErrorPasswordBool = true;
        },
      });
    }

    if (this.file) {
      this.userService.changeAvatar(this.file).subscribe({
        next: (data) => {
          this.showSuccesUpload = true;
          setTimeout(() => {
            this.showSuccesUpload = false;
          }, 1500);
        },
        error: (err) => {},
      });
    }
  }

  uploadInfoUser() {
    this.userService.getProfile().subscribe((data) => {
      this.bio = data.biography;
      this.phone = data.phone;
      this.imageUrl = `${environment.api_image}${data.avatar}`;
    });
  }
}
