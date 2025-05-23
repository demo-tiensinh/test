import axios from 'axios';

export const useApi = () => {
  const config = useRuntimeConfig();
  const baseURL = config.public.apiBaseUrl;
  
  const api = axios.create({
    baseURL,
    headers: {
      'Content-Type': 'application/json',
    },
  });
  
  // Add response interceptor for error handling
  api.interceptors.response.use(
    (response) => response,
    (error) => {
      const { response } = error;
      
      if (response) {
        // Handle specific error status codes
        switch (response.status) {
          case 400:
            console.error('Bad Request:', response.data);
            break;
          case 404:
            console.error('Not Found:', response.data);
            break;
          case 500:
            console.error('Server Error:', response.data);
            break;
          default:
            console.error('API Error:', response.data);
        }
      } else {
        console.error('Network Error:', error.message);
      }
      
      return Promise.reject(error);
    }
  );
  
  return api;
};

