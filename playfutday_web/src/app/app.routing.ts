import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { BrowserModule } from "@angular/platform-browser";
import { Routes, RouterModule } from "@angular/router";

import { AdminLayoutComponent } from "./layouts/admin-layout/admin-layout.component";
import { AccessLoginGuard } from "./guards/access-login.guard";
import { LoginComponent } from "./login/login.component";
import { AccessDeniedGuard } from "./guards/access-denied.guard";
import { NoRoleComponent } from "./no-role/no-role.component";
import { AccessGuard } from "./guards/access.guard";

const routes: Routes = [
  {
    path: "",
    redirectTo: "auth",
    pathMatch: "full",
  },
  {
    path: "acces_denied",
    canActivate: [AccessDeniedGuard],
    component: NoRoleComponent,
  },

  {
    path: "playfutday",
    data: {
      role: "ADMIN",
    },
    canActivate: [AccessGuard],
    component: AdminLayoutComponent,
    children: [
      {
        path: "",
        loadChildren: () =>
          import("./layouts/admin-layout/admin-layout.module").then(
            (x) => x.AdminLayoutModule
          ),
      },
    ],
  },
  {
    path: "**",
    redirectTo: "auth",
  },
  {
    path: "auth",
    canActivate: [AccessLoginGuard],
    children: [
      { path: "login", component: LoginComponent },
      { path: "", redirectTo: "/auth/login", pathMatch: "full" },
      { path: "**", redirectTo: "login", pathMatch: "full" },
    ],
  },
];

@NgModule({
  imports: [CommonModule, BrowserModule, RouterModule.forRoot(routes)],
  exports: [],
})
export class AppRoutingModule {}
