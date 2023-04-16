import { NgModule } from "@angular/core";
import { RouterModule } from "@angular/router";
import { CommonModule } from "@angular/common";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { AdminLayoutRoutes } from "./admin-layout.routing";
import { DashboardComponent } from "../../dashboard/dashboard.component";
import { UserProfileComponent } from "../../user-profile/user-profile.component";
import { TypographyComponent } from "../../typography/typography.component";
import { IconsComponent } from "../../icons/icons.component";
import { MapsComponent } from "../../maps/maps.component";
import { NotificationsComponent } from "../../notifications/notifications.component";
import { ChartsModule } from "ng2-charts";
import { NgbModule } from "@ng-bootstrap/ng-bootstrap";
import { ToastrModule } from "ngx-toastr";
import { UpgradeComponent } from "../../upgrade/upgrade.component";
import { ListPostComponent } from "../../list-post/list-post.component";
import { MaterialsImportModule } from "../../materials-import/materials-import.module";
import { ListUserComponent } from "../../list-user/list-user.component";
import { UserInfoComponent } from "../../info/user-info/user-info.component";
import { NewPostComponent } from "../../new-post/new-post.component";
// import { PostInfoComponent } from "../../info/post-info/post-info.component";

@NgModule({
  imports: [
    CommonModule,
    MaterialsImportModule,
    RouterModule.forChild(AdminLayoutRoutes),
    FormsModule,
    ChartsModule,
    NgbModule,
    ToastrModule.forRoot(),
  ],
  declarations: [
    DashboardComponent,
    UserProfileComponent,
    ListPostComponent,
    UserInfoComponent,
    NewPostComponent,
    // PostInfoComponent,
    ListUserComponent,
    UpgradeComponent,
    // TypographyComponent,
    // IconsComponent,
    // MapsComponent,
    // NotificationsComponent,
  ],
})
export class AdminLayoutModule {}
