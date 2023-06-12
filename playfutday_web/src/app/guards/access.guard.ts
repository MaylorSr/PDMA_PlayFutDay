import { Injectable, OnInit } from '@angular/core';
import {
  ActivatedRouteSnapshot,
  CanActivate,
  Router,
  RouterStateSnapshot,
  UrlTree,
} from '@angular/router';
import { Observable } from 'rxjs';
import { TokenStorageService } from '../_services/token-storage.service';

@Injectable({
  providedIn: 'root',
})
export class AccessGuard implements CanActivate {
  constructor(
    private router: Router,
    private tokenService: TokenStorageService
  ) {}
  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ):
    | Observable<boolean | UrlTree>
    | Promise<boolean | UrlTree>
    | boolean
    | UrlTree {
    return this.checkUserLoginAdmin(route);
  }

  checkUserLoginAdmin(route: ActivatedRouteSnapshot): boolean {
    const { roles = [] } = this.tokenService.getUser();

    if (this.tokenService.getToken() == null) {
      this.router.navigate(['auth']);
      return false;
    } else if (
      this.tokenService.getToken != null &&
      !roles.includes(route.data['role'])
    ) {
      this.router.navigate(['/', 'acces_denied']);
      return false;
    }
    return true;
  }
}
