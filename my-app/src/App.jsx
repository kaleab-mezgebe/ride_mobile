import { createBrowserRouter, RouterProvider } from "react-router-dom";
import Login from "./Pages/Login";
import RootLayout from "./Pages/RootLayout";
import AdminSignup from "./Pages/AdminSignup";
// import PageNotFound from "./Pages/Layout/PageNotFound";

function App() {
  const router = createBrowserRouter([
    {
      path: "/",
      element: <RootLayout />,
      children: [
        { index: true, element: <Login /> },
        { path: "/Signup", element: <AdminSignup /> },
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
