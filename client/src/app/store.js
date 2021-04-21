import { configureStore } from '@reduxjs/toolkit';
import authenticationReducer from '../features/login/authSlice';
import placeReducer from '../features/createPlace/placeSlice';
import userReducer from '../features/login/userSlice'

const store = configureStore({
  reducer: {
    authentication: authenticationReducer,
    place: placeReducer,
    user: userReducer
  }
});

export default store;