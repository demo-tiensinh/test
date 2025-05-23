<template>
  <div>
    <div class="mb-6">
      <h1 class="text-2xl font-bold text-gray-900">Task List</h1>
      <p class="text-gray-600 mt-1">Manage your tasks efficiently</p>
    </div>
    
    <TaskFilter 
      :initial-filters="taskStore.filters" 
      @filter="handleFilterChange" 
      @reset="handleFilterReset" 
    />
    
    <div v-if="taskStore.loading">
      <LoadingSpinner />
    </div>
    
    <div v-else-if="taskStore.tasks.length === 0">
      <EmptyState 
        title="No tasks found" 
        message="Get started by creating your first task" 
        action-text="Create Task" 
        action-route="/create" 
      />
    </div>
    
    <div v-else class="space-y-4">
      <TaskCard 
        v-for="task in taskStore.tasks" 
        :key="task.id" 
        :task="task" 
        @toggle-status="handleToggleStatus" 
        @delete="handleDeleteTask" 
      />
    </div>
    
    <div class="fixed bottom-6 right-6">
      <NuxtLink 
        to="/create" 
        class="flex items-center justify-center h-14 w-14 rounded-full bg-primary-600 text-white shadow-lg hover:bg-primary-700 transition-colors"
        title="Create new task"
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
        </svg>
      </NuxtLink>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue';
import { useTaskStore } from '~/stores/taskStore';
import { TaskQueryParams } from '~/composables/useTaskService';

const taskStore = useTaskStore();

onMounted(() => {
  taskStore.fetchTasks();
});

const handleFilterChange = (filters: TaskQueryParams) => {
  taskStore.setFilters(filters);
};

const handleFilterReset = () => {
  taskStore.clearFilters();
};

const handleToggleStatus = async (id: string) => {
  await taskStore.toggleTaskStatus(id);
};

const handleDeleteTask = async (id: string) => {
  if (confirm('Are you sure you want to delete this task?')) {
    await taskStore.deleteTask(id);
  }
};
</script>

