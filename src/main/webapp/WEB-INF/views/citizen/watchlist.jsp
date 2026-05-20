<%@ page contentType="text/html;charset=UTF-8"
         import="com.greenguard.model.*,java.util.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setAttribute("pageTitle", "Nearby Violations Feed");

    List<WatchlistArea> areas =
            (List<WatchlistArea>) request.getAttribute("areas");

    List<Violation> nearbyViolations =
            (List<Violation>) request.getAttribute("nearbyViolations");

    String ctx2 = request.getContextPath();
%>

<%@ include file="../common/header.jsp" %>

<!-- PAGE HEADER -->

<div style="margin-bottom:24px;">

    <h1 style="
        display:flex;
        align-items:center;
        gap:10px;
        margin-bottom:8px;
    ">

        <i class="fa-solid fa-eye"></i>

        Nearby Violations Feed
    </h1>

    <p class="text-mute"
       style="max-width:800px;line-height:1.6;">

        Monitor environmental violations reported by other users
        near your selected watchlist areas. Stay informed about
        illegal dumping, pollution, deforestation, hazardous waste,
        and other nearby environmental issues.
    </p>
</div>

<!-- MAIN LAYOUT -->

<div style="
    display:grid;
    grid-template-columns:350px 1fr;
    gap:24px;
    align-items:start;
">

    <!-- LEFT SIDEBAR -->

    <div>

        <!-- ADD WATCHLIST -->

        <div class="card">

            <div class="card-header">

                <h3>
                    <i class="fa-solid fa-plus"></i>
                    Add Watchlist Area
                </h3>
            </div>

            <div class="card-body">

                <form method="POST"
                      action="<%= ctx2 %>/citizen/watchlist">

                    <input type="hidden"
                           name="action"
                           value="add"/>

                    <!-- AREA NAME -->

                    <div class="form-group">

                        <label class="form-label">
                            Area Name
                        </label>

                        <input type="text"
                               name="areaName"
                               class="form-control"
                               placeholder="e.g. Bagmati River Zone"
                               required
                               maxlength="200"/>
                    </div>

                    <!-- LATITUDE -->

                    <div class="form-group">

                        <label class="form-label">
                            Latitude
                        </label>

                        <input type="number"
                               id="latitude"
                               name="latitude"
                               class="form-control"
                               placeholder="27.700769"
                               step="0.000001"/>
                    </div>

                    <!-- LONGITUDE -->

                    <div class="form-group">

                        <label class="form-label">
                            Longitude
                        </label>

                        <input type="number"
                               id="longitude"
                               name="longitude"
                               class="form-control"
                               placeholder="85.318769"
                               step="0.000001"/>
                    </div>

                    <!-- RADIUS -->

                    <div class="form-group">

                        <label class="form-label">
                            Alert Radius (km)
                        </label>

                        <input type="number"
                               name="radiusKm"
                               class="form-control"
                               value="5"
                               min="1"
                               max="50"
                               step="0.5"/>

                        <div class="form-hint">

                            Nearby violations within this radius
                            will appear in your feed.
                        </div>
                    </div>

                    <!-- GEOLOCATION -->

                    <button type="button"
                            id="geoBtn"
                            class="btn btn-secondary btn-sm mb-16">

                        <i class="fa-solid fa-location-dot"></i>

                        Use My Current Location
                    </button>

                    <!-- SUBMIT -->

                    <button type="submit"
                            class="btn btn-primary w-100"
                            style="justify-content:center;">

                        <i class="fa-solid fa-eye"></i>

                        Add to Watchlist
                    </button>

                </form>
            </div>
        </div>

        <!-- SAVED AREAS -->

        <div style="margin-top:24px;">

            <h3 style="
                margin-bottom:14px;
                display:flex;
                align-items:center;
                gap:8px;
            ">

                <i class="fa-solid fa-map-location-dot"></i>

                Saved Areas
                (<%= areas != null ? areas.size() : 0 %>)
            </h3>

            <% if (areas == null || areas.isEmpty()) { %>

            <div class="card">

                <div class="card-body">

                    <div class="empty-state">

                        <div class="empty-icon">
                            <i class="fa-solid fa-eye"></i>
                        </div>

                        <h3>No watchlist areas</h3>

                        <p>
                            Add locations to start monitoring
                            nearby environmental violations.
                        </p>
                    </div>
                </div>
            </div>

            <% } else {

                for (WatchlistArea a : areas) { %>

            <!-- AREA CARD -->

            <div class="card mb-16">

                <div class="card-body">

                    <div style="
                        font-weight:600;
                        margin-bottom:8px;
                        font-size:.95rem;
                    ">

                        📍 <%= a.getAreaName() %>
                    </div>

                    <div class="text-mute"
                         style="font-size:.82rem;">

                        Monitoring nearby violations within

                        <strong>
                            <%= a.getRadiusKm() %> km
                        </strong>
                    </div>

                    <% if (a.getLatitude() != 0.0) { %>

                    <div class="text-mute"
                         style="
                            font-size:.76rem;
                            margin-top:8px;
                         ">

                        🌐
                        <%= String.format("%.5f", a.getLatitude()) %>,
                        <%= String.format("%.5f", a.getLongitude()) %>
                    </div>

                    <% } %>

                    <div style="margin-top:14px;">

                        <form method="POST"
                              action="<%= ctx2 %>/citizen/watchlist">

                            <input type="hidden"
                                   name="action"
                                   value="remove"/>

                            <input type="hidden"
                                   name="areaId"
                                   value="<%= a.getId() %>"/>

                            <button type="submit"
                                    class="btn btn-danger btn-xs"
                                    data-confirm="Remove '<%= a.getAreaName() %>' from your watchlist?">

                                🗑 Remove
                            </button>

                        </form>

                    </div>

                </div>
            </div>

            <% } } %>

        </div>

    </div>

    <!-- FEED -->

    <div>

        <h2 style="
            margin-bottom:20px;
            display:flex;
            align-items:center;
            gap:10px;
        ">

            <i class="fa-solid fa-triangle-exclamation"
               style="color:#dc2626;"></i>

            Nearby Violation Reports
        </h2>

        <% if (nearbyViolations == null ||
                nearbyViolations.isEmpty()) { %>

        <!-- EMPTY FEED -->

        <div class="card">

            <div class="card-body">

                <div class="empty-state">

                    <div class="empty-icon">
                        <i class="fa-solid fa-earth-asia"></i>
                    </div>

                    <h3>No nearby violations yet</h3>

                    <p>
                        Violation reports from nearby users will
                        automatically appear here.
                    </p>

                </div>

            </div>
        </div>

        <% } else {

            for (Violation v : nearbyViolations) { %>

        <!-- POST CARD -->

        <div class="card mb-16">

            <div class="card-body">

                <!-- TOP HEADER -->

                <div style="
                    display:flex;
                    justify-content:space-between;
                    align-items:flex-start;
                    margin-bottom:16px;
                    gap:12px;
                ">

                    <!-- USER -->

                    <div>

                        <div style="
                            font-weight:600;
                            font-size:.95rem;
                        ">

                            👤 <%= v.getReporterName() %>
                        </div>

                        <div class="text-mute"
                             style="
                                font-size:.75rem;
                                margin-top:2px;
                             ">

                            🕒 <%= v.getCreatedAt() %>
                        </div>

                    </div>

                    <!-- BADGES -->

                    <div style="
                        display:flex;
                        gap:8px;
                        flex-wrap:wrap;
                    ">

                        <span class="badge badge-danger">

                            <%= v.getSeverity() %>
                        </span>

                        <span class="badge badge-secondary">

                            <%= v.getStatus() %>
                        </span>

                    </div>

                </div>

                <!-- TITLE -->

                <h3 style="
                    margin-bottom:10px;
                    line-height:1.5;
                ">

                    🚨 <%= v.getTitle() %>
                </h3>

                <!-- TYPE -->

                <div class="text-mute"
                     style="
                        margin-bottom:12px;
                        font-size:.82rem;
                     ">

                    Violation Type:
                    <strong><%= v.getType() %></strong>
                </div>

                <!-- PHOTO -->

                <% if (v.getPhotoUrl() != null &&
                        !v.getPhotoUrl().isBlank()) { %>

                <div style="margin-bottom:16px;">

                    <img
                            src="<%= request.getContextPath() %>/<%= v.getPhotoUrl() %>"
                            style="
                            width:100%;
                            max-height:450px;
                            object-fit:cover;
                            border-radius:14px;
                        "
                    />

                </div>

                <% } %>

                <!-- DESCRIPTION -->

                <div style="
                    line-height:1.7;
                    margin-bottom:16px;
                    font-size:.92rem;
                ">

                    <%= v.getDescription() %>
                </div>

                <!-- LOCATION INFO -->

                <div style="
                    display:flex;
                    flex-wrap:wrap;
                    gap:14px;
                    margin-top:10px;
                    font-size:.82rem;
                ">

                    <!-- LOCATION -->

                    <div class="text-mute">

                        📍
                        <strong>
                            <%= v.getLocationName() %>
                        </strong>
                    </div>

                    <!-- COORDS -->

                    <div class="text-mute">

                        🌐
                        <%= String.format("%.5f", v.getLatitude()) %>,
                        <%= String.format("%.5f", v.getLongitude()) %>
                    </div>

                    <!-- HOTSPOT -->

                    <% if (v.isHotspot()) { %>

                    <div style="
                        color:#dc2626;
                        font-weight:600;
                    ">

                        🔥 Hotspot Area
                    </div>

                    <% } %>

                </div>

                <!-- MAP BUTTON -->

                <div style="margin-top:18px;">

                    <a
                            target="_blank"
                            href="https://www.google.com/maps?q=<%= v.getLatitude() %>,<%= v.getLongitude() %>"
                            class="btn btn-secondary btn-sm"
                    >

                        <i class="fa-solid fa-map-location-dot"></i>

                        View on Map
                    </a>

                </div>

            </div>
        </div>

        <% } } %>

    </div>
</div>

<!-- GEOLOCATION SCRIPT -->

<script>

    document.getElementById("geoBtn")
        .addEventListener("click", function () {

            if (!navigator.geolocation) {

                alert("Geolocation is not supported.");
                return;
            }

            navigator.geolocation.getCurrentPosition(

                function(position) {

                    document.getElementById("latitude").value =
                        position.coords.latitude.toFixed(6);

                    document.getElementById("longitude").value =
                        position.coords.longitude.toFixed(6);

                    alert("Location detected successfully.");
                },

                function() {

                    alert("Unable to retrieve location.");
                }
            );
        });

</script>

<%@ include file="../common/footer.jsp" %>