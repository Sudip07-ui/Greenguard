package com.greenguard.servlet.citizen;

import com.greenguard.dao.ViolationDAO;
import com.greenguard.dao.WatchlistDAO;
import com.greenguard.model.User;
import com.greenguard.model.Violation;
import com.greenguard.model.WatchlistArea;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/citizen/watchlist")
public class WatchlistServlet extends HttpServlet {

    private final WatchlistDAO watchlistDAO = new WatchlistDAO();
    private final ViolationDAO violationDAO = new ViolationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {

            // USER WATCHLIST AREAS
            List<WatchlistArea> areas =
                    watchlistDAO.findByUser(user.getId());

            req.setAttribute("areas", areas);

            // NEARBY FEED
            List<Violation> nearbyViolations =
                    new ArrayList<>();

            for (WatchlistArea area : areas) {

                nearbyViolations.addAll(
                        violationDAO.findNearbyViolations(
                                area.getLatitude(),
                                area.getLongitude(),
                                area.getRadiusKm()
                        )
                );
            }

            req.setAttribute(
                    "nearbyViolations",
                    nearbyViolations
            );

        } catch (Exception e) {

            req.setAttribute(
                    "error",
                    "Could not load watchlist feed: " + e.getMessage()
            );
        }

        req.getRequestDispatcher(
                "/WEB-INF/views/citizen/watchlist.jsp"
        ).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {

            if ("add".equals(action)) {

                String areaName = req.getParameter("areaName");
                String latStr = req.getParameter("latitude");
                String lngStr = req.getParameter("longitude");
                String radStr = req.getParameter("radiusKm");

                if (areaName == null || areaName.isBlank()) {

                    req.setAttribute(
                            "error",
                            "Area name is required."
                    );

                } else {

                    areaName = areaName.trim();

                    if (watchlistDAO.exists(user.getId(), areaName)) {

                        req.setAttribute(
                                "error",
                                "This area already exists in your watchlist."
                        );

                    } else {

                        double latitude = 0.0;
                        double longitude = 0.0;
                        double radiusKm = 5.0;

                        if (latStr != null && !latStr.isBlank()) {

                            latitude = Double.parseDouble(latStr);

                            if (latitude < -90 || latitude > 90) {
                                throw new IllegalArgumentException(
                                        "Latitude must be between -90 and 90."
                                );
                            }
                        }

                        if (lngStr != null && !lngStr.isBlank()) {

                            longitude = Double.parseDouble(lngStr);

                            if (longitude < -180 || longitude > 180) {
                                throw new IllegalArgumentException(
                                        "Longitude must be between -180 and 180."
                                );
                            }
                        }

                        if (radStr != null && !radStr.isBlank()) {

                            radiusKm = Double.parseDouble(radStr);

                            if (radiusKm < 1 || radiusKm > 50) {
                                throw new IllegalArgumentException(
                                        "Radius must be between 1 and 50 km."
                                );
                            }
                        }

                        WatchlistArea area = new WatchlistArea();

                        area.setUserId(user.getId());
                        area.setAreaName(areaName);
                        area.setLatitude(latitude);
                        area.setLongitude(longitude);
                        area.setRadiusKm(radiusKm);

                        boolean added = watchlistDAO.add(area);

                        if (added) {

                            req.setAttribute(
                                    "success",
                                    "Area added to your watchlist."
                            );

                        } else {

                            req.setAttribute(
                                    "error",
                                    "Could not add watchlist area."
                            );
                        }
                    }
                }

            } else if ("remove".equals(action)) {

                int areaId = Integer.parseInt(
                        req.getParameter("areaId")
                );

                boolean removed = watchlistDAO.remove(
                        areaId,
                        user.getId()
                );

                if (removed) {

                    req.setAttribute(
                            "success",
                            "Area removed from your watchlist."
                    );

                } else {

                    req.setAttribute(
                            "error",
                            "Could not remove watchlist area."
                    );
                }
            }

        } catch (NumberFormatException e) {

            req.setAttribute(
                    "error",
                    "Invalid numeric value provided."
            );

        } catch (IllegalArgumentException e) {

            req.setAttribute(
                    "error",
                    e.getMessage()
            );

        } catch (Exception e) {

            req.setAttribute(
                    "error",
                    "Error updating watchlist: " + e.getMessage()
            );
        }

        doGet(req, resp);
    }
}