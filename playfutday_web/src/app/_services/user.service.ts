import { Injectable } from "@angular/core";
import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Observable } from "rxjs";
import { UserListResponse, UserResponse } from "../interfaces/user/user_list";
import { environment } from "../../environments/environment.prod";
import { UserResponseInfo } from "../interfaces/user/user_info_id";
import { UserFollowResponse } from "../interfaces/user/user_follow";
import { LastThreeCommentaries } from "../interfaces/commentaries/last_three_commentaries";
import { PostListByUserName } from "../interfaces/post/post_user_by_username";
import { ChangePasswordResponse } from "../interfaces/user/changePassword";
// import { environment } from '../../environments/environment';
import { ChangeDataUser } from "../interfaces/user/change_data";
import { TokenStorageService } from "./token-storage.service";
const API_URL = environment.api_hosting + "/";

@Injectable({
  providedIn: "root",
})
export class UserService {
  constructor(
    private http: HttpClient,
    private tokenService: TokenStorageService
  ) {}

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

  changeAvatar(image: File) {
    const formData = new FormData();
    formData.append("image", image); // Especificar el nombre del archivo y el tipo de archivo

    const headers = new HttpHeaders({
      Authorization: `Bearer ${this.tokenService.getToken()}`,
      // "Content-Type": "multipart/form-data",
      // "multipart/form-data; boundary=----WebKitFormBoundary<boundary>"
    });
    return this.http.post(`${API_URL}edit/avatar`, formData, { headers });
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
    const body: ChangeDataUser = {
      biography: bio,
      birthday: null,
      phone: null,
    };

    return this.http.put<String>(`${API_URL}edit/bio`, body);
  }

  changePhone(phone: string): Observable<String> {
    const body: ChangeDataUser = {
      biography: null,
      birthday: null,
      phone: phone,
    };
    return this.http.put<String>(`${API_URL}edit/phone`, body);
  }

  changePassword(body: ChangePasswordResponse): Observable<ChangePasswordResponse> {
    console.log(body);
    return this.http.put<ChangePasswordResponse>(`${API_URL}user/changePassword`,body);
  }
}
