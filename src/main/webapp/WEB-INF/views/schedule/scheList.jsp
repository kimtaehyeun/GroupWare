<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
	<title>월간 일정</title>
	<c:import url="../temp/header.jsp"></c:import>
	<c:import url="../temp/style.jsp"></c:import>
	
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	<style>
	    .calendarRow {
	        display: flex;
	        justify-content: flex-start; /* 좌우 간격 없이 붙임 */
	    }
	    .calendarColumnHead {
	        width: 14.2857143%; /* 7일로 나누어 100%를 채움 */
	        text-align: center;
	        border: 1px solid #ccc;
	        padding: 5px;
	        box-sizing: border-box; /* padding이 width에 영향을 주지 않도록 함 */
	        background-color: blue; /* 요일에 파란색 배경 추가 */
	        color: white; /* 글자색을 흰색으로 변경 */
	    }
	    .calendarColumnBox {
	        width: 14.2857143%; /* 7일로 나누어 100%를 채움 */
	        height: 100px; /* 세로 크기 고정 */
	        text-align: center;
	        border: 1px solid #ccc;
	        padding: 5px;
	        box-sizing: border-box; /* padding이 width에 영향을 주지 않도록 함 */
	    }
	    .calendarColumnSunDay {
	        color: red;
	    }
	    .calendarDay {
	        background-color: #f9f9f9;
	        margin: 2px;
	        padding: 2px;
	    }
	    .calendarTooltip {
	        position: absolute;
	        background-color: white;
	        border: 1px solid black;
	        padding: 5px;
	        display: none;
	    }
	</style>
<script>
function fn_formSubmit(){
	document.form1.submit();	
}

var oldid = null;
function calendarDayMouseover(event, id, calendardate){
	if (!id) {
		return;
	}
	
	$(".calendarTooltip").css({left: event.x+"px", top: event.y+"px"});
	$(".calendarTooltip").show();
	if (oldid===id) return;
	oldid=id;
    $.ajax({
    	url: "scheRead4Ajax",
    	cache: false,
    	data: { id : id, calendardate:calendardate },
	    success: function(result){
	    	$(".calendarTooltip").html(result);
		}    
    });	
}

function fn_moveToURL(url, msg){
	if (msg) {
		if (!confirm( msg + " 하시겠습니까??")) return;
	}
	location.href=url;
}

function calendarDayMouseout(){
	$(".calendarTooltip").hide();
}
</script>
    
</head>

<body class="bg-gradient-primary">
    <div id="wrapper">
        <!-- sideBar -->
        <c:import url="../temp/sidebar.jsp"></c:import>
        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">
            <div id="content">
                <c:import url="../temp/topbar.jsp"></c:import>

                <div id="page-wrapper">
                    <div class="row">
                        <div class="col-lg-12">
                            <h1 class="page-header"><i class="fa fa-calendar fa-fw"></i> 월간 일정</h1>
                        </div>
                    </div>
                    
                    <div class="row"> 
                        <div class="col-lg-10">
                            <h1>
                            <a href="#" onclick="fn_moveToURL('scheList?year=<c:out value="${searchVO.year}"/>&month=<c:out value="${searchVO.month-1}"/>', '')"><i class="fa fa-angle-left fa-fw"></i></a>
                            
                            <c:out value="${searchVO.year}"/>년 <c:out value="${searchVO.month}"/>월
                            <a href="#" onclick="fn_moveToURL('scheList?year=<c:out value="${searchVO.year}"/>&month=<c:out value="${searchVO.month+1}"/>', '')"><i class="fa fa-angle-right fa-fw"></i></a>
                            </h1>
                        </div>
                        <div class="col-lg-2">
                            <button class="btn btn-outline btn-primary" style="margin-top:20px;" onclick="fn_moveToURL('scheForm', '')" >일정추가</button>
                        </div>
                    </div>

                    <div class="calendarRow" >
                        <c:forTokens var="item" items="일,월,화,수,목,금,토" delims=",">
                            <div class="calendarColumnHead">${item}</div>
                        </c:forTokens>
                    </div> 

                    <div class="calendarRow">
                        <c:forEach begin="1" end="${dayofweek}">
                            <div class="calendarColumnBox">
                                <div class="calendarColumnDay"></div>
                            </div> 
                        </c:forEach>
                        
                        <c:forEach var="listview" items="${listview}" varStatus="status">
                            <c:set var="calendardayofweek" value="${listview.calendardayofweek}"/>
                            <c:if test='${calendardayofweek=="1"}'> 
                                </div>
                                <div class="calendarRow">
                            </c:if>  
                            
                            <div class="calendarColumnBox">
                                <div class="calendarColumnDay <c:if test='${listview.calendardayofweek=="1"}'>calendarColumnSunDay</c:if>">
                                    <a href="scheForm?calendardate=<c:out value="${listview.calendardate}"/>"><c:out value="${listview.calendardd}"/></a>
                                </div>
                                <c:forEach var="items" items="${listview.list}" varStatus="status">
                                    <div class="calendarDay" onmouseover="calendarDayMouseover(event, '<c:out value="${items.id}"/>', '<c:out value="${listview.calendardate}"/>')" onmouseout="calendarDayMouseout()">
                                        <c:if test='${items.usernum==sessionScope.usernum}'> 
                                            <a href="scheForm?id=<c:out value="${items.id}"/>&seq=<c:out value="${items.seq}"/>"><c:out value="${items.title}"/></a>
                                        </c:if>
                                        <c:if test='${items.id!=null and items.usernum!=sessionScope.usernum}'> 
                                            <a href="scheRead?id=<c:out value="${items.id}"/>&seq=<c:out value="${items.seq}"/>"><c:out value="${items.title}"/></a>
                                        </c:if>
                                        <c:if test='${items.id==null}'> 
                                            <span style="color:<c:out value="${items.fontcolor}"/>"><c:out value="${items.title}"/></span>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:forEach> 

                        <c:forEach begin="${calendardayofweek}" end="6">
                            <div class="calendarColumnBox">
                                <div class="calendarColumnDay"></div>
                            </div> 
                        </c:forEach>   
                    </div>
                    
                    <p>&nbsp;</p>
                    <p>&nbsp;</p>
                    <p>&nbsp;</p> 
                </div>
            </div>

            <!-- Footer -->
            <footer class="sticky-footer bg-white">
                <div class="container my-auto">
                    <div class="copyright text-center my-auto">
                        <span>Copyright © Your Website 2021</span>
                    </div>
                </div>
            </footer>
        </div>
        <!-- /#content-wrapper -->
    </div>
    <!-- /#wrapper -->

    <c:import url="../temp/logoutModal.jsp"></c:import>
    <c:import url="../temp/common_js.jsp"></c:import>
    <div class="calendarTooltip"></div>
</body>
</html>
