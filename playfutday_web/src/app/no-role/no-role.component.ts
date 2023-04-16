import { Component } from "@angular/core";
import { Router } from "@angular/router";
import { TokenStorageService } from "../_services/token-storage.service";

@Component({
  selector: "app-no-role",
  templateUrl: "./no-role.component.html",
  styleUrls: ["./no-role.component.css"],
})
export class NoRoleComponent {
  constructor(
    private tokenStorageService: TokenStorageService,
    private router: Router
  ) {}

  logout(): void {
    this.tokenStorageService.signOut();
    this.router.navigate(["/auth/login"]);
  }
}
