import { Component, OnInit } from "@angular/core";
import { PostService } from "../_services/post.service";
import { TokenStorageService } from "../_services/token-storage.service";
import { UserService } from "../_services/user.service";
import { ChangePasswordResponse } from "../interfaces/user/changePassword";

@Component({
  selector: "app-settings",
  templateUrl: "./settings.component.html",
  styleUrls: ["./settings.component.css"],
})
export class SettingsComponent implements OnInit {
  ngOnInit(): void {}

  file: any;
  imageUrl: string;

  bio: string = "";
  phone: string = "";
  oldPassword: string = "";
  newPassword: string = "";
  veryfiPassword: string = "";

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
    tokenService: TokenStorageService
  ) {}

  sendForm() {
    if (this.bio != "") {
      this.userService.changeBio(this.bio).subscribe(() => {});
    }
    if (this.phone != "") {
      this.userService.changePhone(this.phone).subscribe(() => {});
    }
    if (
      this.oldPassword != "" &&
      this.newPassword != "" &&
      this.veryfiPassword != ""
    ) {
      let changePassword: ChangePasswordResponse = {
        oldPassword: this.oldPassword,
        newPassword: this.newPassword,
        verifyNewPassword: this.veryfiPassword,
      };
      this.userService.changePassword(changePassword).subscribe(() => {});
    }
  }
}
