<template>
  <div>
    <div class="mb-6 flex justify-between items-center">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">Task Details</h1>
        <p class="text-gray-600 mt-1">View detailed information about this task</p>
      </div>
      <div class="flex space-x-3">
        <NuxtLink 
          :to="`/edit/${taskId}`" 
          class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
        >
          Edit Task
        </NuxtLink>
        <button 
          @click="handleDelete" 
          class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
        >
          Delete
        </button>
      </div>
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
      <div class="border-b pb-4 mb-4">
        <div class="flex justify-between items-start">
          <h2 class="text-xl font-semibold text-gray-900">{{ taskStore.currentTask.title }}</h2>
          <span 
            class="px-2 py-1 text-xs font-medium rounded-full" 
            :class="statusClass"
          >
            {{ taskStore.currentTask.status === 'complete' ? 'Completed' : 'Incomplete' }}
          </span>
        </div>
      </div>
      
      <div class="space-y-4">
        <div v-if="taskStore.currentTask.description">
          <h3 class="text-sm font-medium text-gray-500">Description</h3>
          <p class="mt-1 text-gray-900">{{ taskStore.currentTask.description }}</p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <h3 class="text-sm font-medium text-gray-500">Due Date</h3>
            <p class="mt-1 text-gray-900">{{ formatDate(taskStore.currentTask.dueDate) }}</p>
          </div>
          
          <div>
            <h3 class="text-sm font-medium text-gray-500">Priority</h3>
            <p class="mt-1" :class="priorityClass">{{ priorityText }}</p>
          </div>
        </div>
      </div>
      
      <div class="mt-6 pt-4 border-t">
        <button 
          @click="handleToggleStatus" 
          class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
          :class="taskStore.currentTask.status === 'complete' ? 'text-yellow-700' : 'text-green-700'"
        >
          {{ taskStore.currentTask.status === 'complete' ? 'Mark as Incomplete' : 'Mark as Complete' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useTaskStore } from '~/stores/taskStore';

const route = useRoute();
const router = useRouter();
const taskStore = useTaskStore();

const taskId = computed(() => route.params.id as string);

onMounted(async () => {
  await taskStore.fetchTaskById(taskId.value);
});

const statusClass = computed(() => {
  return taskStore.currentTask?.status === 'complete'
    ? 'bg-green-100 text-green-800'
    : 'bg-yellow-100 text-yellow-800';
});

const priorityText = computed(() => {
  if (!taskStore.currentTask) return '';
  
  switch (taskStore.currentTask.priority) {
    case 1: return 'High';
    case 2: return 'Medium';
    case 3: return 'Low';
    default: return 'Unknown';
  }
});

const priorityClass = computed(() => {
  if (!taskStore.currentTask) return '';
  
  switch (taskStore.currentTask.priority) {
    case 1: return 'text-red-600 font-medium';
    case 2: return 'text-yellow-600 font-medium';
    case 3: return 'text-green-600 font-medium';
    default: return 'text-gray-600';
  }
});

const formatDate = (dateString: string) => {
  const date = new Date(dateString);
  return date.toLocaleString('en-US', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });
};

const handleToggleStatus = async () => {
  if (taskStore.currentTask) {
    await taskStore.toggleTaskStatus(taskStore.currentTask.id);
  }
};

const handleDelete = async () => {
  if (!taskStore.currentTask) return;
  
  if (confirm('Are you sure you want to delete this task?')) {
    const success = await taskStore.deleteTask(taskStore.currentTask.id);
    if (success) {
      router.push('/');
    }
  }
};
</script>

