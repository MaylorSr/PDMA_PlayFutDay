export interface PostListResponse {
  content: PostResponse[];
  totalPages: number;
}

export interface PostResponse {
  id: number;
  tag: string;
  image: string;
  uploadDate: string;
  author: string;
  idAuthor: string;
  authorFile: string;
  countLikes: number;
  commentaries?: Commentary[];
}

export interface Commentary {
  message: string;
  authorName: string;
  authorFile: string;
  uploadCommentary: string;
}
