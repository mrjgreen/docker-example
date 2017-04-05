import Frisbee from 'frisbee';

export default class TodoApiClient {

  constructor(apiEndpoint){
    this.api = new Frisbee({
      baseURI: apiEndpoint + '/api/',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    });
  }

  async _res(req){
    const res = await req;
    if (res.err) throw res.err;
    return res.body;
  }

  getItems(){
    return this._res(this.api.get('items'));
  }

  createItem(data){
    return this._res(this.api.post('items', {body:data}));
  }

  completeItem(id, status){
    return this._res(this.api.put('items/' + id + '/complete', {body: {status: status}}));
  }

  deleteItem(id){
    return this._res(this.api.del('items/' + id));
  }
}
