const request = require('supertest');
const { app } = require('./index');

describe('GET /api/message', () => {
  it('should return a message saying Hello, CI/CD!', async () => {
    const res = await request(app).get('/api/message');
    expect(res.statusCode).toEqual(200);
    expect(res.body).toHaveProperty('message');
    expect(res.body.message).toEqual('Hello, CI/CD!');
  });
});
