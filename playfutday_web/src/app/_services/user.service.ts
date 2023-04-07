import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../environments/environment.prod';
import { UserLog } from '../interfaces/user/user_log';

const API_URL = environment.api_hosting + '/';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  constructor(private http: HttpClient) {}

  // getPublicContent(): Observable<any> {
  //   return this.http.get(API_URL + 'all', { responseType: 'text' });
  // }

  // getUserBoard(): Observable<any> {
  //   return this.http.get(API_URL + 'user', { responseType: 'text' });
  // }

  // getModeratorBoard(): Observable<any> {
  //   return this.http.get(API_URL + 'mod', { responseType: 'text' });
  // }

  // getAdminBoard(): Observable<any> {
  //   return this.http.get(API_URL + 'admin', { responseType: 'text' });
  // }

  // getListPeople(page: number): Observable<ActorRespon> {
  //   return this.http.get<ActorRespon>(`${API_URL}/user?page=${page}`);
  // }

  getProfile(): Observable<UserLog> {
    return this.http.get<UserLog>(API_URL + 'me');
  }
}
