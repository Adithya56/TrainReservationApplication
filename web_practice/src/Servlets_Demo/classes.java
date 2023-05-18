package Servlets_Demo;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/classes")
public class classes extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		res.setContentType("text/html");
		res.setCharacterEncoding("UTF-8");
		PrintWriter out = res.getWriter();
		try {
			Class.forName("org.postgresql.Driver");
			Connection con = DriverManager.getConnection(
					"jdbc:postgresql://192.168.110.48:5432/plf_training?user=plf_training_admin&password=pff123");
			int trn = Integer.parseInt(req.getParameter("trn"));
			PreparedStatement ps = con.prepareStatement("select * from bh_tt_classes where trn_no=? ");
			ps.setInt(1, trn);
			ResultSet rs = ps.executeQuery();
			StringBuilder sb = new StringBuilder();
			sb.append("<option value='' selected disabled hidden>Choose here</option>");
			while (rs.next()) {
				sb.append("<option value='" + rs.getString(2) + "'>" + rs.getString(2) + "(" + rs.getInt(1)
						+ ")</option>");
			}
			con.close();
			out.write(sb.toString());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
