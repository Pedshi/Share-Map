import { configureStore } from '@reduxjs/toolkit';
import authenticationReducer from '../features/login/authSlice';
import placeReducer from '../features/place/placeSlice';

const store = configureStore({
  reducer: {
    authentication: authenticationReducer,
    place: placeReducer
  }
});

export default store;