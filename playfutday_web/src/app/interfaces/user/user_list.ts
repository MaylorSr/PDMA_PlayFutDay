export interface UserListResponse {
  content: UserResponse[];
  totalPages: number;
  totalElements: number;
}

export interface UserResponse {
  id: string;
  username: string;
  createdAt: string;
  avatar: string;
  enabled: boolean;
  roles: string[];
}
