import React from "react";
import UserTable from "../../components/usermanagement/UserTable";
import UserStats from "../../components/usermanagement/UserStats";
import Sidebar from "../../Components/Sidebar";

const AllUsers = () => {
  return (
    <div className="flex">
      <Sidebar />

      {/* Main User Table Panel */}
      <div className="dark:bg-gray-900  dark:shadow-gray-700">
        <h1 className="text-2xl font-semibold mb-4 text-gray-900 dark:text-gray-200">
          All Users
        </h1>
        <UserTable filter="all" />
      </div>
      {/* User Stats Panel */}
      <div className="col-span-4 ">
        <UserStats />
      </div>
    </div>
  );
};

export default AllUsers;
