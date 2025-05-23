<template>
  <form @submit.prevent="submitForm" class="space-y-6">
    <div>
      <label for="title" class="block text-sm font-medium text-gray-700">Title *</label>
      <input
        id="title"
        v-model="formData.title"
        type="text"
        required
        class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary-500 focus:border-primary-500"
        placeholder="Task title"
      />
      <p v-if="errors.title" class="mt-1 text-sm text-red-600">{{ errors.title }}</p>
    </div>
    
    <div>
      <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
      <textarea
        id="description"
        v-model="formData.description"
        rows="3"
        class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary-500 focus:border-primary-500"
        placeholder="Task description (optional)"
      ></textarea>
    </div>
    
    <div>
      <label for="dueDate" class="block text-sm font-medium text-gray-700">Due Date *</label>
      <input
        id="dueDate"
        v-model="formData.dueDate"
        type="datetime-local"
        required
        class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary-500 focus:border-primary-500"
      />
      <p v-if="errors.dueDate" class="mt-1 text-sm text-red-600">{{ errors.dueDate }}</p>
    </div>
    
    <div>
      <label for="priority" class="block text-sm font-medium text-gray-700">Priority *</label>
      <select
        id="priority"
        v-model="formData.priority"
        required
        class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary-500 focus:border-primary-500"
      >
        <option :value="1">High</option>
        <option :value="2">Medium</option>
        <option :value="3">Low</option>
      </select>
    </div>
    
    <div v-if="isEditMode">
      <label for="status" class="block text-sm font-medium text-gray-700">Status</label>
      <select
        id="status"
        v-model="formData.status"
        class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary-500 focus:border-primary-500"
      >
        <option value="incomplete">Incomplete</option>
        <option value="complete">Complete</option>
      </select>
    </div>
    
    <div class="flex justify-end space-x-3">
      <button
        type="button"
        @click="$emit('cancel')"
        class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500"
      >
        Cancel
      </button>
      <button
        type="submit"
        :disabled="loading"
        class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:opacity-50 disabled:cursor-not-allowed"
      >
        <span v-if="loading">Saving...</span>
        <span v-else>{{ isEditMode ? 'Update Task' : 'Create Task' }}</span>
      </button>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, reactive, computed, watch } from 'vue';
import { Task, NewTask, UpdateTask } from '~/composables/useTaskService';

const props = defineProps<{
  task?: Task;
  loading?: boolean;
}>();

const emit = defineEmits<{
  (e: 'submit', data: NewTask | UpdateTask): void;
  (e: 'cancel'): void;
}>();

const isEditMode = computed(() => !!props.task);

// Format date for datetime-local input
const formatDateForInput = (dateString?: string) => {
  if (!dateString) return '';
  const date = new Date(dateString);
  return date.toISOString().slice(0, 16); // Format: YYYY-MM-DDTHH:MM
};

// Initialize form data
const formData = reactive<{
  title: string;
  description: string;
  dueDate: string;
  priority: 1 | 2 | 3;
  status?: 'incomplete' | 'complete';
}>({
  title: props.task?.title || '',
  description: props.task?.description || '',
  dueDate: formatDateForInput(props.task?.dueDate) || formatDateForInput(new Date().toISOString()),
  priority: props.task?.priority || 2,
  status: props.task?.status,
});

// Form validation
const errors = reactive({
  title: '',
  dueDate: '',
});

// Watch for changes in props.task
watch(() => props.task, (newTask) => {
  if (newTask) {
    formData.title = newTask.title;
    formData.description = newTask.description;
    formData.dueDate = formatDateForInput(newTask.dueDate);
    formData.priority = newTask.priority;
    formData.status = newTask.status;
  }
}, { deep: true });

const validateForm = () => {
  let isValid = true;
  
  // Validate title
  if (!formData.title.trim()) {
    errors.title = 'Title is required';
    isValid = false;
  } else {
    errors.title = '';
  }
  
  // Validate due date
  if (!formData.dueDate) {
    errors.dueDate = 'Due date is required';
    isValid = false;
  } else {
    errors.dueDate = '';
  }
  
  return isValid;
};

const submitForm = () => {
  if (!validateForm()) return;
  
  // Convert dueDate to ISO string
  const dueDateISO = new Date(formData.dueDate).toISOString();
  
  if (isEditMode.value) {
    // For edit mode, only include changed fields
    const updateData: UpdateTask = {};
    
    if (formData.title !== props.task?.title) {
      updateData.title = formData.title;
    }
    
    if (formData.description !== props.task?.description) {
      updateData.description = formData.description;
    }
    
    if (dueDateISO !== props.task?.dueDate) {
      updateData.dueDate = dueDateISO;
    }
    
    if (formData.priority !== props.task?.priority) {
      updateData.priority = formData.priority;
    }
    
    if (formData.status !== props.task?.status) {
      updateData.status = formData.status;
    }
    
    emit('submit', updateData);
  } else {
    // For create mode, include all required fields
    const newTask: NewTask = {
      title: formData.title,
      description: formData.description || undefined,
      dueDate: dueDateISO,
      priority: formData.priority,
    };
    
    emit('submit', newTask);
  }
};
</script>

