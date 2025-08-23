// import { useEffect, useMemo, useRef, useState } from "react";
// import {
//   MapContainer,
//   TileLayer,
//   Marker,
//   Popup,
//   useMap,
//   useMapEvents,
// } from "react-leaflet";
// import L from "leaflet";
// import "leaflet/dist/leaflet.css";

// // --- Leaflet marker icon
// const defaultIcon = new L.Icon({
//   iconUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png",
//   iconRetinaUrl:
//     "https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png",
//   shadowUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
//   iconSize: [25, 41],
//   iconAnchor: [12, 41],
//   popupAnchor: [0, -28],
//   shadowSize: [41, 41],
// });

// // --- Demo drivers with locations
// const dummyDrivers = [
//   {
//     id: 1,
//     name: "John Doe",
//     vehicle: "Toyota Prius",
//     status: "Available",
//     location: [13.497, 39.48],
//   },
//   {
//     id: 2,
//     name: "Jane Smith",
//     vehicle: "Honda Civic",
//     status: "Available",
//     location: [13.495, 39.477],
//   },
//   {
//     id: 3,
//     name: "Abel Tesfaye",
//     vehicle: "Hyundai i10",
//     status: "Busy",
//     location: [13.498, 39.473],
//   },
// ];

// const vehicleTypes = [
//   { value: "sedan", label: "Sedan" },
//   { value: "suv", label: "SUV" },
//   { value: "hatchback", label: "Hatchback" },
//   { value: "minivan", label: "Minivan" },
// ];

// const DEFAULT_CENTER = [13.4962, 39.4753]; // Mek'ele

// function SmartMapView({ pickup, dropoff }) {
//   const map = useMap();
//   useEffect(() => {
//     if (pickup && dropoff) {
//       const group = L.featureGroup([L.marker(pickup), L.marker(dropoff)]);
//       map.fitBounds(group.getBounds().pad(0.25));
//     } else if (pickup) {
//       map.flyTo(pickup, 16);
//     } else if (dropoff) {
//       map.flyTo(dropoff, 16);
//     }
//   }, [pickup, dropoff, map]);
//   return null;
// }

// function MapClickSetter({ activeField, onSet }) {
//   useMapEvents({
//     async click(e) {
//       const { lat, lng } = e.latlng;
//       try {
//         const res = await fetch(
//           `https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${lng}&accept-language=en`
//         );
//         const data = await res.json();
//         const display =
//           data?.display_name || `${lat.toFixed(6)}, ${lng.toFixed(6)}`;
//         onSet({ lat, lon: lng, display }, activeField);
//       } catch {
//         onSet(
//           { lat, lon: lng, display: `${lat.toFixed(6)}, ${lng.toFixed(6)}` },
//           activeField
//         );
//       }
//     },
//   });
//   return null;
// }

// export default function ManualDispatch() {
//   const [formData, setFormData] = useState({
//     userPhone: "",
//     firstName: "",
//     lastName: "",
//     city: "Mek'ele",
//     pickupAddress: "",
//     dropoffAddress: "",
//     vehicleType: "",
//     passengerNotes: "",
//     selectedDriverId: "",
//   });

//   const [pickupLocation, setPickupLocation] = useState(null);
//   const [dropoffLocation, setDropoffLocation] = useState(null);
//   const [pickupSuggestions, setPickupSuggestions] = useState([]);
//   const [dropoffSuggestions, setDropoffSuggestions] = useState([]);
//   const [activeField, setActiveField] = useState("pickup");

//   const [drivers] = useState(dummyDrivers);

//   const pickupDebounceRef = useRef(null);
//   const dropoffDebounceRef = useRef(null);

//   const handleChange = (e) => {
//     const { name, value } = e.target;
//     setFormData((prev) => ({ ...prev, [name]: value }));
//   };

//   const fetchSuggestions = async (query, type, cityBias) => {
//     if (!query || query.trim().length < 2) {
//       if (type === "pickup") setPickupSuggestions([]);
//       else setDropoffSuggestions([]);
//       return;
//     }
//     const q = cityBias ? `${query}, ${cityBias}` : query;
//     const url = `https://nominatim.openstreetmap.org/search?format=json&addressdetails=1&limit=6&accept-language=en&q=${encodeURIComponent(
//       q
//     )}`;
//     try {
//       const res = await fetch(url, {
//         headers: { "User-Agent": "DispatcherDemo/1.0" },
//       });
//       const data = await res.json();
//       if (type === "pickup") setPickupSuggestions(data);
//       else setDropoffSuggestions(data);
//     } catch {
//       if (type === "pickup") setPickupSuggestions([]);
//       else setDropoffSuggestions([]);
//     }
//   };

//   const onPickupInput = (e) => {
//     handleChange(e);
//     setActiveField("pickup");
//     if (pickupDebounceRef.current) clearTimeout(pickupDebounceRef.current);
//     pickupDebounceRef.current = setTimeout(() => {
//       fetchSuggestions(e.target.value, "pickup", formData.city);
//     }, 300);
//   };

//   const onDropoffInput = (e) => {
//     handleChange(e);
//     setActiveField("dropoff");
//     if (dropoffDebounceRef.current) clearTimeout(dropoffDebounceRef.current);
//     dropoffDebounceRef.current = setTimeout(() => {
//       fetchSuggestions(e.target.value, "dropoff", formData.city);
//     }, 300);
//   };

//   const handleSelectSuggestion = (item, type) => {
//     const lat = parseFloat(item.lat);
//     const lon = parseFloat(item.lon);
//     const address = item.display_name;
//     if (type === "pickup") {
//       setPickupLocation([lat, lon]);
//       setFormData((prev) => ({ ...prev, pickupAddress: address }));
//       setPickupSuggestions([]);
//       setActiveField("dropoff");
//     } else {
//       setDropoffLocation([lat, lon]);
//       setFormData((prev) => ({ ...prev, dropoffAddress: address }));
//       setDropoffSuggestions([]);
//     }
//   };

//   const handleMapSet = ({ lat, lon, display }, type) => {
//     if (type === "pickup") {
//       setPickupLocation([lat, lon]);
//       setFormData((prev) => ({ ...prev, pickupAddress: display }));
//     } else {
//       setDropoffLocation([lat, lon]);
//       setFormData((prev) => ({ ...prev, dropoffAddress: display }));
//     }
//   };

//   const calculateDistance = (loc) => {
//     if (!pickupLocation || !loc) return "-";
//     const point1 = L.latLng(pickupLocation[0], pickupLocation[1]);
//     const point2 = L.latLng(loc[0], loc[1]);
//     return `${(point1.distanceTo(point2) / 1000).toFixed(2)} km`;
//   };

//   const handleAssignRide = () => {
//     const driver = drivers.find(
//       (d) => String(d.id) === formData.selectedDriverId
//     );
//     alert(
//       `Ride assigned!\n\nPassenger: ${formData.firstName} ${
//         formData.lastName
//       } (${formData.userPhone})\nPickup: ${formData.pickupAddress}\nDropoff: ${
//         formData.dropoffAddress
//       }\nDriver: ${driver?.name || "-"}\nVehicle Type: ${
//         formData.vehicleType
//       }\nNotes: ${formData.passengerNotes || "-"}`
//     );
//   };

//   const resetForm = () => {
//     setFormData({
//       userPhone: "",
//       firstName: "",
//       lastName: "",
//       city: "Mek'ele",
//       pickupAddress: "",
//       dropoffAddress: "",
//       vehicleType: "",
//       passengerNotes: "",
//       selectedDriverId: "",
//     });
//     setPickupLocation(null);
//     setDropoffLocation(null);
//     setPickupSuggestions([]);
//     setDropoffSuggestions([]);
//     setActiveField("pickup");
//   };

//   const mapCenter = useMemo(
//     () => pickupLocation || dropoffLocation || DEFAULT_CENTER,
//     [pickupLocation, dropoffLocation]
//   );

//   return (
//     <div className="flex h-screen bg-gray-100">
//       <main className="flex-1 p-6">
//         <h1 className="text-2xl font-bold mb-4">Manual Dispatch</h1>
//         <div className="grid grid-cols-1 xl:grid-cols-3 gap-6 h-[86vh]">
//           {/* LEFT: Form */}
//           <div className="bg-white shadow rounded-lg p-6 overflow-y-auto">
//             <h2 className="text-lg font-semibold mb-4">Passenger Details</h2>
//             <div className="mb-3">
//               <label className="block text-sm text-gray-700 mb-1">Phone</label>
//               <input
//                 type="tel"
//                 name="userPhone"
//                 className="w-full border rounded px-3 py-2"
//                 value={formData.userPhone}
//                 onChange={handleChange}
//               />
//             </div>
//             <div className="grid grid-cols-2 gap-3 mb-3">
//               <div>
//                 <label className="block text-sm text-gray-700 mb-1">
//                   First Name
//                 </label>
//                 <input
//                   type="text"
//                   name="firstName"
//                   className="w-full border rounded px-3 py-2"
//                   value={formData.firstName}
//                   onChange={handleChange}
//                 />
//               </div>
//               <div>
//                 <label className="block text-sm text-gray-700 mb-1">
//                   Last Name
//                 </label>
//                 <input
//                   type="text"
//                   name="lastName"
//                   className="w-full border rounded px-3 py-2"
//                   value={formData.lastName}
//                   onChange={handleChange}
//                 />
//               </div>
//             </div>
//             <div className="mb-3">
//               <label className="block text-sm text-gray-700 mb-1">City</label>
//               <select
//                 name="city"
//                 className="w-full border rounded px-3 py-2"
//                 value={formData.city}
//                 onChange={handleChange}
//               >
//                 <option value="Mek'ele">Mek'ele</option>
//                 <option value="Addis Ababa">Addis Ababa</option>
//                 <option value="Adigrat">Adigrat</option>
//               </select>
//             </div>

//             {/* Pickup Address */}
//             <div className="mb-4 relative">
//               <label className="block text-sm text-gray-700 mb-1">
//                 Pickup Address
//               </label>
//               <input
//                 type="text"
//                 name="pickupAddress"
//                 className="w-full border rounded px-3 py-2"
//                 placeholder="Start typing or click on map"
//                 value={formData.pickupAddress}
//                 onChange={onPickupInput}
//                 onFocus={() => setActiveField("pickup")}
//               />
//               {pickupSuggestions.length > 0 && (
//                 <ul className="absolute z-20 bg-white border w-full max-h-44 overflow-y-auto rounded shadow">
//                   {pickupSuggestions.map((item) => (
//                     <li
//                       key={item.place_id}
//                       className="p-2 hover:bg-gray-100 cursor-pointer text-sm"
//                       onClick={() => handleSelectSuggestion(item, "pickup")}
//                     >
//                       {item.display_name}
//                     </li>
//                   ))}
//                 </ul>
//               )}
//             </div>

//             {/* Dropoff Address */}
//             <div className="mb-4 relative">
//               <label className="block text-sm text-gray-700 mb-1">
//                 Drop-off Address
//               </label>
//               <input
//                 type="text"
//                 name="dropoffAddress"
//                 className="w-full border rounded px-3 py-2"
//                 placeholder="Start typing or click on map"
//                 value={formData.dropoffAddress}
//                 onChange={onDropoffInput}
//                 onFocus={() => setActiveField("dropoff")}
//               />
//               {dropoffSuggestions.length > 0 && (
//                 <ul className="absolute z-20 bg-white border w-full max-h-44 overflow-y-auto rounded shadow">
//                   {dropoffSuggestions.map((item) => (
//                     <li
//                       key={item.place_id}
//                       className="p-2 hover:bg-gray-100 cursor-pointer text-sm"
//                       onClick={() => handleSelectSuggestion(item, "dropoff")}
//                     >
//                       {item.display_name}
//                     </li>
//                   ))}
//                 </ul>
//               )}
//             </div>

//             {/* Vehicle & Notes */}
//             <div className="mb-3">
//               <label className="block text-sm text-gray-700 mb-1">
//                 Vehicle Type
//               </label>
//               <select
//                 name="vehicleType"
//                 className="w-full border rounded px-3 py-2"
//                 value={formData.vehicleType}
//                 onChange={handleChange}
//               >
//                 <option value="">Select vehicle</option>
//                 {vehicleTypes.map((v) => (
//                   <option key={v.value} value={v.value}>
//                     {v.label}
//                   </option>
//                 ))}
//               </select>
//             </div>
//             <div className="mb-4">
//               <label className="block text-sm text-gray-700 mb-1">
//                 Passenger Notes
//               </label>
//               <textarea
//                 name="passengerNotes"
//                 className="w-full border rounded px-3 py-2"
//                 rows={3}
//                 value={formData.passengerNotes}
//                 onChange={handleChange}
//               />
//             </div>

//             {/* Drivers */}
//             <h2 className="text-lg font-semibold mt-6 mb-2">
//               Available Drivers
//             </h2>
//             <ul className="space-y-2 max-h-48 overflow-y-auto">
//               {drivers.map((d) => (
//                 <li
//                   key={d.id}
//                   className="border p-2 rounded flex justify-between items-center"
//                 >
//                   <div>
//                     <p className="font-semibold">{d.name}</p>
//                     <p className="text-sm">
//                       {d.vehicle} | {d.status}
//                     </p>
//                     <p className="text-xs text-gray-500">
//                       Distance: {calculateDistance(d.location)}
//                     </p>
//                   </div>
//                   <button
//                     className="bg-blue-500 hover:bg-blue-600 text-white px-3 py-1 rounded"
//                     onClick={() =>
//                       setFormData((prev) => ({
//                         ...prev,
//                         selectedDriverId: d.id,
//                       }))
//                     }
//                   >
//                     Select
//                   </button>
//                 </li>
//               ))}
//             </ul>

//             {/* Actions */}
//             <div className="flex gap-2 mt-4">
//               <button
//                 className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded"
//                 onClick={() => alert("Fare estimation coming soon!")}
//               >
//                 Get Fare Estimate
//               </button>
//               <button
//                 className="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded"
//                 onClick={handleAssignRide}
//               >
//                 Assign Ride
//               </button>
//               <button
//                 className="bg-gray-200 hover:bg-gray-300 text-gray-800 px-4 py-2 rounded"
//                 onClick={resetForm}
//               >
//                 Reset
//               </button>
//             </div>
//           </div>

//           {/* RIGHT: Map */}
//           <div className="bg-white shadow rounded-lg p-2 xl:col-span-2">
//             <div className="w-full h-full min-h-[480px] xl:h-[calc(86vh-1rem)] rounded overflow-hidden">
//               <MapContainer
//                 center={mapCenter}
//                 zoom={13}
//                 scrollWheelZoom
//                 className="w-full h-full"
//               >
//                 <TileLayer
//                   url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
//                   attribution="&copy; OpenStreetMap"
//                 />
//                 <MapClickSetter
//                   activeField={activeField}
//                   onSet={handleMapSet}
//                 />
//                 <SmartMapView
//                   pickup={pickupLocation}
//                   dropoff={dropoffLocation}
//                 />
//                 {pickupLocation && (
//                   <Marker position={pickupLocation} icon={defaultIcon}>
//                     <Popup>Pickup</Popup>
//                   </Marker>
//                 )}
//                 {dropoffLocation && (
//                   <Marker position={dropoffLocation} icon={defaultIcon}>
//                     <Popup>Drop-off</Popup>
//                   </Marker>
//                 )}
//                 {drivers.map((d) => (
//                   <Marker key={d.id} position={d.location} icon={defaultIcon}>
//                     <Popup>
//                       {d.name} | {d.status}
//                     </Popup>
//                   </Marker>
//                 ))}
//               </MapContainer>
//             </div>
//           </div>
//         </div>
//       </main>
//     </div>
//   );
// }
