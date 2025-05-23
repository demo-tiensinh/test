<template>
  <div>
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900">Create New Task</h1>
      <p class="text-gray-600 mt-1">Add a new task to your list</p>
    </div>
    
    <div class="bg-white rounded-lg shadow-md p-6">
      <TaskForm 
        :loading="taskStore.loading" 
        @submit="handleSubmit" 
        @cancel="navigateBack" 
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';
import { useTaskStore } from '~/stores/taskStore';
import { NewTask } from '~/composables/useTaskService';

const router = useRouter();
const taskStore = useTaskStore();

const handleSubmit = async (taskData: NewTask) => {
  const task = await taskStore.createTask(taskData);
  if (task) {
    router.push('/');
  }
};

const navigateBack = () => {
  router.back();
};
</script>

