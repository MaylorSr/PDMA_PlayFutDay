import { TestBed } from '@angular/core/testing';

import { AccessDeniedGuard } from './access-denied.guard';

describe('AccessDeniedGuard', () => {
  let guard: AccessDeniedGuard;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    guard = TestBed.inject(AccessDeniedGuard);
  });

  it('should be created', () => {
    expect(guard).toBeTruthy();
  });
});
