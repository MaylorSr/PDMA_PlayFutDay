import { Injectable } from "@angular/core";
import { HttpClient, HttpHeaders } from "@angular/common/http";
import { Observable } from "rxjs";
import { environment } from "../../environments/environment.prod";
import { PostListResponse } from "../interfaces/post/post_list";
import { TokenStorageService } from "./token-storage.service";
import { PostRequestResponse } from "../interfaces/post/post_request";
import { PostInfoByIdResponse } from "../interfaces/post/post_info_by_id";
import { ListPostCommentaryRespone } from "../interfaces/commentaries/list_reponse";
import { AllCommentariesResponse } from "../interfaces/commentaries/list_all_commentaries";
const API_URL = environment.api_hosting + "/";

@Injectable({
  providedIn: "root",
})
export class PostService {
  constructor(
    private http: HttpClient,
    private tokenService: TokenStorageService
  ) {}

  getListPost(page: number): Observable<PostListResponse> {
    return this.http.get<PostListResponse>(`${API_URL}post/?page=${page}`);
  }

  deletePost(id_post: any, id_user: any) {
    console.log("llama al metodo");
    return this.http.delete(`${API_URL}post/user/${id_post}/user/${id_user}`);
  }

  getListPostOfUser(page: number, username: string) {
    return this.http.get<PostListResponse>(
      `${API_URL}post/user/${username}?page=${page}`
    );
  }

  getInfoPostById(id: number): Observable<PostInfoByIdResponse> {
    return this.http.get<PostInfoByIdResponse>(`${API_URL}post/details/${id}`);
  }

  deleteCommentarie(id_commentary: string) {
    return this.http.delete(
      `${API_URL}post/delete/commentary/${id_commentary}`
    );
  }

  requestPost(tag: string, description: string, image: File) {
    const formData = new FormData();

    const body: PostRequestResponse = { tag: tag, description: description };

    const blobBody = new Blob([JSON.stringify(body)], {
      type: "application/vnd.api+json",
    });

    const imageBlob = new Blob([image], { type: image.type }); // Convertir el archivo image en Blob

    formData.append("image", imageBlob, image.name); // Especificar el nombre del archivo y el tipo de archivo
    formData.append("post", blobBody);

    console.log("FormData.getAll():", formData.getAll("image")); // Obtener todos los valores del FormData

    const headers = new HttpHeaders({
      Authorization: `Bearer ${this.tokenService.getToken()}`,
      "Content-Type":
        "multipart/form-data; boundary=----WebKitFormBoundary<boundary>",
    });

    return this.http.post(`${API_URL}post/`, formData, { headers });
  }

  getCommentariesOfPostById(
    id_post: number,
    page: number
  ): Observable<ListPostCommentaryRespone> {
    return this.http.get<ListPostCommentaryRespone>(
      `${API_URL}post/details/${id_post}/commentaries?page=${page}`
    );
  }

  getAllCommentaries(page: number): Observable<AllCommentariesResponse> {
    return this.http.get<AllCommentariesResponse>(
      `${API_URL}post/all/commentaries?page=${page}`
    );
  }
}
