package Servlets_Demo;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/confirm")
public class confirm extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public confirm() {
		System.out.println("hello");
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		PrintWriter out = res.getWriter();
		StringBuilder bf = new StringBuilder();
		ArrayList<Passenger> passengerArray = (ArrayList<Passenger>) req.getAttribute("passenger");
		int count = 0;
		try {
			Class.forName("org.postgresql.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:postgresql://192.168.110.48:5432/plf_training?user=plf_training_admin&password=pff123");
			int c = passengerArray.size();
			System.out.println(c + " is the size of arrayList");
			for (Passenger passenger : passengerArray) {
				String pname = passenger.getPname();
				int age = passenger.getAge();
				String gender = passenger.getGender();
				double ticketCost = passenger.getTicketCost();
				PreparedStatement ps = con.prepareStatement("insert into bh_passengers values(?,?,?,?)");
				ps.setString(1, pname);
				ps.setInt(2, age);
				ps.setString(3, gender);
				ps.setDouble(4, ticketCost);
				ps.execute();
				count += 1;
			}

			if (count == c) {
				bf.append("Ticket Booked..");
				out.write(bf.toString());
				/* bf.append("Your PNR number is :",pno); */
			}

		} catch (Exception e) {
			System.out.println("confirm.java file: " + e);
		}
	}

}
