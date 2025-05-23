<template>
  <div class="bg-white rounded-lg shadow-sm p-4 mb-6">
    <h3 class="text-lg font-medium text-gray-700 mb-3">Filter Tasks</h3>
    
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div>
        <label for="status" class="block text-sm font-medium text-gray-700 mb-1">Status</label>
        <select
          id="status"
          v-model="filters.status"
          @change="applyFilters"
          class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary-500 focus:border-primary-500"
        >
          <option :value="undefined">All</option>
          <option value="incomplete">Incomplete</option>
          <option value="complete">Complete</option>
        </select>
      </div>
      
      <div>
        <label for="sortBy" class="block text-sm font-medium text-gray-700 mb-1">Sort By</label>
        <select
          id="sortBy"
          v-model="filters.sortBy"
          @change="applyFilters"
          class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary-500 focus:border-primary-500"
        >
          <option :value="undefined">Default</option>
          <option value="dueDate">Due Date</option>
          <option value="priority">Priority</option>
        </select>
      </div>
      
      <div>
        <label for="order" class="block text-sm font-medium text-gray-700 mb-1">Order</label>
        <select
          id="order"
          v-model="filters.order"
          @change="applyFilters"
          class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary-500 focus:border-primary-500"
        >
          <option value="asc">Ascending</option>
          <option value="desc">Descending</option>
        </select>
      </div>
    </div>
    
    <div class="mt-4 flex justify-end">
      <button
        @click="resetFilters"
        class="px-4 py-2 text-sm font-medium text-primary-600 hover:text-primary-800 focus:outline-none"
      >
        Reset Filters
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, watch } from 'vue';
import { TaskQueryParams } from '~/composables/useTaskService';

const props = defineProps<{
  initialFilters?: Partial<TaskQueryParams>;
}>();

const emit = defineEmits<{
  (e: 'filter', filters: TaskQueryParams): void;
  (e: 'reset'): void;
}>();

const filters = reactive<TaskQueryParams>({
  status: props.initialFilters?.status,
  sortBy: props.initialFilters?.sortBy,
  order: props.initialFilters?.order || 'asc',
});

// Watch for changes in props.initialFilters
watch(() => props.initialFilters, (newFilters) => {
  if (newFilters) {
    filters.status = newFilters.status;
    filters.sortBy = newFilters.sortBy;
    filters.order = newFilters.order || 'asc';
  }
}, { deep: true });

const applyFilters = () => {
  emit('filter', { ...filters });
};

const resetFilters = () => {
  filters.status = undefined;
  filters.sortBy = undefined;
  filters.order = 'asc';
  emit('reset');
};
</script>

