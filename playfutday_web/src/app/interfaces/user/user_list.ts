export interface UserListResponse {
  content: UserResponse[];
  totalPages: number;
}

export interface UserResponse {
  id: string;
  username: string;
  createdAt: string;
  email: string;
  avatar: string;
  biography?: string;
  phone: string;
  birthday: string;
  enabled: boolean;
  myPost?: MyPost[];
  roles: string[];
}

export interface MyPost {
  id: number;
  tag: string;
  image: string;
  uploadDate: string;
  author: string;
  idAuthor: string;
  authorFile: string;
  countLikes: number;
  commentaries?: Commentary[];
  description?: string;
}

export interface Commentary {
  id: number;
  message: string;
  authorName: string;
  authorFile: string;
  uploadCommentary: string;
}
