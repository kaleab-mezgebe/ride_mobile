import React, { useState } from "react";
import { NavLink } from "react-router-dom";
import {
  Box,
  Drawer,
  IconButton,
  List,
  ListItemButton,
  ListItemText,
  Collapse,
  Tooltip,
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
  const [openSidebar, setOpenSidebar] = useState(true);
  const [openUserMenu, setOpenUserMenu] = useState(false);

  const toggleSidebar = () => setOpenSidebar(!openSidebar);

  const navItems = [
    { to: "/admin/dashboard", label: "Dashboard", icon: <MdDashboard /> },
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

  return (
    <Box sx={{ display: "flex" }}>
      {/* Sidebar */}
      <Drawer
        variant="permanent"
        open={openSidebar}
        sx={{
          width: openSidebar ? 240 : 70,
          flexShrink: 0,
          "& .MuiDrawer-paper": {
            width: openSidebar ? 240 : 70,
            boxSizing: "border-box",
            backgroundColor: "#111",
            color: "#fff",
            transition: "width 0.3s ease-in-out",
            overflowX: "hidden",
          },
        }}
      >
        {/* Header with Toggle Button */}
        <Box
          sx={{
            display: "flex",
            alignItems: "center",
            justifyContent: openSidebar ? "space-between" : "center",
            px: 2,
            py: 2,
            borderBottom: "1px solid #333",
          }}
        >
          {openSidebar && (
            <Box sx={{ fontWeight: 700, fontSize: 18 }}>🚗 Nyat Ride</Box>
          )}
          <IconButton onClick={toggleSidebar} sx={{ color: "#fff" }}>
            {openSidebar ? <MdClose /> : <MdMenu />}
          </IconButton>
        </Box>

        {/* Navigation List */}
        <List sx={{ pt: 1 }}>
          {navItems.map((item) => {
            if (item.isDropdown) {
              return (
                <Box key={item.label}>
                  <ListItemButton
                    onClick={() => setOpenUserMenu(!openUserMenu)}
                    sx={{
                      gap: 1.5,
                      py: 1.2,
                      justifyContent: openSidebar ? "flex-start" : "center",
                      "&:hover": { backgroundColor: "#1f2937" },
                      borderRadius: "8px",
                      mx: 1,
                      transition: "background-color 0.2s",
                    }}
                  >
                    <Tooltip
                      title={!openSidebar ? item.label : ""}
                      placement="right"
                    >
                      <Box style={{ fontSize: 22 }}>{item.icon}</Box>
                    </Tooltip>
                    {openSidebar && <ListItemText primary={item.label} />}
                    {openSidebar &&
                      (openUserMenu ? <MdExpandLess /> : <MdExpandMore />)}
                  </ListItemButton>

                  <Collapse
                    in={openUserMenu && openSidebar}
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
                            display: "block",
                          })}
                        >
                          <ListItemButton
                            sx={{
                              pl: 6,
                              py: 1.2,
                              mx: 1,
                              borderRadius: "6px",
                              "&:hover": {
                                backgroundColor: "#3c414bff", // Blue hover
                                color: "#fff",
                                transform: "scale(1.02)",
                                transition: "all 0.2s ease-in-out",
                              },
                              backgroundColor: (isActive) =>
                                isActive ? "#1f2937" : "transparent",
                            }}
                          >
                            <ListItemText
                              primary={subItem.label}
                              primaryTypographyProps={{
                                fontSize: 14,
                                fontWeight: 500,
                              }}
                            />
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
                  display: "block",
                })}
              >
                <ListItemButton
                  sx={{
                    gap: 1.5,
                    py: 1.2,
                    justifyContent: openSidebar ? "flex-start" : "center",
                    "&:hover": { backgroundColor: "#1f2937" },
                    borderRadius: "8px",
                    mx: 1,
                    transition: "background-color 0.2s",
                  }}
                >
                  <Tooltip
                    title={!openSidebar ? item.label : ""}
                    placement="right"
                  >
                    <Box style={{ fontSize: 22 }}>{item.icon}</Box>
                  </Tooltip>
                  {openSidebar && <ListItemText primary={item.label} />}
                </ListItemButton>
              </NavLink>
            );
          })}
        </List>
      </Drawer>
    </Box>
  );
}
