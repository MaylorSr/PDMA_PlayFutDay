export interface UserFollowResponse {
  content: UserFollow[];
  totalPages: number;
  totalElements: number;
}

export interface UserFollow {
  id: String;
  username: String;
  avatar: String;
}
