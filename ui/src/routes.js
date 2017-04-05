import TodoList from './components/TodoList.vue'


export default [
  { path: '/todo', component: TodoList },
  { path: '/*', redirect: '/todo' }
]
