const server = require('./app.js');
const supertest = require('supertest');
const requestWithSupertest = supertest(server);

describe('User Endpoints', () => {

  // 1. Тест на получение всех пользователей (исходный тест)
  it('GET /api/users should show all users', async () => {
    const res = await requestWithSupertest.get('/api/users');
    expect(res.status).toEqual(200);
    expect(res.type).toEqual(expect.stringContaining('json'));
    expect(res.body).toHaveProperty('users');
    expect(res.body.users.length > 0);
    expect(res.body.users[0]).toHaveProperty('id');
    expect(res.body.users[0]).toHaveProperty('login');
    expect(res.body.users[0]).toHaveProperty('fio');
    expect(res.body.users[0]).toHaveProperty('role_label');
  });

  // 2. Проверяет, что ответ — JSON
  it('GET /api/users should return JSON', async () => {
    const res = await requestWithSupertest.get('/api/users');
    expect(res.type).toBe('application/json');
  });

  // 3. Проверяет, что в ответе есть массив users
  it('GET /api/users should return array of users', async () => {
    const res = await requestWithSupertest.get('/api/users');
    expect(Array.isArray(res.body.users)).toBe(true);
  });

  // 4. Проверяет, что у каждого пользователя есть id
  it('GET /api/users users should have "id" field', async () => {
    const res = await requestWithSupertest.get('/api/users');
    res.body.users.forEach(user => {
      expect(user).toHaveProperty('id');
    });
  });

  // 5. Проверяет, что в данных есть тестовый пользователь "admin"
  it('GET /api/users should contain test admin', async () => {
    const res = await requestWithSupertest.get('/api/users');
    const hasAdmin = res.body.users.some(user => user.login === 'admin');
    expect(hasAdmin).toBe(true);
  });

  // 6. Проверяет, что API вообще работает
  it('GET /api/users should return status 200', async () => {
    const res = await requestWithSupertest.get('/api/users');
    expect(res.status).toEqual(200);
  });

  // 7. Тест на обновление пользователя
  it('PUT /api/users/:id should update user', async () => {
    const testUserId = 1; // Предполагаем, что пользователь с ID=1 существует
    const updates = { fio: 'Обновленное Имя' };
    
    const res = await requestWithSupertest.put(`/api/users/${testUserId}`).send(updates);
    
    expect(res.status).toEqual(200);
    expect(res.body.fio).toBe(updates.fio);
  });

  // 8. Тест на удаление пользователя
  it('DELETE /api/users/:id should delete user', async () => {
    const testUserId = 2; // Предполагаем, что пользователь с ID=2 существует
    const res = await requestWithSupertest.delete(`/api/users/${testUserId}`);
    
    expect(res.status).toEqual(200);
    expect(res.body).toHaveProperty('message', 'User deleted');
  });

  // 9. Тест на фильтрацию пользователей по роли
  it('GET /api/users?role=Администратор should filter by role', async () => {
    const role = 'Администратор';
    const res = await requestWithSupertest.get(`/api/users?role=${role}`);
    
    expect(res.status).toEqual(200);
    expect(res.body.users.length).toBeGreaterThan(0);
    expect(res.body.users.every(user => user.role_label === role)).toBe(true);
  });

});