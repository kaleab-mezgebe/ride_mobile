import React from "react";
import UserTable from "../../components/userManagement/UserTable";
import UserStats from "../../components/userManagement/UserStats";
import Sidebar from "../../Components/Sidebar";

const Passengers = () => {
  return (
    <div className="flex">
      <Sidebar />

      {/* Main User Table Panel */}
      <div className="dark:bg-gray-900  dark:shadow-gray-700">
        <h1 className="text-2xl font-semibold mb-4 text-gray-900 dark:text-gray-200">
          Passengers{" "}
        </h1>
        <UserTable filter="passengers" />
      </div>
      <div className="flex flex-col justify-bitween items-center">
        <UserStats />
      </div>
    </div>
  );
};

export default Passengers;
