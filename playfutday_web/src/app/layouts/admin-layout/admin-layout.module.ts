import { NgModule } from "@angular/core";
import { RouterModule } from "@angular/router";
import { CommonModule } from "@angular/common";
import { FormsModule } from "@angular/forms";
import { AdminLayoutRoutes } from "./admin-layout.routing";
import { DashboardComponent } from "../../dashboard/dashboard.component";
import { UserProfileComponent } from "../../user-profile/user-profile.component";
import { ChartsModule } from "ng2-charts";
import { NgbModule } from "@ng-bootstrap/ng-bootstrap";
import { ToastrModule } from "ngx-toastr";
import { UpgradeComponent } from "../../upgrade/upgrade.component";
import { ListPostComponent } from "../../list-post/list-post.component";
import { MaterialsImportModule } from "../../materials-import/materials-import.module";
import { ListUserComponent } from "../../list-user/list-user.component";
import { UserInfoComponent } from "../../info/user-info/user-info.component";
import { NewPostComponent } from "../../new-post/new-post.component";
import { PostInfoComponent } from "../../info/post-info/post-info.component";
import { ListCommentariesComponent } from "../../list-commentaries/list-commentaries.component";
import { SettingsComponent } from "../../settings/settings.component";

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
    ListCommentariesComponent,
    PostInfoComponent,
    ListUserComponent,
    SettingsComponent,
    UpgradeComponent,
  ],
})
export class AdminLayoutModule {}
