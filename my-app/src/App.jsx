import { createBrowserRouter, RouterProvider } from "react-router-dom";
import { useState } from "react";
import { FaMoon, FaSun } from "react-icons/fa";

import RootLayout from "./Pages/RootLayout";
import Login from "./Pages/Login";
import AdminSignup from "./Pages/AdminSignup";
import Dashboard from "./Pages/Dashboard";

// User Management
import AllUsers from "./Pages/userManagement/AllUsers";
import Dispatchers from "./Pages/userManagement/Dispatchers";
import Passengers from "./Pages/userManagement/Passengers";
import Drivers from "./Pages/userManagement/Drivers";

// Dispatcher
import ManualDispatch from "./Pages/manualDispatch/ManualDispatch";

// Ride Management
import AllRides from "./Pages/RideManagement/AllRides";
import OngoingRides from "./Pages/RideManagement/OngoingRides";
import CompletedRides from "./Pages/RideManagement/CompletedRides";
import CancelledRides from "./Pages/RideManagement/CancelledRides";
function App() {
  const [darkMode, setDarkmode] = useState(false);
  const toggleHandler = () => setDarkmode((prev) => !prev);

  const router = createBrowserRouter([
    {
      path: "/",
      element: <RootLayout />,
      children: [
        // Auth + dashboard
        { index: true, element: <Login /> },
        { path: "signup", element: <AdminSignup /> },
        { path: "dashboard", element: <Dashboard /> },

        // ---- User Management (canonical paths) ----
        { path: "admin/users", element: <AllUsers /> },
        { path: "admin/users/drivers", element: <Drivers /> },
        { path: "admin/users/passengers", element: <Passengers /> },
        { path: "admin/users/dispatchers", element: <Dispatchers /> },

        // ---- User Management (legacy aliases; safe to keep for now) ----
        { path: "AllUsers", element: <AllUsers /> },
        { path: "drivers", element: <Drivers /> },
        { path: "passengers", element: <Passengers /> },
        { path: "dispatchers", element: <Dispatchers /> },

        // ---- Ride Management (canonical, lowercase) ----
        { path: "admin/rides", element: <AllRides /> },
        { path: "admin/ongoing", element: <OngoingRides /> },
        { path: "admin/completed", element: <CompletedRides /> },
        { path: "admin/cancelled", element: <CancelledRides /> },

        // ---- Ride Management (legacy aliases for backward compat) ----
        { path: "admin/Ongoing", element: <OngoingRides /> },
        { path: "admin/Completed", element: <CompletedRides /> },

        // ---- Dispatcher ----
        { path: "dispatcher", element: <ManualDispatch /> },

        // Optional 404
        // { path: "*", element: <PageNotFound /> },
      ],
    },
  ]);

  return (
    <div className={darkMode ? "dark" : ""}>
      <div className="min-h-screen bg-white text-black dark:bg-gray-900 dark:text-white transition-colors duration-300 py-3">
        <RouterProvider router={router} />
        <button
          onClick={toggleHandler}
          className="absolute top-4 right-4 p-2 rounded-full bg-gray-200 dark:bg-gray-700 text-black dark:text-white shadow-md hover:scale-110 transition-transform"
        >
          {darkMode ? <FaSun /> : <FaMoon />}
        </button>
      </div>
    </div>
  );
}

export default App;
