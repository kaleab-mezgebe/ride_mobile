import React from "react";
import UserTable from "../../components/usermanagement/UserTable";
import UserStats from "../../components/usermanagement/UserStats";
import Sidebar from "../../Components/Sidebar";

const ActiveUsers = () => {
  return (
    <div className="flex">
      <Sidebar />

      {/* Main User Table Panel */}
      <div className="dark:bg-gray-900 dark:shadow-gray-700">
        <h1 className="text-2xl font-semibold mb-4 text-gray-900 dark:text-gray-200">
          Active Users
        </h1>
        <UserTable filter="active" />
      </div>

      {/* User Stats Panel */}
      <div className="col-span-4 space-y-4">
        <UserStats />
      </div>
    </div>
  );
};

export default ActiveUsers;
