<script lang="tsx">
import { createTask as createTaskReq } from '@/repositories/taskRepository';
import { getCsrfToken } from '@/repositories/csrfTokenRepository';
export default {
  data() {
    return {
        taskBody: '',
        csrfToken: ''
    };
    },
    methods: {
        async getCsrfToken() {
            try {
                const response = await getCsrfToken();
                if (response.ok) {
                    const body = await response.json();
                    this.csrfToken = body.csrfToken;
                } else {
                    console.error(response.status);
                }
            } catch (error) {
                console.error(error);
            }
        },
        async createTask() {
            try {
                const response = await createTaskReq(this.taskBody, this.csrfToken);
                if (response.ok) {
                    this.taskBody = '';
                    window.location.href = '/';
                } else {
                    const body = await response.json();
                    window.alert(body.error);
                }
            } catch (error) {
                console.error(error);
            }
        },
    },
    async mounted() {
        await this.getCsrfToken();
    }
};
</script>

<template>
    <form @submit.prevent="createTask">
        <p>タスク内容 <input type="text" v-model="taskBody"></p>
        <button type="submit">タスクを作成</button>
    </form>
</template>