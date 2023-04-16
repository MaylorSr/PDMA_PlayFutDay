import { Component, OnInit } from "@angular/core";
import { TokenStorageService } from "../../_services/token-storage.service";
import { Router } from "@angular/router";

declare interface RouteInfo {
  path: string;
  title: string;
  icon: string;
  class: string;
}
export const ROUTES: RouteInfo[] = [
  {
    path: "/playfutday/dashboard",
    title: "Dashboard",
    icon: "design_app",
    class: "",
  },
  {
    path: "/playfutday/post-list",
    title: "Posts",
    icon: "files_single-copy-04",
    class: "",
  },

  {
    path: "/playfutday/user-list",
    title: "Users",
    icon: "users_circle-08",
    class: "",
  },
];

@Component({
  selector: "app-sidebar",
  templateUrl: "./sidebar.component.html",
  styleUrls: ["./sidebar.component.css"],
})
export class SidebarComponent implements OnInit {
  menuItems: any[];

  constructor(
    private tokenStorageService: TokenStorageService,
    private router: Router
  ) {}

  ngOnInit() {
    this.menuItems = ROUTES.filter((menuItem) => menuItem);
  }
  isMobileMenu() {
    if (window.innerWidth > 991) {
      return false;
    }
    return true;
  }

  logout(): void {
    this.tokenStorageService.signOut();
    this.router.navigate(["/auth/login"]);
  }
}
