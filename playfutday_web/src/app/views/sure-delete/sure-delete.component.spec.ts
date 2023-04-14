import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SureDeleteComponent } from './sure-delete.component';

describe('SureDeleteComponent', () => {
  let component: SureDeleteComponent;
  let fixture: ComponentFixture<SureDeleteComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SureDeleteComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SureDeleteComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
