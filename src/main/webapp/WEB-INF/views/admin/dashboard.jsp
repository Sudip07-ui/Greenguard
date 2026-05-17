<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="com.greenguard.model.*,java.util.*" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setAttribute("pageTitle","Admin Dashboard");
%>

<%@ include file="../common/header.jsp" %>

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<%

    int totalCitizens =
            request.getAttribute("totalCitizens") != null
                    ? (Integer)request.getAttribute("totalCitizens")
                    :0;

    int totalAuthorities =
            request.getAttribute("totalAuthorities") != null
                    ? (Integer)request.getAttribute("totalAuthorities")
                    :0;

    List<User> pendingUsers =
            (List<User>)request.getAttribute("pendingUsers");

    List<Violation> recentViolations =
            (List<Violation>)request.getAttribute("recentViolations");

    List<Violation> hotspots =
            (List<Violation>)request.getAttribute("hotspots");

    List<MonitorApplication> pendingMonitors =
            (List<MonitorApplication>)request.getAttribute("pendingMonitors");

    Map<String,Integer> byType =
            (Map<String,Integer>)request.getAttribute("statsByType");

    Map<String,Integer> byStatus =
            (Map<String,Integer>)request.getAttribute("statsByStatus");

    int totalViolations =
            byStatus!=null
                    ?
                    byStatus.values()
                            .stream()
                            .mapToInt(Integer::intValue)
                            .sum()
                    :
                    0;

    int resolved =
            byStatus!=null
                    && byStatus.get("RESOLVED")!=null
                    ?
                    byStatus.get("RESOLVED")
                    :
                    0;


    /* chart data */

    StringBuilder typeLabels = new StringBuilder();
    StringBuilder typeValues = new StringBuilder();

    if(byType!=null){

        for(Map.Entry<String,Integer> e : byType.entrySet()){

            typeLabels
                    .append("'")
                    .append(e.getKey().replace("_"," "))
                    .append("',");

            typeValues
                    .append(e.getValue())
                    .append(",");

        }
    }


    StringBuilder statusLabels =
            new StringBuilder();

    StringBuilder statusValues =
            new StringBuilder();

    if(byStatus!=null){

        for(Map.Entry<String,Integer> e : byStatus.entrySet()){

            statusLabels
                    .append("'")
                    .append(e.getKey().replace("_"," "))
                    .append("',");

            statusValues
                    .append(e.getValue())
                    .append(",");

        }
    }

%>


<style>

    .dashboard-grid{

        display:grid;
        grid-template-columns:2fr 1fr;
        gap:24px;
        margin-bottom:24px;

    }

    .chart-box{

        height:350px;

    }

    .chart-box canvas{

        height:100%!important;
        width:100%!important;

    }

    .card-header h3{

        display:flex;
        align-items:center;
        gap:10px;

    }

    .stat-icon{

        font-size:20px;

    }

</style>



<!-- STATS -->

<div class="stats-grid mb-24">

    <div class="stat-card">

        <div class="stat-icon green">
            <i class="fa-solid fa-users"></i>
        </div>

        <div>

            <div class="stat-value">
                <%=totalCitizens%>
            </div>

            <div class="stat-label">
                Active Citizens
            </div>

        </div>

    </div>




    <div class="stat-card">

        <div class="stat-icon blue">
            <i class="fa-solid fa-user-shield"></i>
        </div>

        <div>

            <div class="stat-value">
                <%=totalAuthorities%>
            </div>

            <div class="stat-label">
                Authorities
            </div>

        </div>

    </div>




    <div class="stat-card">

        <div class="stat-icon amber">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>

        <div>

            <div class="stat-value">
                <%=totalViolations%>
            </div>

            <div class="stat-label">
                Total Reports
            </div>

        </div>

    </div>




    <div class="stat-card">

        <div class="stat-icon green">
            <i class="fa-solid fa-circle-check"></i>
        </div>

        <div>

            <div class="stat-value">
                <%=resolved%>
            </div>

            <div class="stat-label">
                Resolved Cases
            </div>

        </div>

    </div>

</div>





<!-- CHARTS -->

<div class="dashboard-grid">


    <div class="card">

        <div class="card-header">

            <h3>

                <i class="fa-solid fa-chart-column"></i>

                Reports by Type

            </h3>

        </div>

        <div class="card-body">

            <div class="chart-box">

                <canvas id="typeChart"></canvas>

            </div>

        </div>

    </div>





    <div class="card">

        <div class="card-header">

            <h3>

                <i class="fa-solid fa-chart-pie"></i>

                Report Status

            </h3>

        </div>

        <div class="card-body">

            <div class="chart-box">

                <canvas id="statusChart"></canvas>

            </div>

        </div>

    </div>


</div>





<!-- PENDING PANELS -->

<div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;margin-bottom:24px;">


    <div class="card">

        <div class="card-header">

            <h3>

                <i class="fa-solid fa-user-clock"></i>

                Pending Approvals

            </h3>

        </div>

        <div class="card-body" style="padding:0;">

            <%

                if(pendingUsers==null || pendingUsers.isEmpty()){

            %>

            <div style="padding:24px;text-align:center;">

                No pending approvals

            </div>

            <%

            }else{

                for(User u : pendingUsers){

            %>

            <div style="
padding:12px 20px;
display:flex;
justify-content:space-between;
border-bottom:1px solid var(--border);
">

                <div>

                    <div style="font-weight:600;">
                        <%=u.getFullName()%>
                    </div>

                    <div style="font-size:12px;color:gray;">
                        <%=u.getEmail()%>
                    </div>

                </div>

                <button class="btn btn-primary btn-xs">

                    Approve

                </button>

            </div>

            <%
                    }
                }
            %>

        </div>

    </div>






    <div class="card">

        <div class="card-header">

            <h3>

                <i class="fa-solid fa-user-check"></i>

                Monitor Applications

            </h3>

        </div>

        <div class="card-body" style="padding:0;">

            <%

                if(pendingMonitors==null
                        || pendingMonitors.isEmpty()){

            %>

            <div style="padding:24px;text-align:center;">

                No applications

            </div>

            <%

            }else{

                for(MonitorApplication app
                        :pendingMonitors){

            %>

            <div style="
padding:12px 20px;
border-bottom:1px solid var(--border);">

                <b>

                    <%=app.getUserName()%>

                </b>

            </div>

            <%
                    }
                }
            %>

        </div>

    </div>


</div>





<!-- RECENT VIOLATIONS -->

<div class="card">

    <div class="card-header">

        <h3>

            <i class="fa-solid fa-list-check"></i>

            Recent Violations

        </h3>

    </div>

    <div class="card-body">

        <div class="table-wrapper">

            <table>

                <thead>

                <tr>

                    <th>#</th>
                    <th>Title</th>
                    <th>Type</th>
                    <th>Severity</th>
                    <th>Status</th>
                    <th>Reporter</th>
                    <th>Date</th>

                </tr>

                </thead>


                <tbody>

                <%

                    if(recentViolations!=null){

                        for(Violation v
                                :recentViolations){

                %>

                <tr>

                    <td>#<%=v.getId()%></td>
                    <td><%=v.getTitle()%></td>
                    <td><%=v.getType()%></td>
                    <td><%=v.getSeverity()%></td>
                    <td><%=v.getStatus()%></td>
                    <td><%=v.getReporterName()%></td>
                    <td><%=v.getCreatedAt()%></td>

                </tr>

                <%
                        }
                    }
                %>

                </tbody>

            </table>

        </div>

    </div>

</div>





<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>

    document.addEventListener("DOMContentLoaded",()=>{


        new Chart(
            document.getElementById("typeChart"),
            {

                type:'bar',

                data:{

                    labels:[
                        <%=typeLabels.toString()%>
                    ],

                    datasets:[{

                        label:'Reports',

                        data:[
                            <%=typeValues.toString()%>
                        ],

                        backgroundColor:[

                            '#4CAF50',
                            '#2196F3',
                            '#FF9800',
                            '#F44336',
                            '#9C27B0',
                            '#00BCD4'

                        ],

                        borderRadius:8

                    }]

                },

                options:{

                    responsive:true,
                    maintainAspectRatio:false,

                    plugins:{
                        legend:{
                            display:false
                        }
                    }

                }

            }
        );



        new Chart(
            document.getElementById("statusChart"),
            {

                type:'doughnut',

                data:{

                    labels:[
                        <%=statusLabels.toString()%>
                    ],

                    datasets:[{

                        data:[
                            <%=statusValues.toString()%>
                        ],

                        backgroundColor:[

                            '#4CAF50',
                            '#FFC107',
                            '#F44336',
                            '#2196F3'

                        ],

                        hoverOffset:15

                    }]

                },

                options:{

                    responsive:true,
                    maintainAspectRatio:false,
                    cutout:'65%',

                    plugins:{

                        legend:{

                            position:'bottom'

                        }

                    }

                }

            }

        );


    });

</script>

<%@ include file="../common/footer.jsp" %>