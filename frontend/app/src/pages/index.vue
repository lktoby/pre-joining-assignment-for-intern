<script lang="ts">
export default {
  async mounted() {
    try {
      const response = await fetch('/api/sessions/new');
      const data = await response.json();
      if (data.status == 'unauthenticated') {
        window.location.href = '/sign_in';
      }
    } catch (error) {
      console.error(error);
    }
  }
}
</script>

<template>
  <div>
    RootView
  </div>
</template>