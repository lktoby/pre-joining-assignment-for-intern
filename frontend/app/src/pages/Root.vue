<script lang="ts">
export default {
  data() {
    return {
      isAuthenticated: false,
      authCheckCompleted: false,
    };
  },
  async mounted() {
    try {
      const response = await fetch('/api/sessions/new');
      const data = await response.json();
      if (data.status == 'unauthenticated') {
        window.location.href = '/sign_in';
        return;
      }
      this.isAuthenticated = true;
      this.authCheckCompleted = true;
    } catch (error) {
      console.error(error);
    }
  }
}
</script>

<template>
  <RouterView v-if="authCheckCompleted && isAuthenticated" />
</template>
