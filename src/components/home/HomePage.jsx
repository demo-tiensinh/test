import { Box, Typography, Container } from '@mui/material';
import { useAuth } from '../../contexts/AuthContext';
import TaskList from '../tasks/TaskList';

const HomePage = () => {
  const { isAuthenticated } = useAuth();

  return (
    <Container maxWidth="md">
      <Box sx={{ mt: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          Todo App
        </Typography>
        
        <Typography variant="body1" paragraph>
          Welcome to the Todo App! This application helps you manage your tasks efficiently.
        </Typography>
        
        {isAuthenticated ? (
          <TaskList />
        ) : (
          <Typography variant="body1">
            Please login to view and manage your tasks.
          </Typography>
        )}
      </Box>
    </Container>
  );
};

export default HomePage;

