import { createBrowserRouter, RouterProvider } from "react-router-dom";
import AdminRegistration from "./Pages/AdminRegistration";
import Login from "./Pages/Login";
import RootLayout from "./Pages/RootLayout";
// import PageNotFound from "./Pages/Layout/PageNotFound";

function App() {
  const router = createBrowserRouter([
    {
      path: "/",
      element: <RootLayout />,
      children: [
        { index: true, element: <Login /> },
        // { path: "*", element: <PageNotFound /> },
      ],
    },
    {
      path: "/admin-registration",
      element: <AdminRegistration />,
    },
  ]);
  return <RouterProvider router={router} />
}
export default App;
