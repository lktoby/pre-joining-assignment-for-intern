<script lang="tsx">
import { createTask as createTaskReq, getTasks as getTasksReq } from '@/repositories/taskRepository';
import { getCsrfToken } from '@/repositories/csrfTokenRepository';
export default {
  data() {
    return {
        taskBody: '',
        csrfToken: '',
        page: 1,
        taskType: 'my',
        tasks: {
            tasks: [
                {
                    id: 0,
                    body: '',
                    is_completed: false,
                    created_at: '',
                    updated_at: '',
                    user: {
                        id: 0,
                        name: ''
                    }
                }
            ],
            has_next: false
        },
        isLoading: false
    };
    },
    methods: {
        formatDate(dateString: string) {
            const date = new Date(dateString);
            return date.toLocaleString();
        },
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
        async getTasks(type: string, page: number) {
            this.isLoading = true;
            try {
                const response = await getTasksReq(type, page, this.csrfToken);
                this.taskType = type;
                this.page = page;
                if (response.ok) {
                    const data = await response.json();
                    console.log(data);
                    if (page === 1) {
                        this.tasks = data;
                    } else {
                        this.tasks.tasks.push(...data.tasks);
                        this.tasks.has_next = data.has_next;
                    }
                } else {
                    const body = await response.json();
                    window.alert(body.error);
                }
            } catch (error) {
                console.error(error);
                window.alert('タスクの取得に失敗しました');
            } finally {
                this.isLoading = false;
            }
        }
    },
    async mounted() {
        await this.getCsrfToken();
        await this.getTasks('my', 1);
    }
};
</script>

<template>
    <form @submit.prevent="createTask">
        <p>タスク内容 <input type="text" v-model="taskBody"></p>
        <button type="submit">タスクを作成</button>
    </form>
    <hr>
    <router-link to="/"><button v-on:click="getTasks('my', 1)">Myタスク</button></router-link>
    <router-link to="/"><button v-on:click="getTasks('others', 1)">みんなのタスク</button></router-link>
    <br>
    <div v-if="tasks.tasks.length === 0">
        <p>表示できるタスクがありません</p>
    </div>
    <div v-for="task in tasks.tasks" :key="task.id">
        <p class="task">
            <b>{{ task.user.name }}</b>
            <span class="date">{{ formatDate(task.created_at) }}</span>
        </p>
        <p>{{ task.body }}</p>
        <hr>
    </div>
    <button v-if="tasks.has_next" :disabled="isLoading" v-on:click="getTasks(taskType, page+1)">さらに読み込む</button>
</template>

<style lang="css" scoped>
.task {
    display: flex;
    justify-content: space-between;
}
.date {
    color: gray;
    margin-right: 5px;
}
</style>