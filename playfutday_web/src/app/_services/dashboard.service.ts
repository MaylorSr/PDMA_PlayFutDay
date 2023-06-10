import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { TokenStorageService } from "./token-storage.service";
import { environment } from "../../environments/environment.prod";
import { Observable } from "rxjs-compat";
import { StateUserResponse } from "../interfaces/dashboard/state_user";
import { TotalUserAccountCreatedResponse } from "../interfaces/dashboard/total_users_account_created";
const API_URL = environment.api_hosting + "/";

@Injectable({
  providedIn: "root",
})
export class DashBoardService {
  constructor(
    private http: HttpClient,
    private tokenService: TokenStorageService
  ) {}

  getAllUserStateInApp(): Observable<StateUserResponse[]> {
    return this.http.get<StateUserResponse[]>(`${API_URL}user/list/state/now`);
  }

  getTotalAccountsCreatedByYear(
    year: number
  ): Observable<TotalUserAccountCreatedResponse[]> {
    return this.http.get<TotalUserAccountCreatedResponse[]>(
      `${API_URL}user/create/year/${year}`
    );
  }

  getTotalPostByNumberMonth(month: number): Observable<number> {
    return this.http.get<number>(`${API_URL}post/total/post/${month}`);
  }
}
