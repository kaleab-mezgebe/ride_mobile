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
      <div className="bg-blue-500 text-white p-4 rounded shadow-lg">
        Tailwind CSS is working! ✅
      </div>
    </>
  );
}
export default App;
