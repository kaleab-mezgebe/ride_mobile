import { createBrowserRouter, RouterProvider } from "react-router-dom";
import Login from "./Pages/Login";
import RootLayout from "./Pages/RootLayout";
import AdminSignup from "./Pages/AdminSignup";
import Dashboard from "./Pages/Dashboard";
// import PageNotFound from "./Pages/Layout/PageNotFound";

function App() {
  const router = createBrowserRouter([
    {
      path: "/",
      element: <RootLayout />,
      children: [
        { index: true, element: <Login /> }, // default route → Login
        { path: "signup", element: <AdminSignup /> }, // signup route
        { path: "dashboard", element: <Dashboard /> }, // ✅ dashboard route
        // { path: "*", element: <PageNotFound /> }, // optional - handle 404
      ],
    },
  ]);
  return (
    <>
      <RouterProvider router={router} />
    </>
  );
}

export default App;
