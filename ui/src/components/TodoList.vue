<template>
<div>
  <h1 class="title">Todo List</h1>
  <ul class="todo-list">
    <li class="new-todo">
      <div class="form-group">
        <input class="form-control unboxed" autofocus autocomplete="off" placeholder="What's on your todo list?" v-model="newItem" @keyup.enter="createItem">
      </div>
    </li>
    <li v-for="(item, index) in items"
      class="todo"
      :key="item.id"
      :class="{ completed: item.status}">
      <label>
        <input class="checkbox" type="checkbox" v-model="item.status" @change="completeItem(item)">
        <span></span>
        {{ item.description }}
      </label>
      <button role="button" class="btn btn-default btn-sm float-right btn-danger" @click="deleteItem(item, index)">&times;</button>
    </li>
  </ul>
</div>
</template>

<script>
import TodoApiClient from '../todo/TodoApiClient';

const Todo = new TodoApiClient(process.env.API_URL);

let interval = null;

export default {
  data () {
    return {
      newItem: "",
      items: []
    }
  },
  created () {
    document.title = 'All Items'
    this.getItems()
    interval = setInterval(this.getItems, 2000)
  },
  destroyed () {
    clearInterval(interval)
  },
  methods: {
    async getItems() {
      this.items = await Todo.getItems();
    },
    async deleteItem(item, index) {
      await Todo.deleteItem(item.id);
      this.items.splice(index, 1);
    },
    async completeItem(item) {
      await Todo.completeItem(item.id, item.status ? 1 : 0);
    },
    async createItem(item) {
      const newItem = await Todo.createItem({description: this.newItem});
      this.items.unshift(newItem);
      this.newItem = "";
    }
  }
}
</script>

<style lang="scss">

ul.todo-list {
  list-style-type: none;
  padding:0;
  margin:0;
  margin-top: 20px;

  li {
    word-break: break-all;
    padding: 15px 60px 15px 15px;
    margin-left: 45px;
    display: block;
    line-height: 1.2;
    transition: color 0.4s;

    position: relative;
    font-size: 24px;
    border-bottom: 1px solid #ededed;

    .form-control {
      font-size: 24px;
    }
    .form-group {
      margin:0;
    }

    &.new-todo {
      padding-top: 0;
      padding-bottom: 0;
    }

    transition: opacity .25s ease-in-out;
    &.completed {
      opacity: 0.5;
    }
  }
}
</style>
