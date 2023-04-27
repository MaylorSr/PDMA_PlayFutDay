import { AfterViewInit, Component, OnInit, ViewChild } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { PostService } from "../../_services/post.service";
import { UserService } from "../../_services/user.service";
import { environment } from "../../../environments/environment.prod";
import { PostInfoByIdResponse } from "../../interfaces/post/post_info_by_id";
import { UserResponseInfo } from "../../interfaces/user/user_info_id";
import { CommentariResponseByPost } from "../../interfaces/commentaries/list_reponse";
import { MatTableDataSource } from "@angular/material/table";
import { MatPaginator } from "@angular/material/paginator";
import { MatSort } from "@angular/material/sort";

@Component({
  selector: "app-post-info",
  templateUrl: "./post-info.component.html",
  styleUrls: ["./post-info.component.css"],
})
export class PostInfoComponent implements OnInit, AfterViewInit {
  id: number = 0;

  displayedColumns: string[] = ["id", "author", "message", "upload", "actions"];

  dataSource: MatTableDataSource<CommentariResponseByPost> =
    new MatTableDataSource<CommentariResponseByPost>([]);
  @ViewChild(MatPaginator)
  paginator: MatPaginator;
  @ViewChild(MatSort)
  sort: MatSort;

  /**LIST COMMENTARIES BY POST */
  commentaries: CommentariResponseByPost[];
  pageIndex = 0;
  totalPages: number = 0;
  totalElements: number = 0;
  /******** */

  postInfo: PostInfoByIdResponse;
  userSelected: UserResponseInfo;

  totalFollwers: number = 0;
  totalFollows: number = 0;
  showListCommentaries: boolean = true;
  loading: boolean = true;
  loadingUserInfo: boolean = true;
  constructor(
    private route: ActivatedRoute,
    private userService: UserService,
    private postService: PostService
  ) {}
  ngOnInit(): void {
    this.route.params.subscribe((res) => {
      this.id = res["id"];
      this.getDetailsOfPostById();
      this.showInfoUser();
      this.showListCommentariesByPostId();
    });
  }
  showImgPost() {
    return `${environment.api_image}${this.postInfo.image}`;
  }

  getDetailsOfPostById() {
    return this.postService.getInfoPostById(this.id).subscribe((post) => {
      this.postInfo = post;
      this.loading = false;
    });
  }

  showInfoUser() {
    setTimeout(() => {
      this.userService.getInfoUser(this.postInfo.idAuthor).subscribe({
        next: (u) => {
          this.userSelected = u;
          this.loadingUserInfo = false;
          this.getTotalFollowers();
          this.getTotalFollows();
        },
        error: (err) => {
          console.log(err);
        },
      });
    }, 1000);
  }

  showImgUser() {
    return `${environment.api_image}${this.userSelected.avatar}`;
  }

  getTotalFollowers() {
    this.userService
      .getFolloweresByIdUser(this.userSelected.id, 0)
      .subscribe((follower) => {
        this.totalFollwers =
          follower.totalElements == null ? 0 : follower.totalElements;
      });
  }

  getTotalFollows() {
    this.userService
      .getFollowsByIdUser(this.userSelected.id, 0)
      .subscribe((follow) => {
        this.totalFollows =
          follow.totalElements == null ? 0 : follow.totalElements;
      });
  }

  showListCommentariesByPostId() {
    setTimeout(() => {
      this.postService
        .getCommentariesOfPostById(this.id, this.pageIndex)
        .subscribe({
          next: (c) => {
            this.commentaries = c.content;
            this.dataSource.data = this.commentaries;
            this.dataSource.paginator = this.paginator;
            this.dataSource.sort = this.sort;
            this.totalPages = c.totalPages;
            this.showListCommentaries = false;
          },
          error: (err) => {
            // this.message = err.error.status;
            // this.error = true;
            console.log(err);
          },
        });
    }, 1000);
    console.log(this.dataSource);
  }

  ngAfterViewInit() {
    setTimeout(() => {
      this.dataSource.paginator = this.paginator;
      this.dataSource.sort = this.sort;
    }, 1000);
  }

  nextPageCommentaries() {
    if (this.pageIndex < this.totalPages - 1) {
      this.pageIndex++;
      this.showListCommentariesByPostId();
    }
  }

  backPageCommentaries() {
    if (this.pageIndex > 0) {
      this.pageIndex--;
      this.showListCommentariesByPostId();
    }
  }
}
