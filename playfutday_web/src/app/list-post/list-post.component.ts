import { AfterViewInit, Component, OnInit, ViewChild } from "@angular/core";
import { MatPaginator } from "@angular/material/paginator";
import { MatSort } from "@angular/material/sort";
import { MatTableDataSource } from "@angular/material/table";
import { PostService } from "../_services/post.service";
import { PostResponse } from "../interfaces/post/post_list";
import { MatDialog } from "@angular/material/dialog";
import { SureDeleteComponent } from "../components/sure-delete/sure-delete.component";

@Component({
  selector: "app-list-post",
  templateUrl: "./list-post.component.html",
  styleUrls: ["./list-post.component.css"],
})
export class ListPostComponent implements OnInit, AfterViewInit {
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

  constructor(public dialog: MatDialog, private postService: PostService) {
    this.dataSource = new MatTableDataSource<PostResponse>();
  }

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  showListPost(page: number) {
    this.postService.getListPost(page).subscribe({
      next: (u) => {
        this.posts = u.content;
        this.dataSource.data = this.posts;
        this.dataSource.paginator = this.paginator;
        this.dataSource.sort = this.sort;
        this.totalPages = u.totalPages;
        this.error = false;
      },
      error: (err) => {
        this.message = err.error.message;
        this.error = true;
      },
    });
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  openDialogDelete(post_emit: PostResponse) {
    console.log(post_emit);
    this.dialog.open(SureDeleteComponent, {
      width: "450px",
      height: "120px",
      data: {
        dataInfo: post_emit,
      },
    });
  }
}
