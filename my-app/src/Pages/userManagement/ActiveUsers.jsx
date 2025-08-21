import React from "react";
import UserTable from "../../components/usermanagement/UserTable";
import UserStats from "../../components/usermanagement/UserStats";
import Sidebar from "../../Components/Sidebar";

const ActiveUsers = () => {
  return (
    <div className="flex">
      <Sidebar />
      <div className="grid grid-cols-12 gap-6">
        {/* Main User Table Panel */}
        <div className="col-span-8 bg-white dark:bg-gray-900 p-6 rounded-lg shadow dark:shadow-gray-700">
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
    </div>
  );
};

export default ActiveUsers;
