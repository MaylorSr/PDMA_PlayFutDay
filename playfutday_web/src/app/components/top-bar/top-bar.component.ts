import { Component, OnInit } from '@angular/core';
import { UserService } from 'src/app/_services/user.service';
import { environment } from 'src/app/environments/environment.prod';
import { UserLog } from 'src/app/interfaces/user/user_log';

@Component({
  selector: 'app-top-bar',
  templateUrl: './top-bar.component.html',
  styleUrls: ['./top-bar.component.css'],
})
export class TopBarComponent implements OnInit {
  user: UserLog = {} as UserLog;

  constructor(private userService: UserService) {}

  

  showImgUser(user: UserLog) {
    return `${environment.api_image}${user.avatar}`;
  }

  ngOnInit(): void {
    this.userService.getProfile().subscribe({
      next: (log) => {
        this.user = log;
      },
    });
    this.showImgUser(this.user);
  }
}
