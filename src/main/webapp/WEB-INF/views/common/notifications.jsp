<%@ page pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
           prefix="c"%>

<jsp:include page="header.jsp"/>

<div class="card"->

    <h2 style="margin-bottom:20px;margin-left:15px; margin-top: 10px ">
        Notifications
    </h2>

    <c:choose>

        <c:when test="${not empty notifications}">

            <c:forEach var="n"
                       items="${notifications}">

                <div class="notification-card"
                     style="
                     padding:15px;
                     margin-bottom:10px;
                     border:1px solid #ddd;
                     border-radius:8px;">

                    <div>
                            ${n.message}
                    </div>

                    <small style="color:gray;">
                            ${n.createdAt}
                    </small>

                </div>

            </c:forEach>

        </c:when>

        <c:otherwise>

            <div style="
                 text-align:center;
                 padding:30px;
                 color:gray;">

                No notifications found

            </div>

        </c:otherwise>

    </c:choose>

</div>

<jsp:include page="footer.jsp"/>