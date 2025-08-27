export default function DriverList({
  drivers,
  formData,
  setFormData,
  calculateDistance,
}) {
  // Calculate distance for each driver
  const driversWithDistance = drivers?.map((d) => ({
    ...d,
    distance:
      formData.pickupAddress && calculateDistance(d.location)
        ? parseFloat(calculateDistance(d.location))
        : Infinity, // Infinity if pickupAddress is empty
  }));
  // Sort drivers by distance
  const sortedDrivers = [...driversWithDistance].sort(
    (a, b) => a.distance - b.distance
  );
  // Closest driver only if pickupAddress is filled
  const closestDriverId =
    formData.pickupAddress && sortedDrivers.length > 0
      ? sortedDrivers[0].id
      : null;
  return (
    <>
      <h2 className="text-lg font-semibold mt-6 mb-2">Available Drivers</h2>
      {/* Dropdown */}
      <div className="mb-4">
        <label className="block text-sm text-gray-700 mb-1">
          Assign Driver
        </label>
        <select
          name="selectedDriverId"
          className="w-full border rounded px-3 py-2"
          value={formData.selectedDriverName ?? ""}
          onChange={(e) =>
            setFormData((prev) => ({
              ...prev,
              selectedDriverName: e.target.value,
            }))
          }
        >
          <option value="">-- Select a driver --</option>
          {sortedDrivers?.map((d) => (
            <option key={d.id} value={d.name}>
              {d.name} ({d.vehicle}) -{" "}
              {formData.pickupAddress ? d.distance.toFixed(2) : "-"}
              {formData.pickupAddress && d.id === closestDriverId
                ? " (Closest)"
                : ""}
            </option>
          ))}
        </select>
      </div>

      {/* Driver List */}
      <ul className="space-y-2 max-h-48 overflow-y-auto">
        {sortedDrivers?.map((d) => (
          <li
            key={d.id}
            className={`border p-2 rounded flex justify-between items-center ${
              formData.pickupAddress && d.id === closestDriverId
                ? "border-green-500 bg-green-50"
                : ""
            }`}
          >
            <div>
              <p className="font-semibold">
                {d.name}{" "}
                {formData.pickupAddress && d.id === closestDriverId && (
                  <span className="text-green-600 text-xs font-medium">
                    (Closest)
                  </span>
                )}
              </p>
              <p className="text-sm">
                {d.vehicle} | {d.status}
              </p>
              <p className="text-xs text-gray-500">
                Distance: {formData.pickupAddress ? d.distance.toFixed(2) : "-"}
                km
              </p>
            </div>
            <button
              className="bg-blue-500 hover:bg-blue-600 text-white px-3 py-1 rounded"
              onClick={() =>
                setFormData((prev) => ({ ...prev, selectedDriverName: d.name }))
              }
            >
              Select
            </button>
          </li>
        ))}
      </ul>
    </>
  );
}
