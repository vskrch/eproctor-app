<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*,java.io.*,java.util.*"%>

<html>
	<%
       if ((session.getAttribute("name")) != null && (session.getAttribute("password") != null) && (session.getAttribute("role").equals("Teacher"))) {
    %>
    <head>

        <meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1, minimum-scale=1">
        <title>EProctor</title>
        <script type="text/javascript" src="/styles/js/jquery.min.js"></script>
        <script type="text/javascript" src="/styles/semantic/dist/semantic.min.js"></script>
        <link rel="stylesheet" type="text/css" href="/styles/semantic/dist/semantic.min.css">
        <style type="text/css">
        .ui-datepicker th { background-color: #CCCCFF; }
        </style>
        <script>    
                $(document).ready(function(){
                    $('.icon.button')
                        .popup({
                             on: 'click'
                        });
                    $('.right.menu.open').on("click",function(e){
                        e.preventDefault();
                        $('.ui.vertical.menu').toggle();
                    });
                
                    $('.ui.dropdown').dropdown();
                    $('.demo.sidebar').first().sidebar('attach events', '.toggle.button');
                    $('.toggle.button').removeClass('disabled');
                });
        </script>
        <script>
             var time = new Date().getTime();
             $(document.body).bind("mousemove keypress", function(e) {
                 time = new Date().getTime();
             });

             function refresh() {
                 if(new Date().getTime() - time >= 16000) 
                     window.location.reload(true);
                 else 
                     setTimeout(refresh, 10000);
             }

             setTimeout(refresh, 10000);
        </script>

    </head>
    
    <body>
        <div class="ui grid">
        <div class="computer tablet only row">
            <div class="ui top fixed inverted menu">
                <img src="/images/eProctor2.png" " width="150px" height="50px" >
 
                <a class="item" href="teacherIndex.jsp">Home</a>
                <a class="active item" href="quizResults.jsp" id="results">Quiz Results</a>
                <div class="right menu">
                    <div class="item">
                   <h3>
                    Welcome <%= session.getAttribute("firstName")%>
                    </h3>
                    </div>
                    <div class="ui dropdown item">
                        More <i class="icon dropdown"></i>
                        <div class="menu">
                            <a class="item" href="editProfile.jsp"><i class="edit icon"></i> Edit Profile</a>
                            
                            <a class="item" class="logout icon" href="/logout.jsp">Logout</a>
                        </div>
                    </div>
                    <div class="item">
                        <form method="get" action="http://www.google.com/search"/>
                            <div class="ui search">
                                <div class="ui icon input">
                                    <input class="prompt" placeholder="Search..." type="text">
                                            <i class="search icon"></i>
                                </div>
                                <div class="results"></div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div class="mobile only row">
            <div class="ui fixed inverted navbar menu">
                <a href="" class="brand item">eProctor</a>
                <div class="right menu open">
                    <a href="" class="menu item">
                        <i class="content icon"></i>
                    </a>
                </div>
            </div>
            <div class="ui vertical navbar menu">
            	<a class="item" href="teacherIndex.jsp">Home</a>
                <a class="active item" href="quizResults.jsp" id="results">Exam Results</a>
                <div class="right menu">
                    <div class="item">
                    <h3>
                    Welcome <%= session.getAttribute("firstName")%>
                    </h3>
                    </div>
                   <a class="item" href="editProfile.jsp"><i class="edit icon"></i> Edit Profile</a>
                    <a class="item" class="logout icon" href="/logout.jsp">Logout</a>
                    <div class="item">
                        <form method="get" action="http://www.google.com/search"/>
                            <div class="ui search">
                                <div class="ui icon input">
                                    <input class="prompt" placeholder="Search..." type="text">
                                            <i class="search icon"></i>
                                </div>
                                <div class="results"></div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <p></p>
    <p></p>
        &nbsp;<br>&nbsp;<br>
    
    <div class="ui stackable grid">
        <div class="ui demo sidebar vertical menu">
        <div class="item">
        <h3>Exams & Results</h3>
        <a class="item" href="teacherIndex.jsp">Current Exams</a>
        <a class="item" href="createExam.jsp">Create Exam</a>
        <a class="item" href="addStudents.jsp">Add Students</a>
        </div>
        
        </div>

        
        <div class="two wide column">
        <br>
        <div class="ui right attached icon toggle button">
            <i class="icon list layout"></i>
            Menu
        </div>
        </div>
        <div class="twelve wide column">

        <%
            String email = session.getAttribute("name").toString();
            int id=0;
            List<Integer> list = new ArrayList<>();
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/eproctor", "eproctor", "shraonessk");
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("select UserId from Details where Email = '"+email+"'");
            if(rs.next())
            {
            	id = Integer.parseInt(rs.getString(1));
            }

            rs = st.executeQuery("select ExamId from requests where UserId='"+id+"'");
        %>
        
            <br>&nbsp;<br>
            <div class="ui header">
        	<h3>Exams Results</h3>
        	</div>
        	<%
        		if(rs.next())
            	{

                    
            %>
            <table class="ui inverted table">
                <thead>
                    <tr>
                    <th style="width:70%">Exam Name</th>
                    <th style="width:30%">View</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    rs = st.executeQuery("select ExamId from requests where UserId='"+id+"'");
                	while(rs.next())
                        {
                            int id1 = rs.getInt(1);
                            list.add(id1);
                            Statement st2 = con.createStatement();
                            ResultSet rs1 = st2.executeQuery("select Name from Exam where ExamId='"+id1+"'");
                            if(rs1.next())
                            {
                                out.println("<form action='displayQuizResults.jsp' method='post'>");
                                out.println("<tr><td>"+rs1.getString(1)+"</td><td>"+"<input type='hidden' name='ExamId' value='"+id1+"'>"+"<button class='ui blue button' name='result'>View</button>"+"</td></tr>");
                                out.println("</form>");
                            }
                        }
                    %>
                </tbody>
            </table>
            <%
        		}
            	else
                {
                	out.println("You have not conducted any exams!!!");
                }
            %>
           </div>
       </div>
    
        &nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>&nbsp;<br>
    </body>
    <%
    } 
    else
    {
    	response.sendRedirect("/index.jsp");
    }
    %>

</html>
