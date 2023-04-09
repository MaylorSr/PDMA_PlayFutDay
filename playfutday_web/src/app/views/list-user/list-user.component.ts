import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { UserService } from 'src/app/_services/user.service';
import { environment } from 'src/app/environments/environment.prod';
import { UserResponse } from 'src/app/interfaces/user/user_list';

@Component({
  selector: 'app-list-user',
  templateUrl: './list-user.component.html',
  styleUrls: ['./list-user.component.css'],
})
export class ListUserComponent implements OnInit, AfterViewInit {
  displayedColumns: string[] = [
    'avatar',
    'id',
    'author',
    'create_account',
    'state',
    'roles',
  ];
  dataSource!: MatTableDataSource<UserResponse>;
  pageActual = 1;

  @ViewChild(MatPaginator)
  paginator!: MatPaginator;
  @ViewChild(MatSort)
  sort!: MatSort;

  users: UserResponse[] = [];

  totalPages: number = 0;

  ngOnInit(): void {
    this.showListUser(0);
  }

  constructor(private userService: UserService) {
    this.dataSource = new MatTableDataSource<UserResponse>();
  }

  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
  }

  showListUser(page: number) {
    this.userService.getListPeople(this.pageActual).subscribe((u) => {
      this.users = u.content;
      this.dataSource.data = this.users;
      this.dataSource.paginator = this.paginator;
      this.dataSource.sort = this.sort;
      this.totalPages = u.totalPages;
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

  nextPage() {
    if (this.pageActual < this.totalPages) {
      this.pageActual++;
      this.showListUser(this.pageActual);
    }
  }

  backPage() {
    if (this.pageActual > 1) {
      this.pageActual--;
      this.showListUser(this.pageActual);
    }
  }

  // goToNextPage() {
  //   if (this.paginator.pageIndex <= this.totalPages) {
  //     this.paginator.nextPage();
  //     this.showListUser(this.paginator.pageIndex);
  //   }
  // }

  // goToPreviousPage() {
  //   if (this.paginator.hasPreviousPage()) {
  //     this.paginator.previousPage();
  //     this.showListUser(this.paginator.pageIndex);
  //   }
  // }
}
