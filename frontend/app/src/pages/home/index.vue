<script lang="tsx">
import { createTask as createTaskReq, getTasks as getTasksReq, updateTask as updateTaskReq } from '@/repositories/taskRepository';
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
        isLoading: false,
        taskCompletion: [
            { value: 'all', label: 'すべて' },
            { value: 'incomplete', label: '未完了' },
            { value: 'complete', label: '完了' }
        ],
        completion: 'all',
        isCompleted: false,
        updatingTaskIds: [] as number[]
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
        async getTasks(type: string, completion: string, page: number) {
            this.isLoading = true;
            try {
                const response = await getTasksReq(type, completion, page, this.csrfToken);
                this.taskType = type;
                this.page = page;
                this.completion = completion;
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
        },
        async checkTask(taskId: number, check: boolean) {
            const completion = check ? 'complete' : 'incomplete';
            const task = this.tasks.tasks.find((t: any) => t.id === taskId);
            this.updatingTaskIds.push(taskId);
            try {
                const response = await updateTaskReq(taskId, completion, this.csrfToken);
                if (response.ok) {
                    const body = await response.json();
                    if (task) {
                        task.is_completed = body.task.is_completed;
                    }
                    console.log(body);
                } else {
                    if (task) {
                        task.is_completed = !check;
                    }
                    const body = await response.json();
                    window.alert(body.error);
                }
            } catch (error) {
                if (task) {
                    task.is_completed = !check;
                }
                console.error(error);
                window.alert('タスクの更新に失敗しました');
            } finally {
                const index = this.updatingTaskIds.indexOf(taskId);
                if (index !== -1) {
                    this.updatingTaskIds.splice(index, 1);
                }
            }
        }
    },
    async mounted() {
        await this.getCsrfToken();
        await this.getTasks('my', 'all', 1);
    }
};
</script>

<template>
    <form @submit.prevent="createTask">
        <p>タスク内容 <input type="text" v-model="taskBody"></p>
        <button type="submit">タスクを作成</button>
    </form>
    <hr>
    <div>
        <label for="completion">完了状態 </label>
        <select id="completion" v-model="completion" @change="getTasks(taskType, completion, 1)">
            <option v-for="option in taskCompletion" :value="option.value">
                {{ option.label }}
            </option>
        </select>
    </div>
    <br>
        <router-link to="/"><button v-on:click="getTasks('my', 'all', 1)">Myタスク</button></router-link>
        <router-link to="/"><button v-on:click="getTasks('others', 'all', 1)">みんなのタスク</button></router-link>
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
        <p v-if="taskType == 'my'">
            <input type="checkbox" :checked="task.is_completed" @change="checkTask(task.id, !task.is_completed)" :disabled="updatingTaskIds.includes(task.id)">完了
        </p>
        <p v-if="taskType == 'others'">{{ task.is_completed ? '完了' : '未完了' }}</p>
        <hr>
    </div>
    <button v-if="tasks.has_next" :disabled="isLoading" v-on:click="getTasks(taskType, completion, page+1)">さらに読み込む</button>
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