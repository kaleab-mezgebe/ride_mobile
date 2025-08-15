
import { configureStore } from "@reduxjs/toolkit";
import authReducer from "./authSlice.jsx";

import errorReducer from "./errorSlice.jsx";
import { setupInterceptors } from "../api/api.jsx";
const store = configureStore({
  reducer: {
    auth: authReducer,
    error: errorReducer,
  },
});
setupInterceptors(store);
export default store;
