import { AfterViewInit, Component, OnInit, ViewChild } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { PostService } from "../../_services/post.service";
import { UserService } from "../../_services/user.service";
import { environment } from "../../../environments/environment.prod";
import { MatTableDataSource } from "@angular/material/table";
import { MatPaginator } from "@angular/material/paginator";
import { MatSort } from "@angular/material/sort";
import { UserResponseInfo } from "../../interfaces/user/user_info_id";
import { LastThreeCommentaries } from "../../interfaces/commentaries/last_three_commentaries";
import { PostByUserName } from "../../interfaces/post/post_user_by_username";
import { MatDialog } from "@angular/material/dialog";
import { SureDeleteComponent } from "../../components/sure-delete/sure-delete.component";
import { ListAllCommentaries } from "../../interfaces/commentaries/list_all_commentaries";
import { PostResponse } from "../../interfaces/post/post_list";

@Component({
  selector: "app-user-info",
  templateUrl: "./user-info.component.html",
  styleUrls: ["./user-info.component.css"],
})
export class UserInfoComponent implements OnInit, AfterViewInit {
  userSelected: UserResponseInfo = {} as UserResponseInfo;
  lastThreeCommentaries: LastThreeCommentaries[];
  id: string = "";
  displayedColumns: string[] = ["id", "tag", "upLoad", "actions"];
  dataSource: MatTableDataSource<PostByUserName> =
    new MatTableDataSource<PostByUserName>([]);
  @ViewChild(MatPaginator)
  paginator: MatPaginator;
  @ViewChild(MatSort)
  sort: MatSort;
  posts: PostByUserName[] = [];
  pageIndex = 0;
  totalPages: number = 0;

  /********/
  totalFollwers: number = 0;
  totalFollows: number = 0;
  // totalElements: number = 0;
  ngOnInit(): void {
    this.route.params.subscribe((res) => {
      this.id = res["id"];
      this.showInformation();
      this.getTotalFollowers();
      this.getTotalFollows();
      this.getLasThreeCommentariesByUserId();
      this.showListPost(this.pageIndex);
    });
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
      this.userService
        .getListPostByUserName(page, this.userSelected.username)
        .subscribe({
          next: (u) => {
            this.posts = u.content;
            this.dataSource.data = this.posts;
            this.dataSource.paginator = this.paginator;
            this.dataSource.sort = this.sort;
            this.totalPages = u.totalPages;
          },
          error: (err) => {
            // this.message = err.error.status;
            // this.error = true;
            console.log(err);
          },
        });
    }, 1000);
  }

  ngAfterViewInit() {
    setTimeout(() => {
      this.dataSource.paginator = this.paginator;
      this.dataSource.sort = this.sort;
    }, 1000);
  }

  constructor(
    public dialog: MatDialog,
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
    try {
      this.userService
        .getFolloweresByIdUser(this.id, 0)
        .subscribe((follower) => {
          this.totalFollwers = follower.totalElements;
        });
    } catch (error) {
      this.totalFollwers = 0;
    }
  }

  getTotalFollows() {
    try {
      this.userService.getFollowsByIdUser(this.id, 0).subscribe((follow) => {
        this.totalFollows = follow.totalElements;
      });
    } catch (error) {
      this.totalFollows = 0;
    }
  }

  getLasThreeCommentariesByUserId() {
    try {
      this.userService
        .getLasThreeCommentariesByUserId(this.id)
        .subscribe((commentaries) => {
          this.lastThreeCommentaries = commentaries;
        });
    } catch (error) {
      this.lastThreeCommentaries = [];
    }
  }

  openDialogDelete(commentarie_emit: ListAllCommentaries) {
    this.dialog.open(SureDeleteComponent, {
      width: "450px",
      height: "120px",
      data: {
        dataInfo: commentarie_emit,
      },
    }).afterClosed().subscribe(res => {
      if (res === "delete") {
        this.getLasThreeCommentariesByUserId();
      }
    }) ;
  }

  openDialogDeletePost(post_emit: PostResponse) {
    this.dialog.open(SureDeleteComponent, {
      width: "450px",
      height: "120px",
      data: {
        dataInfo: post_emit,
      },
    }).afterClosed().subscribe(res => {
      if (res === "delete") {
        this.showListPost(this.pageIndex);
      }
    });
  }

}
