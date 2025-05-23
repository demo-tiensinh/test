import { defineStore } from 'pinia';
import { 
  Task, 
  NewTask, 
  UpdateTask, 
  TaskQueryParams, 
  useTaskService 
} from '~/composables/useTaskService';

export const useTaskStore = defineStore('tasks', {
  state: () => ({
    tasks: [] as Task[],
    currentTask: null as Task | null,
    loading: false,
    error: null as string | null,
    filters: {
      status: undefined as 'incomplete' | 'complete' | undefined,
      sortBy: undefined as 'dueDate' | 'priority' | undefined,
      order: 'asc' as 'asc' | 'desc',
    },
  }),
  
  getters: {
    getTaskById: (state) => (id: string) => {
      return state.tasks.find(task => task.id === id);
    },
    
    filteredTasks: (state) => {
      return [...state.tasks];
    },
    
    incompleteTasks: (state) => {
      return state.tasks.filter(task => task.status === 'incomplete');
    },
    
    completeTasks: (state) => {
      return state.tasks.filter(task => task.status === 'complete');
    },
    
    tasksByPriority: (state) => {
      return [...state.tasks].sort((a, b) => a.priority - b.priority);
    },
  },
  
  actions: {
    async fetchTasks(params?: TaskQueryParams) {
      const taskService = useTaskService();
      this.loading = true;
      this.error = null;
      
      try {
        const queryParams = params || this.filters;
        const tasks = await taskService.getTasks(queryParams);
        this.tasks = tasks;
      } catch (error) {
        this.error = 'Failed to fetch tasks';
        console.error(error);
      } finally {
        this.loading = false;
      }
    },
    
    async fetchTaskById(id: string) {
      const taskService = useTaskService();
      this.loading = true;
      this.error = null;
      
      try {
        const task = await taskService.getTaskById(id);
        if (task) {
          this.currentTask = task;
          
          // Update the task in the tasks array if it exists
          const index = this.tasks.findIndex(t => t.id === id);
          if (index !== -1) {
            this.tasks[index] = task;
          }
        }
      } catch (error) {
        this.error = `Failed to fetch task ${id}`;
        console.error(error);
      } finally {
        this.loading = false;
      }
    },
    
    async createTask(newTask: NewTask) {
      const taskService = useTaskService();
      this.loading = true;
      this.error = null;
      
      try {
        const task = await taskService.createTask(newTask);
        if (task) {
          this.tasks.push(task);
          return task;
        }
        return null;
      } catch (error) {
        this.error = 'Failed to create task';
        console.error(error);
        return null;
      } finally {
        this.loading = false;
      }
    },
    
    async updateTask(id: string, updateData: UpdateTask) {
      const taskService = useTaskService();
      this.loading = true;
      this.error = null;
      
      try {
        const updatedTask = await taskService.updateTask(id, updateData);
        if (updatedTask) {
          // Update in the tasks array
          const index = this.tasks.findIndex(task => task.id === id);
          if (index !== -1) {
            this.tasks[index] = updatedTask;
          }
          
          // Update current task if it's the one being edited
          if (this.currentTask && this.currentTask.id === id) {
            this.currentTask = updatedTask;
          }
          
          return updatedTask;
        }
        return null;
      } catch (error) {
        this.error = `Failed to update task ${id}`;
        console.error(error);
        return null;
      } finally {
        this.loading = false;
      }
    },
    
    async deleteTask(id: string) {
      const taskService = useTaskService();
      this.loading = true;
      this.error = null;
      
      try {
        const success = await taskService.deleteTask(id);
        if (success) {
          // Remove from the tasks array
          this.tasks = this.tasks.filter(task => task.id !== id);
          
          // Clear current task if it's the one being deleted
          if (this.currentTask && this.currentTask.id === id) {
            this.currentTask = null;
          }
          
          return true;
        }
        return false;
      } catch (error) {
        this.error = `Failed to delete task ${id}`;
        console.error(error);
        return false;
      } finally {
        this.loading = false;
      }
    },
    
    async toggleTaskStatus(id: string) {
      const task = this.getTaskById(id);
      if (!task) return false;
      
      const newStatus = task.status === 'complete' ? 'incomplete' : 'complete';
      return await this.updateTask(id, { status: newStatus });
    },
    
    setFilters(filters: Partial<TaskQueryParams>) {
      this.filters = { ...this.filters, ...filters };
      this.fetchTasks(this.filters);
    },
    
    clearFilters() {
      this.filters = {
        status: undefined,
        sortBy: undefined,
        order: 'asc',
      };
      this.fetchTasks();
    },
  },
});

