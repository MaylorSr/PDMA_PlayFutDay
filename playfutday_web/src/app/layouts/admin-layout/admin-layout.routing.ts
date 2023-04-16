import { Routes } from "@angular/router";

import { DashboardComponent } from "../../dashboard/dashboard.component";
import { UserProfileComponent } from "../../user-profile/user-profile.component";
import { TypographyComponent } from "../../typography/typography.component";
import { IconsComponent } from "../../icons/icons.component";
import { MapsComponent } from "../../maps/maps.component";
import { NotificationsComponent } from "../../notifications/notifications.component";
import { UpgradeComponent } from "../../upgrade/upgrade.component";
import { ListPostComponent } from "../../list-post/list-post.component";
import { ListUserComponent } from "../../list-user/list-user.component";
// import { PostInfoComponent } from "../../info/post-info/post-info.component";
import { UserInfoComponent } from "../../info/user-info/user-info.component";
import { NewPostComponent } from "../../new-post/new-post.component";

export const AdminLayoutRoutes: Routes = [
  { path: "dashboard", component: DashboardComponent },
  { path: "post-list", component: ListPostComponent },
  // { path: "user-profile", component: UserProfileComponent },
  { path: "user-list", component: ListUserComponent },
  { path: "user-info/:id", component: UserInfoComponent },
  { path: "new-post", component: NewPostComponent },
  // { path: "post-info/:id", component: PostInfoComponent },

  // { path: "typography", component: TypographyComponent },
  // { path: "icons", component: IconsComponent },
  // { path: "maps", component: MapsComponent },
  // { path: "notifications", component: NotificationsComponent },
  // { path: "upgrade", component: UpgradeComponent },
  { path: "", redirectTo: "/playfutday/dashboard", pathMatch: "full" },
  { path: "**", redirectTo: "dashboard", pathMatch: "full" },
];
