import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { UserListResponse, UserResponse } from "../interfaces/user/user_list";
import { environment } from "../../environments/environment.prod";
import { UserResponseInfo } from "../interfaces/user/user_info_id";
import { UserFollowResponse } from "../interfaces/user/user_follow";
import { LastThreeCommentaries } from "../interfaces/commentaries/last_three_commentaries";
import { PostListByUserName } from "../interfaces/post/post_user_by_username";
import { ChangePasswordResponse } from "../interfaces/user/changePassword";
// import { environment } from '../../environments/environment';

const API_URL = environment.api_hosting + "/";

@Injectable({
  providedIn: "root",
})
export class UserService {
  constructor(private http: HttpClient) {}

  getListPeople(page: number): Observable<UserListResponse> {
    return this.http.get<UserListResponse>(`${API_URL}user?page=${page}`);
  }

  getListPostByUserName(
    page: number,
    username: string
  ): Observable<PostListByUserName> {
    return this.http.get<PostListByUserName>(
      `${API_URL}post/user/${username}?page=${page}`
    );
  }

  getProfile(): Observable<UserResponseInfo> {
    return this.http.get<UserResponseInfo>(API_URL + "me");
  }

  /**
   * NO HACE FALTA EL MODELO
   * @param id_user
   * @returns
   */

  banUser(id_user: string) {
    console.log("lo llama");
    return this.http.post(`${API_URL}banUserByAdmin/${id_user}`, null);
  }

  changeRoles(id_user: string) {
    console.log("lo llama");
    return this.http.post(`${API_URL}changeRole/${id_user}`, null);
  }

  deleteUser(id_user: string) {
    console.log("llama al metodo");
    return this.http.delete(`${API_URL}user/${id_user}`);
  }

  getInfoUser(id_user: string): Observable<UserResponseInfo> {
    // {{baseUrl}}/info/user/51057cde-9852-4cd5-be5e-091979495656
    return this.http.get<UserResponseInfo>(`${API_URL}info/user/${id_user}`);
  }

  getFolloweresByIdUser(
    id_user: string,
    page: number
  ): Observable<UserFollowResponse> {
    return this.http.get<UserFollowResponse>(
      `${API_URL}user/followers/${id_user}?page=${page}`
    );
  }

  getFollowsByIdUser(
    id_user: string,
    page: number
  ): Observable<UserFollowResponse> {
    return this.http.get<UserFollowResponse>(
      `${API_URL}user/follows/${id_user}?page=${page}`
    );
  }

  getLasThreeCommentariesByUserId(
    id_user: String
  ): Observable<LastThreeCommentaries[]> {
    return this.http.get<LastThreeCommentaries[]>(
      `${API_URL}user/list/comments/${id_user}`
    );
  }

  changeBio(bio: string): Observable<String> {
    return this.http.put<String>(`${API_URL}edit/bio`, bio);
  }

  changePhone(phone: string): Observable<String> {
    return this.http.put<String>(`${API_URL}edit/phone`, phone);
  }

  changePassword(
    body: ChangePasswordResponse
  ): Observable<ChangePasswordResponse> {
    return this.http.put<ChangePasswordResponse>(
      `${API_URL}user/changePassword`,
      body
    );
  }
}
