import { Injectable } from '@angular/core';
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
export class AccessDeniedGuard implements CanActivate {
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
    return this.checkLoginSucces();
  }

  checkLoginSucces(): boolean {
    const token = this.tokenService.getToken();
    const { roles = [] } = this.tokenService.getUser();

    if (token == null) {
      this.router.navigate(['auth']);
      return false;
    } else if (this.tokenService.getToken != null && roles.includes('ADMIN')) {
      this.router.navigate(['playfutday']);
      return false;
    }
    return true;
  }
}
