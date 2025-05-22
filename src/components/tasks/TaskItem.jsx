import { useState } from 'react';
import { 
  ListItem, 
  ListItemText, 
  IconButton, 
  Checkbox, 
  Typography, 
  Box,
  Menu,
  MenuItem,
  ListItemIcon,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button
} from '@mui/material';
import { 
  MoreVert as MoreVertIcon,
  Edit as EditIcon,
  Delete as DeleteIcon
} from '@mui/icons-material';
import { format } from 'date-fns';
import { useTasks } from '../../contexts/TaskContext';

const TaskItem = ({ task, onEdit }) => {
  const { updateTask, deleteTask } = useTasks();
  const [anchorEl, setAnchorEl] = useState(null);
  const [confirmDelete, setConfirmDelete] = useState(false);
  
  const handleMenuOpen = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleMenuClose = () => {
    setAnchorEl(null);
  };

  const handleToggleComplete = async () => {
    await updateTask(task.id, { completed: !task.completed });
  };

  const handleEdit = () => {
    handleMenuClose();
    onEdit();
  };

  const handleDeleteClick = () => {
    handleMenuClose();
    setConfirmDelete(true);
  };

  const handleDeleteConfirm = async () => {
    await deleteTask(task.id);
    setConfirmDelete(false);
  };

  const handleDeleteCancel = () => {
    setConfirmDelete(false);
  };

  return (
    <>
      <ListItem
        secondaryAction={
          <IconButton edge="end" onClick={handleMenuOpen}>
            <MoreVertIcon />
          </IconButton>
        }
        sx={{
          border: '1px solid',
          borderColor: 'divider',
          borderRadius: 1,
          mb: 1,
          bgcolor: task.completed ? 'action.hover' : 'background.paper'
        }}
      >
        <Checkbox
          edge="start"
          checked={task.completed}
          onChange={handleToggleComplete}
        />
        <ListItemText
          primary={
            <Typography
              variant="subtitle1"
              sx={{
                textDecoration: task.completed ? 'line-through' : 'none',
                color: task.completed ? 'text.secondary' : 'text.primary'
              }}
            >
              {task.title}
            </Typography>
          }
          secondary={
            <Box>
              <Typography variant="body2" color="text.secondary">
                {task.description}
              </Typography>
              <Typography variant="caption" color="text.secondary">
                Created: {format(new Date(task.createdAt), 'MMM d, yyyy')}
              </Typography>
            </Box>
          }
        />
      </ListItem>

      <Menu
        anchorEl={anchorEl}
        open={Boolean(anchorEl)}
        onClose={handleMenuClose}
      >
        <MenuItem onClick={handleEdit}>
          <ListItemIcon>
            <EditIcon fontSize="small" />
          </ListItemIcon>
          Edit
        </MenuItem>
        <MenuItem onClick={handleDeleteClick}>
          <ListItemIcon>
            <DeleteIcon fontSize="small" color="error" />
          </ListItemIcon>
          <Typography color="error">Delete</Typography>
        </MenuItem>
      </Menu>

      <Dialog open={confirmDelete} onClose={handleDeleteCancel}>
        <DialogTitle>Confirm Delete</DialogTitle>
        <DialogContent>
          Are you sure you want to delete "{task.title}"?
        </DialogContent>
        <DialogActions>
          <Button onClick={handleDeleteCancel}>Cancel</Button>
          <Button onClick={handleDeleteConfirm} color="error">
            Delete
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
};

export default TaskItem;

