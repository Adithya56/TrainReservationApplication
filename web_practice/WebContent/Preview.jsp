<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,java.sql.DriverManager,java.sql.CallableStatement,java.sql.Types,javax.servlet.ServletException,javax.servlet.annotation.WebServlet,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Preview</title>
    <style>
        /* Add your custom CSS styles here */
    </style>
</head>
<body>
    <h2>Travel Details</h2>
    <%Double farePrice=0.0; %>
    <table id="train" border="1">
        <tr>
            <td>Source</td>
            <td><%= request.getParameter("from") %></td>
        </tr>
        <tr>
            <td>Destination</td>
            <td><%= request.getParameter("to") %></td>
        </tr>
        <tr>
            <td>Date</td>
            <td><%= request.getParameter("date") %></td>
        </tr>
        <tr>
            <td>Train</td>
            <td><%= request.getParameter("trains") %></td>
        </tr>
        <tr>
            <td>Class</td>
            <td><%= request.getParameter("classes") %></td>
        </tr>
        <tr>
	        <td>Fare Price</td>
	        <td>
		        <%
			        try {
			            Class.forName("org.postgresql.Driver");
			            Connection con = DriverManager.getConnection("jdbc:postgresql://192.168.110.48:5432/plf_training?user=plf_training_admin&password=pff123");
			            CallableStatement proc = con.prepareCall("CALL trainFare(?,?,?,?,?)");
			            proc.setString(1, request.getParameter("from"));
			            proc.setString(2, request.getParameter("to"));
			            proc.setInt(3, Integer.parseInt(request.getParameter("trains")));
			            proc.setString(4, request.getParameter("classes"));
			            proc.setInt(5, 0);
			            proc.registerOutParameter(1, Types.NUMERIC);
			            proc.execute();
			            Object fp = proc.getObject(1);
			            farePrice = (fp != null) ? ((Number) fp).doubleValue() : null;
			            proc.close();
			        } catch (Exception e) {
			            System.out.println(e);
			        }
				 %>
				 <%=farePrice %>
			 </td>
		 </tr>
    </table>
    <h2>Passenger Details</h2>
    <table id="pass" border="1">
        <thead>
            <tr>
                <th>Passenger Name</th>
                <th>Age</th>
                <th>Gender</th>
                <th>Cost</th>
            </tr>
        </thead>
        <tbody id="disp">
            <% 
	            int passengerCount = Integer.parseInt(request.getParameter("dp"));
            	double tcost=0.0;
            	double ticketCost=0.0;
	            for (int i = 0; i <= passengerCount; i++) { 
	                String pname = request.getParameter("pname" + i);
	                int age = Integer.parseInt(request.getParameter("age" + i));
	                String gender = request.getParameter("gender" + i);
	                if ((age > 65 && gender.equals("M")) || (age > 58 && gender.equals("F")))
	        			ticketCost = farePrice * 0.75f;
	        		else if (age < 5)
	        			ticketCost = 0;
	        		else if (age < 12)
	        			ticketCost = farePrice * 0.50f;
	        		else
	        			ticketCost = farePrice;
	                tcost+=ticketCost;
            %>
            <tr>
                <td><%= pname %></td>
                <td><%= age %></td>
                <td><%= gender %></td>
                <td><%= ticketCost%></td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <p>Ticket Cost: <%=tcost %></p>
</body>
</html>


