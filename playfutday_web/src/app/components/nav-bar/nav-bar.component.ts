import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { TokenStorageService } from 'src/app/_services/token-storage.service';

@Component({
  selector: 'app-nav-bar',
  templateUrl: './nav-bar.component.html',
  styleUrls: ['./nav-bar.component.css'],
})
export class NavBarComponent implements OnInit {
  ngOnInit(): void {}
  constructor(
    private tokenStorageService: TokenStorageService,
    private router: Router
  ) {}

  logout(): void {
    this.tokenStorageService.signOut();
    this.router.navigate(['/auth/login']);
  }
}
