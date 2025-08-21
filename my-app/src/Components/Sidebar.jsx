import React, { useState, useEffect } from "react";
import { NavLink, useLocation } from "react-router-dom";
import {
  Box,
  List,
  ListItemButton,
  ListItemText,
  Collapse,
  IconButton,
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
  MdMenu,
  MdClose,
} from "react-icons/md";

export default function Sidebar() {
  const [openUserMenu, setOpenUserMenu] = useState(false);
  const [collapsed, setCollapsed] = useState(false);
  const location = useLocation();

  const navItems = [
    { to: "/dashboard", label: "Dashboard", icon: <MdDashboard /> },
    { label: "User Management", icon: <MdPeople />, isDropdown: true },
    { to: "/admin/rides", label: "Ride Management", icon: <MdDirectionsCar /> },
    {
      to: "/admin/reports",
      label: "Reports & Analytics",
      icon: <MdAssessment />,
    },
    { to: "/dispatcher", label: "Dispatcher Dashboard", icon: <MdMap /> },
    {
      to: "/dispatcher/assign",
      label: "Manual Assignment",
      icon: <MdAssignment />,
    },
  ];

  const userSubItems = [
    { to: "/AllUsers", label: "All Users" },
    { to: "/ActiveUsers", label: "Active Users" },
    { to: "/InactiveUsers", label: "Inactive Users" },
    { to: "/BannedUsers", label: "Banned Users" },
  ];

  // Keep User Menu open if any sub-item route is active
  useEffect(() => {
    if (userSubItems.some((item) => location.pathname === item.to)) {
      setOpenUserMenu(true);
    }
  }, [location.pathname]);

  return (
    <Box
      component="aside"
      sx={{
        width: collapsed ? 70 : 220,
        flexShrink: 0,
        bgcolor: "#111",
        color: "#fff",
        minHeight: "100vh",
        position: "",
        top: 0,
        overflow: "hidden", // Prevent scroll
        transition: "width 0.3s ease",
        display: "flex",
        flexDirection: "column",
      }}
    >
      {/* Header with Toggle Button */}
      <Box
        sx={{
          px: collapsed ? 1 : 2,
          py: 2,
          fontWeight: 700,
          display: "flex",
          alignItems: "center",
          justifyContent: collapsed ? "center" : "space-between",
          fontSize: 18,
          whiteSpace: "nowrap",
        }}
      >
        {!collapsed && "🚗 Nyat Ride"}
        <IconButton
          onClick={() => setCollapsed(!collapsed)}
          sx={{ color: "#fff", fontSize: 22 }}
        >
          {collapsed ? <MdMenu /> : <MdClose />}
        </IconButton>
      </Box>

      {/* Main Navigation */}
      <List sx={{ pt: 0 }}>
        {navItems.map((item) => {
          if (item.isDropdown) {
            return (
              <Box key={item.label}>
                <ListItemButton
                  onClick={() => setOpenUserMenu(!openUserMenu)}
                  sx={{
                    gap: collapsed ? 0 : 1.5,
                    py: 1.2,
                    justifyContent: collapsed ? "center" : "flex-start",
                    "&:hover": { bgcolor: "#1f2937" },
                  }}
                >
                  <Box style={{ fontSize: 20 }}>{item.icon}</Box>
                  {!collapsed && <ListItemText primary={item.label} />}
                  {!collapsed &&
                    (openUserMenu ? <MdExpandLess /> : <MdExpandMore />)}
                </ListItemButton>
                <Collapse
                  in={openUserMenu && !collapsed}
                  timeout="auto"
                  unmountOnExit
                >
                  <List component="div" disablePadding>
                    {userSubItems.map((subItem) => (
                      <NavLink
                        key={subItem.to}
                        to={subItem.to}
                        style={({ isActive }) => ({
                          textDecoration: "none",
                          color: "#fff",
                          background: isActive ? "#1f2937" : "transparent",
                          display: "block",
                        })}
                      >
                        <ListItemButton
                          sx={{
                            pl: 6,
                            py: 1,
                            "&:hover": { bgcolor: "#374151" },
                          }}
                        >
                          <ListItemText primary={subItem.label} />
                        </ListItemButton>
                      </NavLink>
                    ))}
                  </List>
                </Collapse>
              </Box>
            );
          }

          return (
            <NavLink
              key={item.to}
              to={item.to}
              style={({ isActive }) => ({
                textDecoration: "none",
                color: "#fff",
                background: isActive ? "#1f2937" : "transparent",
                display: "block",
              })}
            >
              <ListItemButton
                sx={{
                  gap: collapsed ? 0 : 1.5,
                  py: 1.2,
                  justifyContent: collapsed ? "center" : "flex-start",
                  "&:hover": { bgcolor: "#1f2937" },
                }}
              >
                <Box style={{ fontSize: 20 }}>{item.icon}</Box>
                {!collapsed && <ListItemText primary={item.label} />}
              </ListItemButton>
            </NavLink>
          );
        })}
      </List>
    </Box>
  );
}
