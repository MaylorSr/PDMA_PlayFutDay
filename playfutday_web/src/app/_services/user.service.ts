import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../environments/environment.prod';
import { UserLog } from '../interfaces/user/user_log';
import { UserListResponse } from '../interfaces/user/user_list';

const API_URL = environment.api_hosting + '/';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  constructor(private http: HttpClient) {}

  getListPeople(page: number): Observable<UserListResponse> {
    return this.http.get<UserListResponse>(`${API_URL}user?page=${page}`);
  }

  getProfile(): Observable<UserLog> {
    return this.http.get<UserLog>(API_URL + 'me');
  }
}
