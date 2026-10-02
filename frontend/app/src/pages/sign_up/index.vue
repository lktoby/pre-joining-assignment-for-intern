<script lang="ts">
export default {
    data() {
        return {
            name: '',
            identifier: '',
            password: '',
            passwordConfirmation: ''
        }
    },
    methods: {
        async signUp() {
            if (this.password !== this.passwordConfirmation) {
                alert('パスワードが一致しません');
                return;
            }
            const user = {
                name: this.name,
                identifier: this.identifier,
                password: this.password
            };

            if (user.identifier.length < 8 || user.password.length < 8) {
                alert('ユーザーIDとパスワードは8文字以上で入力してください');
                return;
            }

            try {
                const response = await fetch('/api/users', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ user })
                });

                if (response.ok) {
                    this.$router.push('/sign_in');
                } else {
                    const body = await response.json();
                    alert(`ユーザー登録に失敗しました (${response.status})`);
                }
            } catch (error) {
                console.error('Failed to create user', error);
                alert('ユーザー登録に失敗しました');
            }
        }
    }
}
</script>

<template>
    <form @submit.prevent="signUp">
        <p>ユーザー名 <input type="text" v-model="name"></p>
        <p>ユーザーID <input type="text" v-model="identifier"></p>
        <p>パスワード <input type="password" v-model="password"></p>
        <p>パスワード（確認用）<input type="password" v-model="passwordConfirmation"></p>
        <button type="submit">新規作成</button>
    </form>
</template>