import { createContext, useState, useContext, useEffect } from 'react';
import taskService from '../services/taskService';
import { useAuth } from './AuthContext';

// Create task context
const TaskContext = createContext(null);

export const TaskProvider = ({ children }) => {
  const [tasks, setTasks] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);
  const { isAuthenticated } = useAuth();

  // Fetch tasks when authenticated
  useEffect(() => {
    if (isAuthenticated) {
      fetchTasks();
    } else {
      setTasks([]);
    }
  }, [isAuthenticated]);

  // Fetch all tasks
  const fetchTasks = async () => {
    setIsLoading(true);
    setError(null);
    
    try {
      const data = await taskService.getAllTasks();
      setTasks(data);
    } catch (err) {
      setError(err.message || 'Failed to fetch tasks');
    } finally {
      setIsLoading(false);
    }
  };

  // Get task by ID
  const getTask = async (id) => {
    setIsLoading(true);
    setError(null);
    
    try {
      return await taskService.getTaskById(id);
    } catch (err) {
      setError(err.message || 'Failed to get task');
      return null;
    } finally {
      setIsLoading(false);
    }
  };

  // Create new task
  const createTask = async (taskData) => {
    setIsLoading(true);
    setError(null);
    
    try {
      const newTask = await taskService.createTask(taskData);
      setTasks([...tasks, newTask]);
      return newTask;
    } catch (err) {
      setError(err.message || 'Failed to create task');
      return null;
    } finally {
      setIsLoading(false);
    }
  };

  // Update task
  const updateTask = async (id, taskData) => {
    setIsLoading(true);
    setError(null);
    
    try {
      const updatedTask = await taskService.updateTask(id, taskData);
      setTasks(tasks.map(task => task.id === id ? updatedTask : task));
      return updatedTask;
    } catch (err) {
      setError(err.message || 'Failed to update task');
      return null;
    } finally {
      setIsLoading(false);
    }
  };

  // Delete task
  const deleteTask = async (id) => {
    setIsLoading(true);
    setError(null);
    
    try {
      await taskService.deleteTask(id);
      setTasks(tasks.filter(task => task.id !== id));
      return true;
    } catch (err) {
      setError(err.message || 'Failed to delete task');
      return false;
    } finally {
      setIsLoading(false);
    }
  };

  // Context value
  const value = {
    tasks,
    isLoading,
    error,
    fetchTasks,
    getTask,
    createTask,
    updateTask,
    deleteTask
  };

  return <TaskContext.Provider value={value}>{children}</TaskContext.Provider>;
};

// Custom hook to use task context
export const useTasks = () => {
  const context = useContext(TaskContext);
  if (!context) {
    throw new Error('useTasks must be used within a TaskProvider');
  }
  return context;
};

export default TaskContext;

