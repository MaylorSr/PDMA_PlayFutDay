import { AfterViewInit, Component, OnInit, ViewChild } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { PostService } from "../../_services/post.service";
import { UserService } from "../../_services/user.service";
import { UserResponse } from "../../interfaces/user/user_list";
import { environment } from "../../../environments/environment.prod";
import { MatTableDataSource } from "@angular/material/table";
import { MatPaginator } from "@angular/material/paginator";
import { MatSort } from "@angular/material/sort";
import { PostResponse } from "../../interfaces/post/post_list";

@Component({
  selector: "app-user-info",
  templateUrl: "./user-info.component.html",
  styleUrls: ["./user-info.component.css"],
})
export class UserInfoComponent implements OnInit, AfterViewInit {
  id: string = "";
  displayedColumns: string[] = ["id", "tag", "author", "actions"];
  dataSource!: MatTableDataSource<PostResponse>;
  message: string = "";
  @ViewChild(MatPaginator)
  paginator!: MatPaginator;
  @ViewChild(MatSort)
  sort!: MatSort;
  error: boolean = false;
  posts: PostResponse[] = [];
  pageIndex = 0;

  totalPages: number = 0;
  totalElements: number = 0;
  ngOnInit(): void {
    this.route.params.subscribe((res) => {
      this.id = res["id"];
      this.showInformation();
    });
    this.showListPost(this.pageIndex);
  }

  nextPagePosts() {
    if (this.pageIndex < this.totalPages - 1) {
      this.pageIndex++;
      this.showListPost(this.pageIndex);
    }
  }

  backPagePosts() {
    if (this.pageIndex > 0) {
      this.pageIndex--;
      this.showListPost(this.pageIndex);
    }
  }

  showListPost(page: number) {
    setTimeout(() => {
      this.postService
        .getListPostOfUser(page, this.userSelected.username)
        .subscribe({
          next: (u) => {
            this.posts = u.content;
            this.dataSource.data = this.posts;
            this.dataSource.paginator = this.paginator;
            this.dataSource.sort = this.sort;
            this.totalPages = u.totalPages;
          },
          error: (err) => {
            this.message = err.error.status;
            this.error = true;
          },
        });
    }, 3000);
    console.log(this.dataSource);
  }

  ngAfterViewInit() {
    setTimeout(() => {
      this.dataSource.paginator = this.paginator;
      this.dataSource.sort = this.sort;
    }, 3000);
  }

  constructor(
    private route: ActivatedRoute,
    private userService: UserService,
    private postService: PostService
  ) {}
  userSelected: UserResponse = {} as UserResponse;

  showInformation() {
    this.userService.getInfoUser(this.id).subscribe((res) => {
      this.userSelected = res;
    });
  }

  showImgUser(user: UserResponse) {
    return `${environment.api_image}${user.avatar}`;
  }

  deleteCommentary(id_comment: string) {
    return this.postService.deleteCommentarie(id_comment);
  }
}
