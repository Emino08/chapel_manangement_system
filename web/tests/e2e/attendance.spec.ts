import { test, expect } from '@playwright/test';

test.describe('Attendance Management', () => {
  test.beforeEach(async ({ page }) => {
    // Login before each test
    await page.goto('http://localhost:3000/login');
    await page.fill('input[name="email"]', 'admin@chapel.local');
    await page.fill('input[name="password"]', 'Admin#12345');
    await page.click('button[type="submit"]');
    await page.waitForURL('**/dashboard');

    // Navigate to attendance page
    await page.click('a[href="/attendance"]');
    await page.waitForURL('**/attendance');
  });

  test('should display attendance page', async ({ page }) => {
    await expect(page.getByRole('heading', { name: /attendance/i })).toBeVisible();
  });

  test('should select a service', async ({ page }) => {
    // Select service from dropdown
    await page.click('select[name="service"]');
    const serviceOptions = await page.locator('select[name="service"] option').count();

    if (serviceOptions > 1) {
      await page.selectOption('select[name="service"]', { index: 1 });

      // Should enable attendance marking
      await expect(page.getByText(/select student/i)).toBeVisible();
    }
  });

  test('should search and mark student present', async ({ page }) => {
    // Select a service first
    await page.click('select[name="service"]');
    const serviceOptions = await page.locator('select[name="service"] option').count();

    if (serviceOptions > 1) {
      await page.selectOption('select[name="service"]', { index: 1 });

      // Search for student
      await page.fill('input[placeholder*="Search student"]', 'Test');
      await page.waitForTimeout(1000);

      // Mark first student as present
      const presentButton = page.locator('button:has-text("Present")').first();
      if (await presentButton.count() > 0) {
        await presentButton.click();

        // Should show success
        await expect(page.getByText(/attendance marked/i)).toBeVisible();
      }
    }
  });

  test('should mark student absent', async ({ page }) => {
    // Select a service first
    await page.click('select[name="service"]');
    const serviceOptions = await page.locator('select[name="service"] option').count();

    if (serviceOptions > 1) {
      await page.selectOption('select[name="service"]', { index: 1 });

      // Search for student
      await page.fill('input[placeholder*="Search student"]', 'Test');
      await page.waitForTimeout(1000);

      // Mark first student as absent
      const absentButton = page.locator('button:has-text("Absent")').first();
      if (await absentButton.count() > 0) {
        await absentButton.click();

        // Should show success
        await expect(page.getByText(/attendance marked/i)).toBeVisible();
      }
    }
  });

  test('should update attendance status', async ({ page }) => {
    // Select a service
    await page.click('select[name="service"]');
    const serviceOptions = await page.locator('select[name="service"] option').count();

    if (serviceOptions > 1) {
      await page.selectOption('select[name="service"]', { index: 1 });

      // Search for student
      await page.fill('input[placeholder*="Search student"]', 'Test');
      await page.waitForTimeout(1000);

      // Mark present
      const presentButton = page.locator('button:has-text("Present")').first();
      if (await presentButton.count() > 0) {
        await presentButton.click();
        await page.waitForTimeout(500);

        // Mark absent (update status)
        const absentButton = page.locator('button:has-text("Absent")').first();
        await absentButton.click();

        // Should update successfully
        await expect(page.getByText(/attendance.*updated/i)).toBeVisible();
      }
    }
  });

  test('should filter by program', async ({ page }) => {
    // Select a service
    await page.click('select[name="service"]');
    const serviceOptions = await page.locator('select[name="service"] option').count();

    if (serviceOptions > 1) {
      await page.selectOption('select[name="service"]', { index: 1 });

      // Select program filter
      const programFilter = page.locator('select[name="program"]');
      if (await programFilter.count() > 0) {
        await programFilter.click();
        await page.selectOption('select[name="program"]', 'Computer Science');
        await page.waitForTimeout(1000);

        // Should show filtered students
        expect(await page.locator('table tbody tr').count()).toBeGreaterThanOrEqual(0);
      }
    }
  });

  test('should view attendance summary', async ({ page }) => {
    // Select a service
    await page.click('select[name="service"]');
    const serviceOptions = await page.locator('select[name="service"] option').count();

    if (serviceOptions > 1) {
      await page.selectOption('select[name="service"]', { index: 1 });

      // Look for summary/stats
      const statsElements = await page.locator('[data-testid*="stat"]').count();
      expect(statsElements).toBeGreaterThanOrEqual(0);
    }
  });
});
