export interface UserLog {
  id: string;
  username: string;
  email: string;
  avatar: string;
  phone: string;
  birthday: string;
  myPost: MyPost[];
  roles: string[];
  token: string;
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
}

export interface Commentary {
  message: string;
  authorName: string;
  authorFile: string;
  uploadCommentary: string;
}
