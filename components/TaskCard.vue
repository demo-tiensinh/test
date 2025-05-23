<template>
  <div class="bg-white rounded-lg shadow-md p-4 border-l-4" :class="borderColorClass">
    <div class="flex justify-between items-start">
      <div>
        <h3 class="text-lg font-semibold" :class="{ 'line-through text-gray-500': task.status === 'complete' }">
          {{ task.title }}
        </h3>
        <p v-if="task.description" class="text-gray-600 mt-1">{{ task.description }}</p>
      </div>
      <div class="flex space-x-2">
        <button 
          @click="$emit('toggle-status', task.id)" 
          class="p-2 rounded-full hover:bg-gray-100 transition-colors"
          :title="task.status === 'complete' ? 'Mark as incomplete' : 'Mark as complete'"
        >
          <span v-if="task.status === 'complete'" class="text-green-500">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
            </svg>
          </span>
          <span v-else class="text-gray-400">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v3.586L7.707 9.293a1 1 0 00-1.414 1.414l3 3a1 1 0 001.414 0l3-3a1 1 0 00-1.414-1.414L11 10.586V7z" clip-rule="evenodd" />
            </svg>
          </span>
        </button>
      </div>
    </div>
    
    <div class="mt-4 flex justify-between items-center text-sm">
      <div class="flex items-center space-x-4">
        <div class="flex items-center">
          <span class="text-gray-500 mr-1">Due:</span>
          <span :class="{ 'text-red-500': isOverdue && task.status !== 'complete', 'text-gray-600': !isOverdue || task.status === 'complete' }">
            {{ formatDate(task.dueDate) }}
          </span>
        </div>
        <div class="flex items-center">
          <span class="text-gray-500 mr-1">Priority:</span>
          <span :class="priorityTextClass">{{ priorityText }}</span>
        </div>
      </div>
      
      <div class="flex space-x-2">
        <NuxtLink :to="`/edit/${task.id}`" class="text-primary-600 hover:text-primary-800 transition-colors">
          Edit
        </NuxtLink>
        <button @click="$emit('delete', task.id)" class="text-red-600 hover:text-red-800 transition-colors">
          Delete
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { Task } from '~/composables/useTaskService';

const props = defineProps<{
  task: Task;
}>();

const emit = defineEmits<{
  (e: 'toggle-status', id: string): void;
  (e: 'delete', id: string): void;
}>();

const priorityText = computed(() => {
  switch (props.task.priority) {
    case 1: return 'High';
    case 2: return 'Medium';
    case 3: return 'Low';
    default: return 'Unknown';
  }
});

const priorityTextClass = computed(() => {
  switch (props.task.priority) {
    case 1: return 'text-red-600 font-medium';
    case 2: return 'text-yellow-600 font-medium';
    case 3: return 'text-green-600 font-medium';
    default: return 'text-gray-600';
  }
});

const borderColorClass = computed(() => {
  if (props.task.status === 'complete') {
    return 'border-green-500';
  }
  
  switch (props.task.priority) {
    case 1: return 'border-red-500';
    case 2: return 'border-yellow-500';
    case 3: return 'border-green-500';
    default: return 'border-gray-300';
  }
});

const isOverdue = computed(() => {
  const dueDate = new Date(props.task.dueDate);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  return dueDate < today;
});

const formatDate = (dateString: string) => {
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
};
</script>

