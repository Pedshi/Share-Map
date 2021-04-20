import { configureStore } from '@reduxjs/toolkit';
import authenticationReducer from '../features/login/authSlice';

const store = configureStore({
  reducer: {
    authentication: authenticationReducer
  }
});

export default store;