<%-- 
    Document   : list.jsp
    Created on : 25 thg 3, 2026, 18:53:45
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách sản phẩm</title>        
        <link rel="stylesheet" href="css/style.css">
        <script type="text/javascript">
            function setCheck(obj) {
                var fries = document.getElementsByName('cidd');

                if ((obj.id == 'c0') && (fries[0].checked == true)) {
                    for (var i = 1; i < fries.length; i++) {
                        fries[i].checked = false;
                    }
                } else {
                    for (var i = 1; i < fries.length; i++) {
                        if (fries[i].checked == true) {
                            fries[0].checked = false;
                            break;
                        }
                    }
                }
                document.getElementById('f1').submit();
            }

            function setCheck1(obj) {
                var fries = document.getElementsByName('price');
                if ((obj.id == 'g0') && (fries[0].checked == true)) {
                    for (var i = 1; i < fries.length; i++) {
                        fries[i].checked = false;
                    }
                } else {
                    for (var i = 1; i < fries.length; i++) {
                        if (fries[i].checked == true) {
                            fries[0].checked = false;
                            break;
                        }
                    }
                }
                document.getElementById('f2').submit();
            }
        </script>
    </head>
    <body>
        <div id="wrapper">
            <a href="home1"> <img src="images/home_icon.jpg"
                                  width="80px" height="80px" alt="home" /> </a>
            <div class="topnav">
                <form action="home1" method="get">
                    <input type="text" placeholder="Search..." name="key" value="${requestScope.key}"/>
                    <button type="submit">
                        <img src="images/search_icon.jpg" width="16px" height="16px"/>
                    </button>
                </form>
            </div>
            <div class="clr"></div>
            
            <div id="menu_tab">
                <c:set var="cat" value="${requestScope.data}"/>
                <c:set var="cid" value="${param.cid}"/>
                <ul class="menu">
                    <li><a class="${(cid==null || cid==0)?"active":""}" href="home1?cid=0">ALL</a></li>
                    <c:forEach items="${cat}" var="c">
                        <li><a class="${c.cid==cid?"active":""}" href="home1?cid=${c.cid}">${c.name}</a></li>
                    </c:forEach>
                </ul>
            </div>

            <div id="content">
                <div id="tab1">
                    <c:set var="chid" value="${requestScope.chid}"/>
                    <h5 style="color: chocolate">TÊN HÃNG</h5>
                    <hr style="border-top: 1px solid chocolate "/>
                    <form id="f1" action="home1">
                        <input type="checkbox" id="c0" name="cidd"
                               ${chid[0]?"checked":""}
                               value="0" onclick="setCheck(this)"/>All<br/>
                        
                        <c:forEach begin="0" end="${cat.size()-1}" var="i">
                            <input type="checkbox" name="cidd"
                                   value="${cat.get(i).cid}"
                                   ${chid[i+1]?"checked":""} onclick="setCheck(this)" />
                            ${cat.get(i).name}
                            <br/>
                        </c:forEach>
                    </form>

                    <h5 style="color: chocolate; margin-top: 20px">MỨC GIÁ</h5>
                    <hr style="border-top: 1px solid chocolate" />

                    <c:set var="pp" value="${requestScope.pp}"/>
                    <c:set var="pb" value="${requestScope.pb}"/>

                    <form id="f2" action="home1">
                        <input type="checkbox" id="g0" name="price" 
                               ${pb[0]?"checked":""} 
                               value="0" onclick="setCheck1(this)"/>Tất cả mức giá<br/>

                        <c:forEach begin="0" end="${4}" var="i">
                            <input type="checkbox" name="price" 
                                   ${pb[i+1]?"checked":""} 
                                   value="${(i+1)}" onclick="setCheck1(this)"/>${pp[i+1]}<br/>
                        </c:forEach>
                    </form>
                </div>

                <div id="tab2">
                    <c:set var="list" value="${requestScope.products}"/>
                    <c:if test="${list!=null}">
                        <h4 style="color: chocolate">DANH SÁCH ĐIỆN THOẠI (${list.size()} sản phẩm)</h4>
                        <ul class="item">
                            <c:forEach items="${list}" var="p">
                                <li>
                                    <a href="#">
                                        <img src="${p.image}" width="80px" height="80px"/>
                                        <p><strong>${p.name}</strong></p>
                                        <p>Giá gốc: <span class="old">${p.price}</span> VND</p>
                                        <p style="color: red">Sale: ${p.price} VND</p>
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:if>
                    
                    <c:if test="${list == null || list.size() == 0}">
                        <p>Không tìm thấy sản phẩm nào phù hợp.</p>
                    </c:if>
                </div>
            </div>
        </div>                
    </body>
</html>