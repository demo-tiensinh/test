<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8 text-center">
      <div>
        <h2 class="mt-6 text-3xl font-extrabold text-gray-900">
          {{ error.statusCode === 404 ? 'Page not found' : 'An error occurred' }}
        </h2>
        <p class="mt-2 text-sm text-gray-600">
          {{ error.message || 'Sorry, we couldn\'t find the page you\'re looking for.' }}
        </p>
      </div>
      <div>
        <button
          @click="handleError"
          class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
        >
          Back to home
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps({
  error: Object
});

const handleError = () => {
  clearError({ redirect: '/' });
};
</script>

