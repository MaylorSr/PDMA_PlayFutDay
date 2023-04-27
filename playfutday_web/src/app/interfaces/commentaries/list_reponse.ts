export interface ListPostCommentaryRespone {
  content: CommentariResponseByPost[];
  totalPages: number;
  totalElements: number;
}

export interface CommentariResponseByPost {
  id: number;
  message: string;
  id_author: string;
  authorName: string;
  post_id: number;
  uploadCommentary: string;
}
