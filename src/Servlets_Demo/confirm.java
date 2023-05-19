package Servlets_Demo;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@WebServlet("/confirm")
public class confirm extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public Connection con;

	public confirm() throws SQLException {
		try {
			Class.forName("org.postgresql.Driver");
			con = DriverManager.getConnection(
					"jdbc:postgresql://192.168.110.48:5432/plf_training?user=plf_training_admin&password=pff123");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println(e);
		}
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		PrintWriter out = res.getWriter();
		StringBuilder bf = new StringBuilder();
		String json = req.getParameter("passengerList");
		Gson gson = new Gson();
		ArrayList<Passenger> passengerArray = gson.fromJson(json, new TypeToken<ArrayList<Passenger>>() {
		}.getType());
		int tno = Integer.parseInt(req.getParameter("trno"));
		String from = req.getParameter("from");
		String to = req.getParameter("to");
		String classes = req.getParameter("classes");
		double tf = Double.parseDouble(req.getParameter("tf"));
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String date = req.getParameter("date");
		try {
			Date parsedDate = dateFormat.parse(date);
			java.sql.Date sqlDate = new java.sql.Date(parsedDate.getTime());
			int c = passengerArray.size();
			PreparedStatement ps = con.prepareStatement(
					"insert into bh_tickets (tkt_trn_no,tkt_tr_date ,tkt_from ,tkt_to,tkt_tr_class,totalfare ) values (?, ?, ?, ?, ?, ?)  RETURNING tkt_id,pnr_no");
			ps.setInt(1, tno);
			ps.setDate(2, sqlDate);
			ps.setString(3, from);
			ps.setString(4, to);
			ps.setString(5, classes);
			ps.setDouble(6, tf);
			ResultSet rs = ps.executeQuery();
			rs.next();
			int tktId = rs.getInt("tkt_id");
			String pnrNo = rs.getString("pnr_no");
			int count = 1;
			for (Passenger passenger : passengerArray) {
				String pname = passenger.getPname();
				int age = passenger.getAge();
				String gender = passenger.getGender();
				double ticketCost = passenger.getTicketCost();

				PreparedStatement ps1 = con.prepareStatement(
						"insert into bh_passengers (tkt_id,tkt_pindex,tkt_name, tkt_age, tkt_gender, tkt_amount) values (?,?,?, ?, ?, ?)");
				ps1.setInt(1, tktId);
				ps1.setInt(2, count);
				ps1.setString(3, pname);
				ps1.setInt(4, age);
				ps1.setString(5, gender);
				ps1.setDouble(6, ticketCost);
				ps1.executeUpdate();
				count += 1;
			}

			if (count == c) {
				bf.append("Ticket Booked..\n");
				bf.append("PNR Number: ").append(pnrNo);
				out.write(bf.toString());
			}
			/*
			 * bf.append(tktId); bf.append(pnrNo); out.write(bf.toString());
			 */
		} catch (Exception e) {
			System.out.println("confirm.java file: " + e);
		}

	}

}
