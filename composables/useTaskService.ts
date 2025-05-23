import { useApi } from './useApi';

export interface Task {
  id: string;
  title: string;
  description: string;
  dueDate: string;
  priority: 1 | 2 | 3;
  status: 'incomplete' | 'complete';
}

export interface NewTask {
  title: string;
  description?: string;
  dueDate: string;
  priority: 1 | 2 | 3;
}

export interface UpdateTask {
  title?: string;
  description?: string;
  dueDate?: string;
  priority?: 1 | 2 | 3;
  status?: 'incomplete' | 'complete';
}

export interface TaskQueryParams {
  status?: 'incomplete' | 'complete';
  sortBy?: 'dueDate' | 'priority';
  order?: 'asc' | 'desc';
}

export const useTaskService = () => {
  const api = useApi();
  
  const getTasks = async (params?: TaskQueryParams): Promise<Task[]> => {
    try {
      const response = await api.get('/tasks', { params });
      return response.data;
    } catch (error) {
      console.error('Error fetching tasks:', error);
      return [];
    }
  };
  
  const getTaskById = async (id: string): Promise<Task | null> => {
    try {
      const response = await api.get(`/tasks/${id}`);
      return response.data;
    } catch (error) {
      console.error(`Error fetching task ${id}:`, error);
      return null;
    }
  };
  
  const createTask = async (task: NewTask): Promise<Task | null> => {
    try {
      const response = await api.post('/tasks', task);
      return response.data;
    } catch (error) {
      console.error('Error creating task:', error);
      return null;
    }
  };
  
  const updateTask = async (id: string, task: UpdateTask): Promise<Task | null> => {
    try {
      const response = await api.patch(`/tasks/${id}`, task);
      return response.data;
    } catch (error) {
      console.error(`Error updating task ${id}:`, error);
      return null;
    }
  };
  
  const deleteTask = async (id: string): Promise<boolean> => {
    try {
      await api.delete(`/tasks/${id}`);
      return true;
    } catch (error) {
      console.error(`Error deleting task ${id}:`, error);
      return false;
    }
  };
  
  return {
    getTasks,
    getTaskById,
    createTask,
    updateTask,
    deleteTask,
  };
};

