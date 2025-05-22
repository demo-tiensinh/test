import api from './api';

const taskService = {
  /**
   * Get all tasks
   * @returns {Promise} - Promise with array of tasks
   */
  getAllTasks: async () => {
    try {
      const response = await api.get('/tasks');
      return response.data;
    } catch (error) {
      throw error.response ? error.response.data : { message: 'Network error' };
    }
  },

  /**
   * Get task by ID
   * @param {string} id - Task ID
   * @returns {Promise} - Promise with task data
   */
  getTaskById: async (id) => {
    try {
      const response = await api.get(`/tasks/${id}`);
      return response.data;
    } catch (error) {
      throw error.response ? error.response.data : { message: 'Network error' };
    }
  },

  /**
   * Create a new task
   * @param {Object} taskData - Task data (title, description)
   * @returns {Promise} - Promise with created task
   */
  createTask: async (taskData) => {
    try {
      const response = await api.post('/tasks', taskData);
      return response.data;
    } catch (error) {
      throw error.response ? error.response.data : { message: 'Network error' };
    }
  },

  /**
   * Update an existing task
   * @param {string} id - Task ID
   * @param {Object} taskData - Task data to update (title, description, completed)
   * @returns {Promise} - Promise with updated task
   */
  updateTask: async (id, taskData) => {
    try {
      const response = await api.patch(`/tasks/${id}`, taskData);
      return response.data;
    } catch (error) {
      throw error.response ? error.response.data : { message: 'Network error' };
    }
  },

  /**
   * Delete a task
   * @param {string} id - Task ID
   * @returns {Promise} - Promise with no content
   */
  deleteTask: async (id) => {
    try {
      await api.delete(`/tasks/${id}`);
      return true;
    } catch (error) {
      throw error.response ? error.response.data : { message: 'Network error' };
    }
  }
};

export default taskService;

