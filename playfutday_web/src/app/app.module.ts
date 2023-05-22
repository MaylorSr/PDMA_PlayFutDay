import { BrowserAnimationsModule } from "@angular/platform-browser/animations";
import { NgModule } from "@angular/core";

import { FormsModule } from "@angular/forms";
import { HttpClientModule } from "@angular/common/http";
import { RouterModule } from "@angular/router";
import { NgbModule } from "@ng-bootstrap/ng-bootstrap";
import { ToastrModule } from "ngx-toastr";

import { AppRoutingModule } from "./app.routing";
import { ComponentsModule } from "./components/components.module";
import { ChartsModule } from "ng2-charts";

import { AppComponent } from "./app.component";

import { AdminLayoutComponent } from "./layouts/admin-layout/admin-layout.component";
import { MaterialsImportModule } from "./materials-import/materials-import.module";
import { authInterceptorProviders } from "./_helpers/auth.interceptor";
import { LoginComponent } from "./login/login.component";
import { NoRoleComponent } from "./no-role/no-role.component";
import { NgxChartsModule } from "@swimlane/ngx-charts";

@NgModule({
  imports: [
    BrowserAnimationsModule,
    NgxChartsModule,
    ChartsModule,
    FormsModule,
    HttpClientModule,
    ComponentsModule,
    RouterModule,
    MaterialsImportModule,
    AppRoutingModule,
    NgbModule,
    ToastrModule.forRoot(),
  ],
  declarations: [
    AppComponent,
    AdminLayoutComponent,
    LoginComponent,
    NoRoleComponent,
  ],
  providers: [authInterceptorProviders],
  bootstrap: [AppComponent],
})
export class AppModule {}
