import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './views/auth/login/login.component';
import { DashboardComponent } from './views/dashboard/dashboard.component';
import { AccessGuard } from './access.guard';
import { NoRoleComponent } from './views/no-role/no-role.component';
import { AccessLoginGuard } from './access-login.guard';
import { AccessDeniedGuard } from './access-denied.guard';
import { ListUserComponent } from './views/list-user/list-user.component';
import { ListPostComponent } from './views/list-post/list-post.component';
import { UserInfoComponent } from './views/info/user-info/user-info.component';
import { PostInfoComponent } from './views/info/post-info/post-info.component';
const routes: Routes = [
  {
    path: '',
    redirectTo: 'auth',
    pathMatch: 'full',
  },
  {
    path: 'acces_denied',
    canActivate: [AccessDeniedGuard],
    component: NoRoleComponent,
  },
  {
    path: 'playfutday',
    data: {
      role: 'ADMIN',
    },
    canActivate: [AccessGuard],
    children: [
      { path: 'dashboard', component: DashboardComponent },
      { path: 'list-user', component: ListUserComponent },
      { path: 'list-post', component: ListPostComponent },
      { path: 'user-info/:id', component: UserInfoComponent },
      { path: 'post-info/:id', component: PostInfoComponent },

      { path: '', redirectTo: '/playfutday/dashboard', pathMatch: 'full' },
      { path: '**', redirectTo: 'dashboard', pathMatch: 'full' },
    ],
  },
  {
    path: 'auth',
    canActivate: [AccessLoginGuard],
    children: [
      { path: 'login', component: LoginComponent },
      { path: '', redirectTo: '/auth/login', pathMatch: 'full' },
      { path: '**', redirectTo: 'login', pathMatch: 'full' },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
