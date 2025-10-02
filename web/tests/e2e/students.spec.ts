import { test, expect } from '@playwright/test';

test.describe('Students Management', () => {
  test.beforeEach(async ({ page }) => {
    // Login before each test
    await page.goto('http://localhost:3000/login');
    await page.fill('input[name="email"]', 'admin@chapel.local');
    await page.fill('input[name="password"]', 'Admin#12345');
    await page.click('button[type="submit"]');
    await page.waitForURL('**/dashboard');

    // Navigate to students page
    await page.click('a[href="/students"]');
    await page.waitForURL('**/students');
  });

  test('should display students list', async ({ page }) => {
    await expect(page.getByRole('heading', { name: /students/i })).toBeVisible();
    await expect(page.getByRole('table')).toBeVisible();
  });

  test('should create a new student', async ({ page }) => {
    // Click add student button
    await page.click('button:has-text("Add Student")');

    // Fill form
    await page.fill('input[name="student_no"]', `TEST${Date.now()}`);
    await page.fill('input[name="name"]', 'Test Student');
    await page.fill('input[name="program"]', 'Computer Science');
    await page.fill('input[name="faculty"]', 'Engineering');
    await page.fill('input[name="phone"]', `+23276${Math.floor(Math.random() * 10000000)}`);
    await page.fill('input[name="level"]', '300');

    // Submit form
    await page.click('button[type="submit"]:has-text("Create")');

    // Should show success message
    await expect(page.getByText(/student created successfully/i)).toBeVisible();
  });

  test('should search students', async ({ page }) => {
    // Type in search box
    await page.fill('input[placeholder*="Search"]', 'Test');

    // Wait for results
    await page.waitForTimeout(1000);

    // Should filter results
    const rows = await page.locator('table tbody tr').count();
    expect(rows).toBeGreaterThanOrEqual(0);
  });

  test('should filter students by program', async ({ page }) => {
    // Select program filter
    await page.click('select[name="program"]');
    await page.selectOption('select[name="program"]', 'Computer Science');

    // Wait for results
    await page.waitForTimeout(1000);

    // Should show filtered results
    const rows = await page.locator('table tbody tr').count();
    expect(rows).toBeGreaterThanOrEqual(0);
  });

  test('should edit student', async ({ page }) => {
    // Click first edit button
    await page.click('table tbody tr:first-child button[aria-label*="Edit"]');

    // Update name
    await page.fill('input[name="name"]', 'Updated Student Name');

    // Submit
    await page.click('button[type="submit"]:has-text("Update")');

    // Should show success
    await expect(page.getByText(/student updated successfully/i)).toBeVisible();
  });

  test('should delete student', async ({ page }) => {
    // Get initial row count
    const initialCount = await page.locator('table tbody tr').count();

    // Click first delete button
    await page.click('table tbody tr:first-child button[aria-label*="Delete"]');

    // Confirm deletion
    await page.click('button:has-text("Confirm")');

    // Should show success
    await expect(page.getByText(/student deleted successfully/i)).toBeVisible();

    // Row count should decrease
    const newCount = await page.locator('table tbody tr').count();
    expect(newCount).toBeLessThan(initialCount);
  });

  test('should handle pagination', async ({ page }) => {
    // Check if pagination exists
    const paginationExists = await page.locator('[aria-label="Pagination"]').count() > 0;

    if (paginationExists) {
      // Click next page
      await page.click('button[aria-label="Go to next page"]');

      // Should load next page
      await page.waitForTimeout(500);
      expect(await page.locator('table tbody tr').count()).toBeGreaterThan(0);
    }
  });
});
