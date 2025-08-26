import { createBrowserRouter, RouterProvider } from "react-router-dom";
import { useState } from "react";
import { FaMoon, FaSun } from "react-icons/fa"; 
import Login from "./Pages/Login";
import RootLayout from "./Pages/RootLayout";
import AdminSignup from "./Pages/AdminSignup";
import Dashboard from "./Pages/Dashboard";
import AllUsers from "./Pages/userManagement/AllUsers";
import ActiveUsers from "./Pages/userManagement/ActiveUsers";
import BannedUsers from "./Pages/userManagement/BannedUsers";
import InactiveUsers from "./Pages/userManagement/InactiveUsers";
import ManualDispatch from "./Pages/manualDispatch/ManualDispatch";
import AllRides from "./Pages/RideManagement/AllRides";
import CancelledRides from "./Pages/RideManagement/CancelledRides";
import OngoingRides from "./Pages/RideManagement/OngoingRides";
import CompletedRides from "./Pages/RideManagement/CompletedRides";

import ProtectedRoute from "./Components/ProtectedRoute"; // ✅ role-based protection

function App() {
  const [darkMode, setDarkmode] = useState(false);
  const toggleHandler = () => setDarkmode((prev) => !prev);

  const router = createBrowserRouter([
    {
      path: "/",
      element: <RootLayout />,
      children: [
        { index: true, element: <Login /> },
        { path: "signup", element: <AdminSignup /> },

        // ✅ Admin routes (accessible only to admin)
        {
          path: "dashboard",
          element: (
            <ProtectedRoute allowedRoles={["admin"]}>
              <Dashboard />
            </ProtectedRoute>
          ),
        },
        {
          path: "AllUsers",
          element: (
            <ProtectedRoute allowedRoles={["admin"]}>
              <AllUsers />
            </ProtectedRoute>
          ),
        },
        {
          path: "ActiveUsers",
          element: (
            <ProtectedRoute allowedRoles={["admin"]}>
              <ActiveUsers />
            </ProtectedRoute>
          ),
        },
        {
          path: "BannedUsers",
          element: (
            <ProtectedRoute allowedRoles={["admin"]}>
              <BannedUsers />
            </ProtectedRoute>
          ),
        },
        {
          path: "InactiveUsers",
          element: (
            <ProtectedRoute allowedRoles={["admin"]}>
              <InactiveUsers />
            </ProtectedRoute>
          ),
        },
        {
          path: "admin/rides",
          element: (
            <ProtectedRoute allowedRoles={["admin"]}>
              <AllRides />
            </ProtectedRoute>
          ),
        },
        {
          path: "admin/ongoing",
          element: (
            <ProtectedRoute allowedRoles={["admin"]}>
              <OngoingRides />
            </ProtectedRoute>
          ),
        },
        {
          path: "admin/completed",
          element: (
            <ProtectedRoute allowedRoles={["admin"]}>
              <CompletedRides />
            </ProtectedRoute>
          ),
        },
        {
          path: "admin/cancelled",
          element: (
            <ProtectedRoute allowedRoles={["admin"]}>
              <CancelledRides />
            </ProtectedRoute>
          ),
        },

        // ✅ Dispatcher routes (accessible to both admin and dispatcher)
        // I've updated the allowedRoles prop to include "admin".
        {
          path: "dispatcher",
          element: (
            <ProtectedRoute allowedRoles={["admin", "dispatcher"]}>
              <ManualDispatch />
            </ProtectedRoute>
          ),
        },
        {
          path: "dispatcher/assign",
          element: (
            <ProtectedRoute allowedRoles={["admin", "dispatcher"]}>
              <ManualDispatch />
            </ProtectedRoute>
          ),
        },
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
