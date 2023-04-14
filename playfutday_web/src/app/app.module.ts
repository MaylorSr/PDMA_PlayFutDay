import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';

import { AppRoutingModule } from './app-routing.module';
import { Ng2SearchPipeModule } from 'ng2-search-filter';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { FormsModule } from '@angular/forms';
import { MaterialsImportModule } from './materials-import/materials-import.module';

import { authInterceptorProviders } from './_helpers/auth.interceptor';
import { LoginComponent } from './views/auth/login/login.component';
import { FlexLayoutModule } from '@angular/flex-layout';
import { NavBarComponent } from './components/nav-bar/nav-bar.component';
import { UserDropdownComponent } from './components/dropdwons/user-dropdown/user-dropdown.component';
import { TopBarComponent } from './components/top-bar/top-bar.component';
import { DashboardComponent } from './views/dashboard/dashboard.component';
import { NoRoleComponent } from './views/no-role/no-role.component';
import { ListUserComponent } from './views/list-user/list-user.component';
import { NgxSpinner, NgxSpinnerModule } from 'ngx-spinner';
import { SureDeleteComponent } from './views/sure-delete/sure-delete.component';
import { ListPostComponent } from './views/list-post/list-post.component';
import { UserInfoComponent } from './views/info/user-info/user-info.component';
import { PostInfoComponent } from './views/info/post-info/post-info.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    NavBarComponent,
    UserDropdownComponent,
    TopBarComponent,
    DashboardComponent,
    NoRoleComponent,
    ListUserComponent,
    SureDeleteComponent,
    ListPostComponent,
    UserInfoComponent,
    PostInfoComponent
  ],
  imports: [
    NgxSpinnerModule,
    BrowserModule,
    AppRoutingModule,
    FlexLayoutModule,
    FormsModule,
    HttpClientModule,
    MaterialsImportModule,
    BrowserAnimationsModule,
    Ng2SearchPipeModule,
  ],
  providers: [authInterceptorProviders],
  bootstrap: [AppComponent],
})
export class AppModule {}
