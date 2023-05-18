<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.IOException,Servlets_Demo.Passenger,java.util.ArrayList,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,java.sql.DriverManager,java.sql.CallableStatement,java.sql.Types,javax.servlet.ServletException,javax.servlet.annotation.WebServlet,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Preview</title>
    <style>
        /* Add your custom CSS styles here */
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
    $("#confirm").click(function(event){
    	event.preventDefault();
    	var fp=document.getElementById("fp").value;
    	var pass=document.getElementById("passenger").value;
    	console.log(pass);
    	if(fp){
			$.ajax({
				url: "confirm",
				type: 'POST',
				data: { passengerList: pass},
				success: function(response) {
					window.prompt(response);
				},
				error: function(xhr, status, error) {
					window.alert(error);
				}
			});
    	}
    	document.getElementById("confirm").submit();
	});
    </script>
</head>
<body>
    <h2>Travel Details</h2>
    <%Double farePrice=0.0; %>
    <form method="post">
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
			            CallableStatement proc = con.prepareCall("CALL tFare(?,?,?,?,?)");
			            proc.setString(1, request.getParameter("from"));
			            proc.setString(2, request.getParameter("to"));
			            proc.setInt(3, Integer.parseInt(request.getParameter("trains")));
			            proc.setString(4, request.getParameter("classes"));
			            proc.setInt(5, 0);
			            proc.registerOutParameter(1, Types.NUMERIC);
			            proc.execute();
			            Object fp = proc.getObject(1);
			            farePrice = (fp != null) ? ((Number) fp).doubleValue() : 0.0;
			            System.out.println("FarePrice: "+farePrice);
			            proc.close();
			        } catch (Exception e) {
			            System.out.println(e);
			        }
				 %>
				 <%=farePrice %>
			 </td>
		 </tr>
		 <input type="hidden" id="fp" name="fp" value="<%=farePrice%>">
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
			    ArrayList<Passenger> pass = new ArrayList<>();
			    int passengerCount = 0;
			    double tcost = 0.0;
			    double ticketCost = 0.0;
			    String dpParam = request.getParameter("dp");
			    if (dpParam != null) {
			        passengerCount = Integer.parseInt(dpParam);
			    }
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
			        tcost += ticketCost;
			        pass.add(new Passenger(pname, age, gender, ticketCost));
			    }
%>
            <tr>
                <td><%= pname %></td>
                <td><%= age %></td>
                <td><%= gender %></td>
                <td><%= ticketCost%></td>
            </tr>
            <%}%>    
            <input type="hidden" id="passenger" value="<%=pass %>">        
        </tbody>
    </table>
    <p>Ticket Cost: <%=tcost %></p>
    <input type="submit" id="confirm" value="Confirm"> 
    </form>
</body>
</html>


