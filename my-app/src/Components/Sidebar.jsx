import React, { useEffect, useState } from "react";
import { NavLink, useLocation } from "react-router-dom";
import {
  Box,
  List,
  ListItemButton,
  ListItemText,
  Collapse,
} from "@mui/material";
import {
  MdDashboard,
  MdPeople,
  MdDirectionsCar,
  MdAssessment,
  MdMap,
  MdAssignment,
  MdExpandLess,
  MdExpandMore,
} from "react-icons/md";

export default function Sidebar() {
  const location = useLocation();

  const [openRides, setOpenRides] = useState(() => {
    const saved = localStorage.getItem("nyat_open_rides");
    if (saved !== null) return saved === "true";
    return location.pathname.startsWith("/admin/rides");
  });

  useEffect(() => {
    if (location.pathname.startsWith("/admin/rides")) {
      setOpenRides(true);
    }
  }, [location.pathname]);

  useEffect(() => {
    localStorage.setItem("nyat_open_rides", String(openRides));
  }, [openRides]);

  // shared styles for ListItemButton
  const listItemSx = {
    gap: 1.5,
    py: 1.2,
    "&:hover": {
      bgcolor: "rgba(37, 99, 235, 0.2)", // transparent blue hover
    },
  };

  const linkStyle = ({ isActive }) => ({
    textDecoration: "none",
    color: "#fff",
    background: isActive ? "rgba(37, 99, 235, 0.3)" : "transparent",
    display: "block",
  });

  return (
    <Box
      component="aside"
      sx={{
        width: 240,
        flexShrink: 0,
        bgcolor: "#111",
        color: "#fff",
        height: "100vh",
        position: "sticky",
        top: 0,
        overflowY: "auto",
      }}
    >
      <Box
        sx={{
          px: 2,
          py: 2,
          fontWeight: 700,
          display: "flex",
          alignItems: "center",
          gap: 1,
          fontSize: 18,
        }}
      >
        🚗 Nyat Ride
      </Box>

      <List sx={{ pt: 0 }}>
        {/* Dashboard */}
        <NavLink to="/dashboard" style={linkStyle} end>
          <ListItemButton sx={listItemSx}>
            <MdDashboard style={{ fontSize: 20 }} />
            <ListItemText primary="Dashboard" />
          </ListItemButton>
        </NavLink>

        {/* User Management */}
        <NavLink to="/admin/users" style={linkStyle}>
          <ListItemButton sx={listItemSx}>
            <MdPeople style={{ fontSize: 20 }} />
            <ListItemText primary="User Management" />
          </ListItemButton>
        </NavLink>

        {/* Ride Management with Collapse */}
        <ListItemButton onClick={() => setOpenRides((v) => !v)} sx={listItemSx}>
          <MdDirectionsCar style={{ fontSize: 20 }} />
          <ListItemText primary="Ride Management" />
          {openRides ? <MdExpandLess /> : <MdExpandMore />}
        </ListItemButton>

        <Collapse in={openRides} timeout="auto" unmountOnExit>
          <List component="div" disablePadding>
            <NavLink to="/admin/rides" style={linkStyle}>
              <ListItemButton sx={{ ...listItemSx, pl: 6 }}>
                <ListItemText primary="All Rides" />
              </ListItemButton>
            </NavLink>

            <NavLink to="/admin/ongoing" style={linkStyle}>
              <ListItemButton sx={{ ...listItemSx, pl: 6 }}>
                <ListItemText primary="Ongoing Rides" />
              </ListItemButton>
            </NavLink>

            <NavLink to="/admin/completed" style={linkStyle}>
              <ListItemButton sx={{ ...listItemSx, pl: 6 }}>
                <ListItemText primary="Completed Rides" />
              </ListItemButton>
            </NavLink>

            <NavLink to="/admin/cancelled" style={linkStyle}>
              <ListItemButton sx={{ ...listItemSx, pl: 6 }}>
                <ListItemText primary="Cancelled Rides" />
              </ListItemButton>
            </NavLink>
          </List>
        </Collapse>

        {/* Reports */}
        <NavLink to="/admin/reports" style={linkStyle}>
          <ListItemButton sx={listItemSx}>
            <MdAssessment style={{ fontSize: 20 }} />
            <ListItemText primary="Reports & Analytics" />
          </ListItemButton>
        </NavLink>

        {/* Dispatcher */}
        <NavLink to="/dispatcher" style={linkStyle}>
          <ListItemButton sx={listItemSx}>
            <MdMap style={{ fontSize: 20 }} />
            <ListItemText primary="Dispatcher Dashboard" />
          </ListItemButton>
        </NavLink>

        <NavLink to="/dispatcher/assign" style={linkStyle}>
          <ListItemButton sx={listItemSx}>
            <MdAssignment style={{ fontSize: 20 }} />
            <ListItemText primary="Manual Assignment" />
          </ListItemButton>
        </NavLink>
      </List>
    </Box>
  );
}
