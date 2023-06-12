import {
  HTTP_INTERCEPTORS,
  HttpClient,
  HttpErrorResponse,
  HttpEvent,
  HttpHeaders,
} from "@angular/common/http";
import { Injectable } from "@angular/core";
import {
  HttpInterceptor,
  HttpHandler,
  HttpRequest,
} from "@angular/common/http";

import { TokenStorageService } from "../_services/token-storage.service";
import { Observable, throwError } from "rxjs";
import { catchError, switchMap } from "rxjs/operators";
import { RefreshTokenResponse } from "../interfaces/refresh/refresh_token_model";
import { environment } from "../../environments/environment.prod";
import { Router } from "@angular/router";
import { AuthService } from "../_services/auth.service";

const TOKEN_HEADER_KEY = "Authorization"; // for Spring Boot back-end

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  constructor(
    private token: TokenStorageService,
    private authService: AuthService,
    private router: Router
  ) {}

  intercept(
    req: HttpRequest<unknown>,
    next: HttpHandler
  ): Observable<HttpEvent<unknown>> {
    let authReq = req;
    const token = this.token.getToken();
    if (token != null) {
      authReq = req.clone({
        headers: req.headers.set(TOKEN_HEADER_KEY, "Bearer " + token),
      });
    }

    return next.handle(authReq).pipe(
      catchError((err: HttpErrorResponse) => {
        if (err.status === 401 || err.status === 403) {
          console.log(err.status);
          const refreshToken: RefreshTokenResponse = {
            refreshToken: this.token.getRefreshToken(),
          };

          return this.authService.refreshToken(refreshToken.refreshToken).pipe(
            switchMap((res: any) => {
              new TokenStorageService().saveToken(res.token);
              new TokenStorageService().saveRefreshToken(res.refreshToken);
              return next.handle(
                req.clone({
                  headers: req.headers.set(
                    TOKEN_HEADER_KEY,
                    "Bearer " + res.token
                  ),
                })
              );
            }),
            catchError((err) => {
              this.logout();
              return throwError(err);
            })
          );
        }
      })
    );
  }

  logout(): void {
    new TokenStorageService().signOut();
    this.router.navigate(["/auth/login"]);
  }
}

export const authInterceptorProviders = [
  { provide: HTTP_INTERCEPTORS, useClass: AuthInterceptor, multi: true },
];
