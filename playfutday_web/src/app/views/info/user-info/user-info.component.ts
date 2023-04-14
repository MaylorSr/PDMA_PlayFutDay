import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { PostService } from 'src/app/_services/post.service';
import { UserService } from 'src/app/_services/user.service';
import { UserResponse } from 'src/app/interfaces/user/user_list';

@Component({
  selector: 'app-user-info',
  templateUrl: './user-info.component.html',
  styleUrls: ['./user-info.component.css'],
})
export class UserInfoComponent implements OnInit {
  id: string = '';

  ngOnInit(): void {
    this.route.params.subscribe((res) => {
      this.id = res['id'];
      this.showInformation();
    });
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
}
