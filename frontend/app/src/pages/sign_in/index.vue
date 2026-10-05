<script lang="tsx">

export default {
    data() {
        return {
            identifier: '',
            password: '',
            csrfToken: ''
        }
    },
    methods: {
        async getCsrfToken() {
            try {
                const response = await fetch('/api/csrf-token', {
                    method: 'GET',
                    credentials: 'include'
                });

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
        async signIn() {
            try {
                const response = await fetch('/api/sessions', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-Token': this.csrfToken
                    },
                    body: JSON.stringify({
                        session: {
                            identifier: this.identifier,
                            password: this.password
                        }
                    }),
                    credentials: 'include'
                })
                const body = await response.json();
                if (response.ok) {
                    window.location.href = '/';
                } else {
                    window.alert(body.error);
                    window.location.href = '/';
                }
            } catch (error) {
                console.error(error);
                alert('サインインに失敗しました');
            }
        }
    },
    async mounted() {
        await this.getCsrfToken();
        try {
            const response = await fetch('/api/sessions/new', {
                method: 'GET',
                credentials: 'include'
            }).then(res => res.json());
            if (response.status === 'authenticated') {
                window.alert('すでにログインしています');
                window.location.href = '/';
            }
        } catch (error) {
            console.error(error);
        }
    }
}
</script>

<template>
    <h1>こちらはサインインページです</h1>
    <form @submit.prevent="signIn">
        <p>ユーザー識別子<input type="text" v-model="identifier"></p>
        <p>パスワード<input type="password" v-model="password"></p>
        <button type="submit">ログイン</button>
    </form>
</template>