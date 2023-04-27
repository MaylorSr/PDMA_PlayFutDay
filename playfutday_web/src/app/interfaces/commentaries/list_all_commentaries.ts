export interface AllCommentariesResponse {
    content: ListAllCommentaries[]
    totalPages: number
    totalElements: number
  }
  
  export interface ListAllCommentaries {
    id: number
    message: string
    id_author: string
    authorName: string
    post_id: number
    uploadCommentary: string
  }
  