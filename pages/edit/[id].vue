<template>
  <div>
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900">Edit Task</h1>
      <p class="text-gray-600 mt-1">Update task details</p>
    </div>
    
    <div v-if="taskStore.loading && !taskStore.currentTask">
      <LoadingSpinner />
    </div>
    
    <div v-else-if="!taskStore.currentTask && taskStore.error">
      <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6">
        <div class="flex">
          <div class="flex-shrink-0">
            <svg class="h-5 w-5 text-red-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
            </svg>
          </div>
          <div class="ml-3">
            <p class="text-sm text-red-700">{{ taskStore.error }}</p>
          </div>
        </div>
      </div>
      
      <EmptyState 
        title="Task not found" 
        message="The task you're looking for doesn't exist or has been deleted" 
        action-text="Back to Tasks" 
        action-route="/" 
      />
    </div>
    
    <div v-else-if="taskStore.currentTask" class="bg-white rounded-lg shadow-md p-6">
      <TaskForm 
        :task="taskStore.currentTask" 
        :loading="taskStore.loading" 
        @submit="handleSubmit" 
        @cancel="navigateBack" 
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useTaskStore } from '~/stores/taskStore';
import { UpdateTask } from '~/composables/useTaskService';

const route = useRoute();
const router = useRouter();
const taskStore = useTaskStore();

const taskId = route.params.id as string;

onMounted(async () => {
  await taskStore.fetchTaskById(taskId);
});

const handleSubmit = async (taskData: UpdateTask) => {
  const task = await taskStore.updateTask(taskId, taskData);
  if (task) {
    router.push('/');
  }
};

const navigateBack = () => {
  router.back();
};
</script>

