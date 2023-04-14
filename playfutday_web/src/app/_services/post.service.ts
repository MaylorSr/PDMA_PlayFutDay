import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../environments/environment.prod';
import { PostListResponse } from '../interfaces/post/post_list';

const API_URL = environment.api_hosting + '/';

@Injectable({
  providedIn: 'root',
})
export class PostService {
  constructor(private http: HttpClient) {}

  getListPost(page: number): Observable<PostListResponse> {
    return this.http.get<PostListResponse>(`${API_URL}post/?page=${page}`);
  }

  deletePost(id_post: any, id_user: any) {
    console.log('llama al metodo');
    return this.http.delete(`${API_URL}post/user/${id_post}/user/${id_user}`);
  }
}
