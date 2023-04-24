import { AfterViewInit, Component, OnInit, ViewChild } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { PostService } from "../../_services/post.service";
import { UserService } from "../../_services/user.service";
import { environment } from "../../../environments/environment.prod";
import { MatTableDataSource } from "@angular/material/table";
import { MatPaginator } from "@angular/material/paginator";
import { MatSort } from "@angular/material/sort";
import { PostResponse } from "../../interfaces/post/post_list";
import { UserResponseInfo } from "../../interfaces/user/user_info_id";

@Component({
  selector: "app-user-info",
  templateUrl: "./user-info.component.html",
  styleUrls: ["./user-info.component.css"],
})
export class UserInfoComponent implements OnInit {
  // AfterViewInit
  userSelected: UserResponseInfo = {} as UserResponseInfo;

  id: string = "";
  // displayedColumns: string[] = ["id", "tag", "author", "actions"];
  // dataSource!: MatTableDataSource<PostResponse>;
  // message: string = "";
  // @ViewChild(MatPaginator)
  // paginator!: MatPaginator;
  // @ViewChild(MatSort)
  // sort!: MatSort;
  // error: boolean = false;
  // posts: PostResponse[] = [];
  // pageIndex = 0;

  totalPages: number = 0;
  totalFollwers: number = 0;
  totalFollows: number = 0;
  totalElements: number = 0;
  initalPageFollows: number = 0;
  ngOnInit(): void {
    this.route.params.subscribe((res) => {
      this.id = res["id"];
      this.showInformation();
      this.getTotalFollowers();
    });
    // this.showListPost(this.pageIndex);
  }

  // nextPagePosts() {
  //   if (this.pageIndex < this.totalPages - 1) {
  //     this.pageIndex++;
  //     this.showListPost(this.pageIndex);
  //   }
  // }

  // backPagePosts() {
  //   if (this.pageIndex > 0) {
  //     this.pageIndex--;
  //     this.showListPost(this.pageIndex);
  //   }
  // }

  // showListPost(page: number) {
  //   setTimeout(() => {
  //     this.postService
  //       .getListPostOfUser(page, this.userSelected.username)
  //       .subscribe({
  //         next: (u) => {
  //           this.posts = u.content;
  //           this.dataSource.data = this.posts;
  //           this.dataSource.paginator = this.paginator;
  //           this.dataSource.sort = this.sort;
  //           this.totalPages = u.totalPages;
  //         },
  //         error: (err) => {
  //           this.message = err.error.status;
  //           this.error = true;
  //         },
  //       });
  //   }, 3000);
  //   console.log(this.dataSource);
  // }

  // ngAfterViewInit() {
  //   setTimeout(() => {
  //     this.dataSource.paginator = this.paginator;
  //     this.dataSource.sort = this.sort;
  //   }, 3000);
  // }

  constructor(
    private route: ActivatedRoute,
    private userService: UserService,
    private postService: PostService
  ) {}

  showInformation() {
    this.userService.getInfoUser(this.id).subscribe((res) => {
      this.userSelected = res;
    });
  }

  showImgUser(user: UserResponseInfo) {
    return `${environment.api_image}${user.avatar}`;
  }

  getTotalFollowers() {
    this.userService
      .getFolloweresByIdUser(this.userSelected.id, this.initalPageFollows)
      .subscribe((follow) => {
        for (
          this.initalPageFollows;
          this.initalPageFollows <= follow.totalPages;
          this.initalPageFollows++
        ) {
          this.userService
            .getFolloweresByIdUser(this.userSelected.id, this.initalPageFollows)
            .subscribe((f) => (this.totalFollwers += f.totalElements));
        }
      });
  }

  deleteCommentary(id_comment: string) {
    return this.postService.deleteCommentarie(id_comment);
  }
}
