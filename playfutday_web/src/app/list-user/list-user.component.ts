import { AfterViewInit, Component, OnInit, ViewChild } from "@angular/core";

import { MatDialog } from "@angular/material/dialog";
import { MatPaginator, PageEvent } from "@angular/material/paginator";
import { MatSort } from "@angular/material/sort";
import { MatTableDataSource } from "@angular/material/table";

import { UserService } from "../_services/user.service";
import { environment } from "../../environments/environment.prod";
import { UserResponse } from "../interfaces/user/user_list";
import { SureDeleteComponent } from "../components/sure-delete/sure-delete.component";
import { switchMap } from "rxjs/operators";

@Component({
  selector: "app-list-user",
  templateUrl: "./list-user.component.html",
  styleUrls: ["./list-user.component.css"],
})
export class ListUserComponent implements OnInit, AfterViewInit {
  displayedColumns: string[] = [
    "avatar",
    "id",
    "author",
    "create_account",
    "state",
    "roles",
    "actions",
  ];
  dataSource!: MatTableDataSource<UserResponse>;
  message: string = "";
  @ViewChild(MatPaginator)
  paginator!: MatPaginator;
  @ViewChild(MatSort)
  sort!: MatSort;
  error: boolean = false;

  users: UserResponse[] = [];
  pageIndex = 0;

  totalPages: number = 0;
  totalElements: number = 0;
  ngOnInit(): void {
    this.showListUser(this.pageIndex);
  }

  nextPageUsers() {
    if (this.pageIndex < this.totalPages - 1) {
      this.pageIndex++;
      this.showListUser(this.pageIndex);
    }
  }

  backPageUsers() {
    if (this.pageIndex > 0) {
      this.pageIndex--;
      this.showListUser(this.pageIndex);
    }
  }

  constructor(public dialog: MatDialog, private userService: UserService) {
    this.dataSource = new MatTableDataSource<UserResponse>();
  }

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  showListUser(page: number) {
    this.userService.getListPeople(page).subscribe({
      next: (u) => {
        this.users = u.content;
        this.dataSource.data = this.users;
        this.dataSource.paginator = this.paginator;
        this.dataSource.sort = this.sort;
        this.totalElements = u.totalElements;
        this.totalPages = u.totalPages;
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

  showImgUser(user: UserResponse) {
    return `${environment.api_image}${user.avatar}`;
  }

  /**
   *
   * @param id_user id del usuario a banear
   */
  banUser(id_user: any) {
    this.userService
      .banUser(id_user)
      .pipe(switchMap(() => this.userService.getListPeople(this.pageIndex)))
      .subscribe(() => {
        this.showListUser(this.pageIndex);
      });
  }

  changeRoles(id_user: any) {
    this.userService
      .changeRoles(id_user)
      .pipe(switchMap(() => this.userService.getListPeople(this.pageIndex)))
      .subscribe(() => {
        this.showListUser(this.pageIndex);
      });
  }

  openDialogDelete(user_emit: UserResponse) {
    this.dialog
      .open(SureDeleteComponent, {
        width: "450px",
        height: "120px",
        data: {
          dataInfo: user_emit,
        },
      })
      .afterClosed()
      .subscribe((res) => {
        if (res === "delete") {
          this.showListUser(this.pageIndex);
        }
      });
  }
}
