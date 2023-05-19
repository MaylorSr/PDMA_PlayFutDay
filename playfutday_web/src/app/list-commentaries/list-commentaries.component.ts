import { AfterViewInit, Component, OnInit, ViewChild } from "@angular/core";
import { MatPaginator } from "@angular/material/paginator";
import { MatSort } from "@angular/material/sort";
import { MatTableDataSource } from "@angular/material/table";
import { ListAllCommentaries } from "../interfaces/commentaries/list_all_commentaries";
import { PostService } from "../_services/post.service";
import { SureDeleteComponent } from "../components/sure-delete/sure-delete.component";
import { MatDialog } from "@angular/material/dialog";

@Component({
  selector: "app-list-commentaries",
  templateUrl: "./list-commentaries.component.html",
  styleUrls: ["./list-commentaries.component.css"],
})
export class ListCommentariesComponent implements OnInit, AfterViewInit {
  constructor(public dialog: MatDialog, private postService: PostService) {
    this.dataSource = new MatTableDataSource<ListAllCommentaries>();
  }

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  ngOnInit(): void {
    this.showListCommentaries(this.pageIndex);
  }

  displayedColumns: string[] = [
    "id",
    "author",
    "message",
    "post_id",
    "upload",
    "actions",
  ];

  dataSource!: MatTableDataSource<ListAllCommentaries>;
  message: string = "";
  @ViewChild(MatPaginator)
  paginator!: MatPaginator;
  @ViewChild(MatSort)
  sort!: MatSort;
  error: boolean = false;

  listCommentaries: ListAllCommentaries[] = [];
  pageIndex = 0;
  totalPages: number = 0;
  totalElements: number = 0;

  nextPageCommentaries() {
    if (this.pageIndex < this.totalPages - 1) {
      this.pageIndex++;
      this.showListCommentaries(this.pageIndex);
    }
  }

  backPageCommentaries() {
    if (this.pageIndex > 0) {
      this.pageIndex--;
      this.showListCommentaries(this.pageIndex);
    }
  }

  showListCommentaries(page: number) {
    this.postService.getAllCommentaries(page).subscribe({
      next: (c) => {
        this.listCommentaries = c.content;
        this.dataSource.data = this.listCommentaries;
        this.dataSource.paginator = this.paginator;
        this.dataSource.sort = this.sort;
        this.totalElements = c.totalElements;
        this.totalPages = c.totalPages;
        this.error = false;
      },
      error: (err) => {
        this.message = err.error.message;
        this.error = true;
      },
    });
    /* this.postService.getAllCommentaries(page).subscribe((c) => {
      this.listCommentaries = c.content;
      this.dataSource.data = this.listCommentaries;
      this.dataSource.paginator = this.paginator;
      this.dataSource.sort = this.sort;
      this.totalElements = c.totalElements;
      this.totalPages = c.totalPages;
    }); */
  }

  openDialogDelete(commentarie_emit: ListAllCommentaries) {
    console.log(commentarie_emit);

    this.dialog.open(SureDeleteComponent, {
      width: "450px",
      height: "120px",
      data: {
        dataInfo: commentarie_emit,
      },
    });
  }
}
