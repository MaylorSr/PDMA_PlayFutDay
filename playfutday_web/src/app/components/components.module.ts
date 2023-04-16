import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { RouterModule } from "@angular/router";
import { NgbModule } from "@ng-bootstrap/ng-bootstrap";

import { FooterComponent } from "./footer/footer.component";
import { NavbarComponent } from "./navbar/navbar.component";
import { SidebarComponent } from "./sidebar/sidebar.component";
import { MaterialsImportModule } from "../materials-import/materials-import.module";
import { SureDeleteComponent } from "./sure-delete/sure-delete.component";

@NgModule({
  imports: [CommonModule, RouterModule, NgbModule, MaterialsImportModule],
  declarations: [
    FooterComponent,
    NavbarComponent,
    SidebarComponent,
    SureDeleteComponent
  ],
  exports: [
    FooterComponent,
    NavbarComponent,
    SidebarComponent,
    SureDeleteComponent
  ],
})
export class ComponentsModule {}
