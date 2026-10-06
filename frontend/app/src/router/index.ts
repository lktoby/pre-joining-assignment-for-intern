import {
  createRouter,
  createWebHistory,
  type RouteRecordRaw,
} from 'vue-router';

import Root from '@/pages/Root.vue';
import Home from '@/pages/home/index.vue';
import SignIn from '@/pages/sign_in/index.vue';
import SignUp from '@/pages/sign_up/index.vue';

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: Root,
    children: [
      { path: '', component: Home },
      { path: 'home', component: Home },
    ],
  },
  { path: '/sign_in', component: SignIn },
  { path: '/sign_up', component: SignUp },
];

export const router = createRouter({
  history: createWebHistory(),
  routes,
});