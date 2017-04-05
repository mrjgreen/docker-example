const assert = require('chai').assert;
const fetch = require('node-fetch');

const endpoint = 'http://localhost';

describe('Todo', () => {
  describe('basic', () => {
    it('returns a 200 response from status endpoint', (done) => {
      fetch(endpoint + '/status').then((res) => {
        assert.equal(200, res.status)
        done()
      });
    });

    it('returns a 200 response from health endpoint', (done) => {
      fetch(endpoint + '/health_check').then((res) => {
        assert.equal(200, res.status)
        done()
      });
    });
  });

  describe('todo', () => {
    it('adds an item', (done) => {
      const data = {
        method: 'POST',
        body:    JSON.stringify({'id': 1234567, 'description': 'foo bar'}),
	      headers: { 'Content-Type': 'application/json' },
      };
      fetch(endpoint + '/api/items', data).then((res) => {
        assert.equal(200, res.status)
        done()
      });
    });

    it('returns all items from items endpoint', (done) => {
      fetch(endpoint + '/api/items').then((res) => {
        assert.equal(200, res.status)
        done()
      });
    });

    it('completes an item', (done) => {
      const data = {
        method: 'PUT',
        body:    JSON.stringify({'status': 1}),
	      headers: { 'Content-Type': 'application/json' },
      };
      fetch(endpoint + '/api/items/1234567/complete', data).then((res) => {
        assert.equal(200, res.status)
        done()
      });
    });

    it('deletes an item', (done) => {
      fetch(endpoint + '/api/items/1234567', {'method': 'DELETE'}).then((res) => {
        assert.equal(200, res.status)
        done()
      });
    });
  });
});
