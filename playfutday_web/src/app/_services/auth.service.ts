import { Injectable } from "@angular/core";
import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Observable, throwError } from "rxjs";
import { environment } from "../../environments/environment.prod";
import { catchError, switchMap } from "rxjs/operators";
import { TokenStorageService } from "./token-storage.service";
import { Router } from "@angular/router";

const AUTH_API = environment.api_hosting + /auth/;
const AUTH_API_REFRESH = environment.api_hosting + /refresh/;

const httpOptions = {
  headers: new HttpHeaders({ "Content-Type": "application/json" }),
};

@Injectable({
  providedIn: "root",
})
export class AuthService {
  constructor(private http: HttpClient) {}

  login(username: string, password: string): Observable<any> {
    console.log(`Login: username=${username}, password=${password}`);
    return this.http.post(
      AUTH_API + "login",
      {
        username,
        password,
      },
      httpOptions
    );
  }

  refreshToken(refreshToken: string) {
    return this.http.post(
      AUTH_API_REFRESH + "token",
      { refreshToken },
      httpOptions
      // { withCredentials: false }
    );
  }
}
