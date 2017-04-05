const redis = require('redis');
const bluebird = require('bluebird');

bluebird.promisifyAll(redis.RedisClient.prototype);
bluebird.promisifyAll(redis.Multi.prototype);

module.exports = class data {

  constructor(host, port){
    this.keyTodoListItems = 'todolist:items';
    this.client = redis.createClient(port, host);
  }

  async ping() {
    return await this.client.pingAsync();
  }

  async getItems() {
    const items = await this.client.zrevrangeAsync(this.keyTodoListItems, 0, -1);
    return items.map(JSON.parse);
  }

  async deleteItem(id) {
    await this.client.zremrangebyscoreAsync(this.keyTodoListItems, id, id);
  }

  async completeItem(id) {
    this._updateItem(id, i => {i.status = 1; return i});
  }

  async todoItem(id) {
    this._updateItem(id, i => {i.status = 0; return i});
  }

  async createItem(body) {
    const i = {
      'id': body.id || Date.now(),
      'description': body.description,
      'status': 0
    };

    return this._storeItem(i);
  }

  async _storeItem(item){
    // Remove the old item by ID and add the new one
    await this.client.multi()
      .zremrangebyscore(this.keyTodoListItems, item.id, item.id)
      .zadd(this.keyTodoListItems, item.id, JSON.stringify(item))
      .execAsync();

    return item;
  }

  async _updateItem(id, callback){
    const i = await this.client.zrangebyscoreAsync(this.keyTodoListItems, id, id);
    if (i.length !== 1){
      throw new Error("Could not find item with ID: " + id);
    }
    return this._storeItem(callback(JSON.parse(i[0])));
  }
}
