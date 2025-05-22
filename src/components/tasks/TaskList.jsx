import { useState, useEffect } from 'react';
import { 
  Box, 
  Typography, 
  List, 
  CircularProgress, 
  Alert,
  Button,
  Dialog,
  DialogTitle,
  DialogContent
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import { useTasks } from '../../contexts/TaskContext';
import TaskItem from './TaskItem';
import TaskForm from './TaskForm';

const TaskList = () => {
  const { tasks, isLoading, error, fetchTasks } = useTasks();
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedTask, setSelectedTask] = useState(null);

  useEffect(() => {
    fetchTasks();
  }, [fetchTasks]);

  const handleAddTask = () => {
    setSelectedTask(null);
    setOpenDialog(true);
  };

  const handleEditTask = (task) => {
    setSelectedTask(task);
    setOpenDialog(true);
  };

  const handleCloseDialog = () => {
    setOpenDialog(false);
    setSelectedTask(null);
  };

  if (isLoading && tasks.length === 0) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', mt: 4 }}>
        <CircularProgress />
      </Box>
    );
  }

  if (error) {
    return (
      <Alert severity="error" sx={{ mt: 2 }}>
        {error}
      </Alert>
    );
  }

  return (
    <Box sx={{ mt: 4 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
        <Typography variant="h5" component="h2">
          My Tasks
        </Typography>
        <Button 
          variant="contained" 
          color="primary" 
          startIcon={<AddIcon />}
          onClick={handleAddTask}
        >
          Add Task
        </Button>
      </Box>

      {tasks.length === 0 ? (
        <Typography variant="body1" color="textSecondary">
          No tasks found. Create your first task!
        </Typography>
      ) : (
        <List>
          {tasks.map((task) => (
            <TaskItem 
              key={task.id} 
              task={task} 
              onEdit={() => handleEditTask(task)} 
            />
          ))}
        </List>
      )}

      <Dialog open={openDialog} onClose={handleCloseDialog} maxWidth="sm" fullWidth>
        <DialogTitle>
          {selectedTask ? 'Edit Task' : 'Add New Task'}
        </DialogTitle>
        <DialogContent>
          <TaskForm 
            task={selectedTask} 
            onClose={handleCloseDialog} 
          />
        </DialogContent>
      </Dialog>
    </Box>
  );
};

export default TaskList;

