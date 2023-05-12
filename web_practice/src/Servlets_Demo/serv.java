package Servlets_Demo;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/serv")
public class serv extends HttpServlet {
	public serv() {
		System.out.println("hii");
	}

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		try {
			Class.forName("org.postgresql.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:postgresql://192.168.110.48:5432/plf_training?user=plf_training_admin&password=pff123");
			Statement ps = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = ps.executeQuery("select * from adi_acc");
			rs.moveToInsertRow();
			rs.updateInt(1, Integer.parseInt(request.getParameter("acno")));
			rs.updateString(2, request.getParameter("name"));
			rs.updateDate(3, java.sql.Date.valueOf(request.getParameter("date")));
			rs.updateDouble(4, Double.parseDouble(request.getParameter("bal")));
			rs.updateRow();
			rs.insertRow();
			out.println("New Account inserted..");
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
