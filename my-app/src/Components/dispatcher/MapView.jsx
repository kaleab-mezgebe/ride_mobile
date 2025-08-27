import React, { useEffect } from "react";
import {
  MapContainer,
  TileLayer,
  Marker,
  Popup,
  Polyline,
  useMap,
  CircleMarker,
} from "react-leaflet";
import L from "leaflet";
import { ActionsMenu } from "./TripList";
// import MapClickSetter from "./MapClickSetter";
import SmartMapView from "../../Pages/dispatcher/manualDispatch/SmartMapView";
// Reusable car icon
const carIcon = new L.Icon({
  iconUrl:
    "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/car-icon.png",
  iconRetinaUrl:
    "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/car-icon-2x.png",
  shadowUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
  iconSize: [32, 32],
  iconAnchor: [16, 16],
  popupAnchor: [0, -16],
  shadowSize: [41, 41],
});

// Fit map to points
export function FitToMarkers({ points }) {
  const map = useMap();
  useEffect(() => {
    if (!points?.length) return;
    const bounds = L.latLngBounds(points.map((p) => [p.lat, p.lng]));
    map.fitBounds(bounds.pad(0.3));
  }, [map, points]);
  return null;
}
export default function MapView({
  mapCenter = [8.99, 38.76],
  focusedTrip,
  mapPoints = [],
  pickupLocation,
  dropoffLocation,
  drivers = [],
  activeField,
  handleMapSet,
  onReassign,
  onCancel,
  onEmergency,
}) {
  // Combine all points to fit map
  const allPoints = [
    ...(pickupLocation ? [pickupLocation] : []),
    ...(dropoffLocation ? [dropoffLocation] : []),
    ...(drivers.map((d) => d.location) || []),
    ...(focusedTrip?.driverPos ? [focusedTrip.driverPos] : []),
  ];
  return (
    <div className="w-full h-full min-h-[480px] rounded overflow-hidden">
      <MapContainer
        center={mapCenter}
        zoom={13}
        scrollWheelZoom
        className="w-full h-full"
      >
        <TileLayer
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          attribution="&copy; OpenStreetMap"
        />

        {/* Optional helpers */}
        {/* {activeField && handleMapSet && (
          <MapClickSetter activeField={activeField} onSet={handleMapSet} />
        )} */}
        <SmartMapView pickup={pickupLocation} dropoff={dropoffLocation} />
        {/* Focused Trip Route */}
        {focusedTrip && (
          <>
            <Polyline
              positions={[
                [focusedTrip.pickup.lat, focusedTrip.pickup.lng],
                [focusedTrip.dropoff.lat, focusedTrip.dropoff.lng],
              ]}
            />
            <CircleMarker
              center={[focusedTrip.pickup.lat, focusedTrip.pickup.lng]}
              radius={8}
              pathOptions={{ color: "#3b82f6" }}
            >
              <Popup>
                <div className="text-sm">
                  <div className="font-semibold">Pickup</div>
                  <div>{focusedTrip.pickup.label}</div>
                </div>
              </Popup>
            </CircleMarker>
            <CircleMarker
              center={[focusedTrip.dropoff.lat, focusedTrip.dropoff.lng]}
              radius={8}
              pathOptions={{ color: "#22c55e" }}
            >
              <Popup>
                <div className="text-sm">
                  <div className="font-semibold">Drop-off</div>
                  <div>{focusedTrip.dropoff.label}</div>
                </div>
              </Popup>
            </CircleMarker>
            {focusedTrip.driverPos && (
              <Marker
                position={[
                  focusedTrip.driverPos.lat,
                  focusedTrip.driverPos.lng,
                ]}
                icon={carIcon}
              >
                <Popup>
                  <div className="space-y-1 text-sm">
                    <div className="font-semibold">{focusedTrip.driver}</div>
                    <div>Trip: {focusedTrip.id}</div>
                    <div className="flex items-center gap-2">
                      <span className="inline-flex items-center gap-1 rounded-full border px-2 py-0.5 text-xs font-medium bg-green-100 text-green-800 border-green-300">
                        <span className="inline-block h-1.5 w-1.5 rounded-full bg-current opacity-70" />
                        {focusedTrip.status}
                      </span>
                      <span>ETA {focusedTrip.etaMin}m</span>
                    </div>
                    <div className="pt-2 border-t border-gray-200/10">
                      <ActionsMenu
                        onReassign={() => onReassign(focusedTrip)}
                        onCancel={() => onCancel(focusedTrip)}
                        onEmergency={() => onEmergency(focusedTrip)}
                      />
                    </div>
                  </div>
                </Popup>
              </Marker>
            )}
          </>
        )}

        {/* Pickup / Dropoff markers for booking */}
        {pickupLocation && (
          <Marker position={pickupLocation} icon={carIcon}>
            <Popup>Pickup</Popup>
          </Marker>
        )}
        {dropoffLocation && (
          <Marker position={dropoffLocation} icon={carIcon}>
            <Popup>Drop-off</Popup>
          </Marker>
        )}

        {/* Multiple drivers */}
        {drivers.map((d) => (
          <Marker key={d.id} position={d.location} icon={carIcon}>
            <Popup>
              {d.name} | {d.status}
            </Popup>
          </Marker>
        ))}

        {/* Fit map to all points */}
        <FitToMarkers points={allPoints.length ? allPoints : mapPoints} />
      </MapContainer>
    </div>
  );
}
