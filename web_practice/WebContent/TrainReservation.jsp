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
	$("#trains").change(function(){
		var trn=$("#trains").val();
		if(trn){
			$.ajax({
				url: "classes",
				type: 'GET',
				data: { trn:trn },
				success: function(response) {
					$("#classes").html(response);
				},
				error: function(xhr, status, error) {
					window.alert(error);
				}
			});
		}
	});
	
	$("#date,#classes").change(function(){
		var cls=$("#classes").val();
		var date=$("#date").val();
		if(cls && date){
			$("#pdisp").show();
		}
	});

	var passengerCount = 0;

	$("#add").click(function(event) {
	    event.preventDefault();
	    passengerCount++;
	    document.getElementById('dp').value=passengerCount;
	    var passengerRow= '\
	        <tr id="passenger' + passengerCount + '">\
	            <td>Passenger Name:</td>\
	            <td><input type="text" name="pname' + passengerCount + '" ></td>\
	            <td>Age:</td>\
	            <td><input type="number" name="age' + passengerCount + '" ></td>\
	            <td>Gender:</td>\
	            <td>\
	                <input type="radio" name="gender' + passengerCount + '" value="M">Male \
	                <input type="radio" name="gender' + passengerCount + '" value="F">Female\
	            </td>\
	            <td></td>\
	            <td><button type="button" class="remove">Remove</button></td>\
	        </tr>\
	    ';
	        $("#addanother").append(passengerRow);
	    $('body').on('click', '.remove', function() {
	        $(this).closest('tr').remove();
	        passengerCount--;
	    });
	});   
});
</script>
</head>
<body>
	<form id="reservationForm" action="Preview.jsp" method="post">
	<input type='hidden' id='dp' name='dp' value=0>
		<table align='center' cellpadding='10px'>
			<tr>
				<th>From: </th>
				<td>
					<select name="from" id="from">
					<option value="" disabled selected hidden>Select Source</option>
						<%
							try {
								Class.forName("org.postgresql.Driver");
								con = DriverManager.getConnection("jdbc:postgresql://192.168.110.48:5432/plf_training?user=plf_training_admin&password=pff123");
								ps = con.createStatement();
								rs = ps.executeQuery("select distinct(trn_start) from BH_TRAINS");
								while(rs.next()){
						%>
									<option><%= rs.getString(1) %></option>
						<%
								}
							} catch (Exception e) {
								e.printStackTrace();
							}
						%>
					</select>
				</td>
			</tr>
			
			<tr>
				<th>To: </th>
				<td>
					<select name="to" id="to">
					 <option value="" disabled selected hidden>Select Destination</option>
						<%
							try {
								Class.forName("org.postgresql.Driver");
								con = DriverManager.getConnection("jdbc:postgresql://192.168.110.48:5432/plf_training?user=plf_training_admin&password=pff123");
								ps = con.createStatement();
								rs = ps.executeQuery("select distinct(trn_end) from bh_trains");
								while(rs.next()){
						%>
									<option><%= rs.getString(1) %></option>
						<%
								}
							} catch (Exception e) {
								e.printStackTrace();
							}
						%>
					</select>
				</td>
			</tr>
			<tr>
				<th>Date: </th>
				<td><input type="date" id="date" name="date"></td>
			</tr>
			<tr>
				<th>Trains: </th>
				<td>
					<select id="trains" name="trains"></select>
				</td>
			</tr>
			<tr>
				<th>Class:</th>
				<td>
					<select id="classes" name="classes"></select>
				</td>
			</tr>
		</table>

		<!-- passenger details code starts from here -->
		
		<table id="pdisp" style="display:none;">
		<thead><tr><th>Passenger Details: </th></tr></thead>
			<tr id="passenger0">
				<td>Passenger Name:</td>
				<td><input type="text" name="pname0"></td>
				<td>Age:</td>
				<td><input type="number" name="age0"></td>
				<td>Gender:</td>
				<td>
					<input type="radio" name="gender0" value="M">Male 
					<input type="radio" name="gender0" value="F">Female
				</td>
				<td></td>
				<td><button type="button" class="remove">Remove</button></td>
			</tr>
			<tbody id="addanother"></tbody>
			<tr>
			
				<td><button type="submit" value="add" id="add">Add Passenger</button></td>
				<td><button type="submit" value="Preview" id="preview">Preview Details</button></td>
			</tr>
		</table>
	</form>
</body>
</html>
																																										