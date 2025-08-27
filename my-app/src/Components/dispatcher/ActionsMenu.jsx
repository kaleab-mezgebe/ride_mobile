// src/Pages/dispatcher/components/ActionsMenu.jsx
import React from "react";

export default function ActionsMenu({ onReassign, onCancel, onEmergency }) {
  return (
    <div className="flex flex-wrap gap-2">
      <button
        onClick={onReassign}
        className="rounded-xl bg-indigo-500/90 hover:bg-indigo-500 text-white px-3 py-1.5 text-sm shadow-sm"
      >
        Reassign
      </button>
      <button
        onClick={onCancel}
        className="rounded-xl bg-gray-700 hover:bg-gray-600 text-gray-100 px-3 py-1.5 text-sm shadow-sm"
      >
        Cancel
      </button>
      <button
        onClick={onEmergency}
        className="rounded-xl bg-red-600 hover:bg-red-500 text-white px-3 py-1.5 text-sm shadow-sm"
      >
        Emergency
      </button>
    </div>
  );
}
