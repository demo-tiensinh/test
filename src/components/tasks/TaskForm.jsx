import { useState, useEffect } from 'react';
import { 
  Box, 
  TextField, 
  Button, 
  FormControlLabel,
  Checkbox,
  Alert,
  CircularProgress
} from '@mui/material';
import { useTasks } from '../../contexts/TaskContext';

const TaskForm = ({ task, onClose }) => {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [completed, setCompleted] = useState(false);
  const [formErrors, setFormErrors] = useState({});
  const { createTask, updateTask, isLoading, error } = useTasks();

  // Initialize form with task data if editing
  useEffect(() => {
    if (task) {
      setTitle(task.title);
      setDescription(task.description);
      setCompleted(task.completed);
    }
  }, [task]);

  const validateForm = () => {
    const errors = {};
    
    if (!title.trim()) {
      errors.title = 'Title is required';
    }
    
    if (!description.trim()) {
      errors.description = 'Description is required';
    }
    
    setFormErrors(errors);
    return Object.keys(errors).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!validateForm()) {
      return;
    }
    
    const taskData = {
      title: title.trim(),
      description: description.trim(),
      ...(task && { completed })
    };
    
    let success;
    
    if (task) {
      // Update existing task
      success = await updateTask(task.id, taskData);
    } else {
      // Create new task
      success = await createTask(taskData);
    }
    
    if (success) {
      onClose();
    }
  };

  return (
    <Box component="form" onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
      {error && (
        <Alert severity="error" sx={{ mb: 2 }}>
          {error}
        </Alert>
      )}
      
      <TextField
        margin="normal"
        required
        fullWidth
        id="title"
        label="Title"
        name="title"
        autoFocus
        value={title}
        onChange={(e) => setTitle(e.target.value)}
        error={!!formErrors.title}
        helperText={formErrors.title}
        disabled={isLoading}
      />
      
      <TextField
        margin="normal"
        required
        fullWidth
        multiline
        rows={4}
        id="description"
        label="Description"
        name="description"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
        error={!!formErrors.description}
        helperText={formErrors.description}
        disabled={isLoading}
      />
      
      {task && (
        <FormControlLabel
          control={
            <Checkbox
              checked={completed}
              onChange={(e) => setCompleted(e.target.checked)}
              disabled={isLoading}
            />
          }
          label="Completed"
          sx={{ mt: 1 }}
        />
      )}
      
      <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 3, gap: 1 }}>
        <Button onClick={onClose} disabled={isLoading}>
          Cancel
        </Button>
        <Button
          type="submit"
          variant="contained"
          disabled={isLoading}
        >
          {isLoading ? <CircularProgress size={24} /> : (task ? 'Update' : 'Create')}
        </Button>
      </Box>
    </Box>
  );
};

export default TaskForm;

