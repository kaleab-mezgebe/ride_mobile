import React, { createContext, useContext, useState } from "react";
import { generateDummyRides } from "../Pages/RideManagement/rideData";

// Create Context
const RidesContext = createContext();

// Hook for consuming context
export function useRides() {
  return useContext(RidesContext);
}

// Provider component
export function RidesProvider({ children }) {
  const [rides, setRides] = useState(() => generateDummyRides(160));

  // View, Edit, Cancel helpers
  const updateRide = (updatedRide) => {
    setRides((prev) =>
      prev.map((r) => (r.id === updatedRide.id ? updatedRide : r))
    );
  };
  const finishRide = (id) => {
  setRides((prev) =>
    prev.map((r) =>
      r.id === id ? { ...r, status: "Completed", completedBy: "Admin" } : r
    )
  );
};



  const cancelRide = (rideId) => {
    setRides((prev) =>
      prev.map((r) =>
        r.id === rideId ? { ...r, status: "Cancelled", fare: "$0.00" } : r
      )
    );
  };

  const deleteRide = (rideId) => {
    setRides((prev) => prev.filter((r) => r.id !== rideId));
  };

  return (
    <RidesContext.Provider value={{ rides, setRides, updateRide, cancelRide, deleteRide ,finishRide  }}>
      {children}
    </RidesContext.Provider>
  );
}
