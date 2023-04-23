export interface UserResponseInfo {
  id: string;
  username: string;
  email: string;
  avatar: string;
  biography: string;
  phone: string;
  birthday: string;
  myPost: MyPost[];
  roles: string[];
  token: string;
}

export interface MyPost {
  image: string;
}
