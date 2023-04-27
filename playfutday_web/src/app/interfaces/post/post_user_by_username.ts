export interface PostListByUserName {
    content: PostByUserName[]
    totalPages: number
  }
  
  export interface PostByUserName {
    id: number
    tag: string
    image: string
    uploadDate: string
    author: string
    idAuthor: string
    authorFile: string
    countLikes: number
    commentaries?: Commentary[]
  }
  
  export interface Commentary {
    message: string
    authorName: string
    authorFile: string
    uploadCommentary: string
  }
  