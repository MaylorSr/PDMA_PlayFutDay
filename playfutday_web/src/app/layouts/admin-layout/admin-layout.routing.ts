import { Routes } from "@angular/router";

import { DashboardComponent } from "../../dashboard/dashboard.component";
import { ListPostComponent } from "../../list-post/list-post.component";
import { ListUserComponent } from "../../list-user/list-user.component";
import { UserInfoComponent } from "../../info/user-info/user-info.component";
import { NewPostComponent } from "../../new-post/new-post.component";
import { PostInfoComponent } from "../../info/post-info/post-info.component";
import { ListCommentariesComponent } from "../../list-commentaries/list-commentaries.component";
import { SettingsComponent } from "../../settings/settings.component";

export const AdminLayoutRoutes: Routes = [
  { path: "dashboard", component: DashboardComponent },
  { path: "post-list", component: ListPostComponent },
  { path: "user-list", component: ListUserComponent },
  { path: "user-info/:id", component: UserInfoComponent },
  { path: "new-post", component: NewPostComponent },
  { path: "post-info/:id", component: PostInfoComponent },
  { path: "commentaries-list", component: ListCommentariesComponent },
  { path: "settings", component: SettingsComponent },
  { path: "", redirectTo: "/playfutday/dashboard", pathMatch: "full" },
  { path: "**", redirectTo: "dashboard", pathMatch: "full" },
];
