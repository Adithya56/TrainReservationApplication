package Servlets_Demo;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/addme")
public class addme extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static int passengerCount = 0;

	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		res.setContentType("text/html");
		res.setCharacterEncoding("UTF-8");
		PrintWriter out = res.getWriter();
		StringBuilder sb = new StringBuilder();
		passengerCount++;
		String passengerRow = "<tr id='passenger'+ passengerCount+'><td>Passenger Name:</td><td><input type='text' name='pname'+ passengerCount+'></td><td>Age:</td><td><input type='number' name='age'+ passengerCount+'></td><td>Gender:</td><td><input type='radio' name='gender'+ passengerCount+' value='M'>Male<input type='radio' name='gender'+ passengerCount+' value='F'>Female</td><td></td><td><button type='button' class='remove'>Remove</button></td></tr>";

		sb.append(passengerRow);
		out.write(sb.toString());
	}
}
