import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { NgxSpinnerService } from 'ngx-spinner';
import { delay } from 'rxjs';
import { PostService } from 'src/app/_services/post.service';
import { PostResponse } from 'src/app/interfaces/post/post_list';
import { SureDeleteComponent } from '../sure-delete/sure-delete.component';

@Component({
  selector: 'app-list-post',
  templateUrl: './list-post.component.html',
  styleUrls: ['./list-post.component.css'],
})
export class ListPostComponent implements OnInit, AfterViewInit {
  displayedColumns: string[] = ['id', 'tag', 'author', 'actions'];

  dataSource!: MatTableDataSource<PostResponse>;
  message: string = '';
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

  constructor(
    public dialog: MatDialog,
    private postService: PostService,
    private spinner: NgxSpinnerService
  ) {
    this.spinner.show();
    setTimeout(() => {
      this.spinner.hide();
    }, 600);
    this.dataSource = new MatTableDataSource<PostResponse>();
  }

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  showListPost(page: number) {
    this.postService
      .getListPost(page)
      .pipe(delay(600))
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
  }

  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
    }
  }

  openDialogDelete(
    enterAnimationDuration: string,
    exitAnimationDuration: string,
    post: PostResponse
  ) {
    this.dialog.open(SureDeleteComponent, {
      width: '250px',
      enterAnimationDuration,
      exitAnimationDuration,
      data: {
        dataInfo: post,
      },
    });
  }
}
