<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,java.sql.DriverManager,javax.servlet.ServletException,javax.servlet.annotation.WebServlet,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse"%>
<%! Connection con=null;Statement ps=null;ResultSet rs=null;%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Train Reservation System</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	$("#from,#to").change(function(){
		var f=$("#from").val();
		var t=$("#to").val();
		if(f && t){
			$.ajax({
				  url: "trains",
				  type: 'GET',
				  data: { from: f, to: t },
				  success: function(response) {
				    $("#trains").html(response);
				  },
				  error: function(xhr, status, error) {
				    window.alert(error);
				  }
				});
		}
	});
});
$(document).ready(function(){
	$("#add").click(function(){
			$.ajax({
				  url: "addme",
				  type: 'GET',
				  data: { },
				  success: function(response) {
				    $("#pdisp").html(response);
				  },
				  error: function(xhr, status, error) {
				    window.alert(error);
				  }
				});
		}
	});
});
$(document).ready(function(){
	$("#trains").change(function(){
		var tr=$("#trains").val();
		if(tr){
			$("#pdisp").show();
		}
	});
	
});

</script>
</head>
<body>
	<form action="" method="post">
		<table>
		<tr>
			<td>From: </td>
			<td>
			<select name="from" id="from">
				<%
					try {
					Class.forName("org.postgresql.Driver");
					con = DriverManager.getConnection(
							"jdbc:postgresql://192.168.110.48:5432/plf_training?user=plf_training_admin&password=pff123");
					ps = con.createStatement();
					rs = ps.executeQuery("select distinct(trn_start) from BH_TRAINS"); %>
					<option value="" selected disabled hidden>Choose here</option>
					<%while(rs.next()){ %>
						<option><%= rs.getString(1) %></option>
					<%}} catch (Exception e) {
						e.printStackTrace();
					} %>
				
			</select>
			</td>
		</tr>
		<tr>
			<td>To: </td>
			<td>
			<select name="to" id="to">
				<%
				try {
					Class.forName("org.postgresql.Driver");
					Connection con = DriverManager.getConnection(
							"jdbc:postgresql://192.168.110.48:5432/plf_training?user=plf_training_admin&password=pff123");
					ps = con.createStatement();
					rs = ps.executeQuery("select distinct(trn_end) from bh_trains");%>
					<option value="" selected disabled hidden>Choose here</option>
					<%while(rs.next()){ %>
						<option><%= rs.getString(1) %></option>
					<%} } catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}%>
			</select>
			</td>
		</tr>
		<tr>
			<td>Date: </td>
			<td><input type="date" name="date"></td>
		</tr>
		<tr>
			<td>Trains: </td>
			<td><select id="trains"></select></td>
			<td></td>
			<td><div id="disp"></div></td>
		</tr>
		</table>
		
		
		
		
		<!-- passenger details code starts from here -->
		
		
		
		<table id="pdisp" style="display:none;">
		<tr>
			<td>Passenger Name: </td>
			<td><input type="text" name="pname"></td>
		</tr>
		<tr>
			<td>Age: </td>
			<td><input type="number" name="age"></td>
		</tr>
		<tr>
			<td>Gender: </td>
		</tr>
		<tr>
			<td><input type="radio" id="male" name="gender" value="M"></td>
  			<td><label for="Male">Male</label></td>
		</tr>
		<tr>
  			<td><input type="radio" id="female" name="gender" value="F"></td>
  			<td><label for="Female">Female</label></td>
		</tr>
		<tr>
			<td><input type="button" value="add" id="add" onclick="addme()"></td>
		</tr>
		<tr>
			<td><div id="addanother"></div></td>
		</tr>
		</table>
		
	</form>
</body>

</html>