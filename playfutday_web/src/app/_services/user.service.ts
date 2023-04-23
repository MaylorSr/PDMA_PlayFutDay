import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { UserLog } from '../interfaces/user/user_log';
import { UserListResponse, UserResponse } from '../interfaces/user/user_list';
import { environment } from '../../environments/environment.prod';
import { UserResponseInfo } from '../interfaces/user/user_info_id';
// import { environment } from '../../environments/environment';

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

  /**
   * NO HACE FALTA EL MODELO
   * @param id_user
   * @returns
   */

  banUser(id_user: string) {
    console.log('lo llama');
    return this.http.post(`${API_URL}banUserByAdmin/${id_user}`, null);
  }

  changeRoles(id_user: string) {
    console.log('lo llama');
    return this.http.post(`${API_URL}changeRole/${id_user}`, null);
  }

  deleteUser(id_user: string) {
    console.log('llama al metodo');
    return this.http.delete(`${API_URL}user/${id_user}`);
  }

  getInfoUser(id_user: string): Observable<UserResponseInfo> {
    // {{baseUrl}}/info/user/51057cde-9852-4cd5-be5e-091979495656
    return this.http.get<UserResponseInfo>(`${API_URL}info/user/${id_user}`);
  }
}
